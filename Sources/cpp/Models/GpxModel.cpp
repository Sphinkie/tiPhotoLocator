#include "GpxModel.h"
#include "PhotoModel.h"

#include <QDir>
#include <QFile>
#include <QXmlStreamReader>
#include <algorithm>  // pour lower_bound


/** **********************************************************************************************************
 * @brief Constructeur.
 * ***********************************************************************************************************/
GpxModel::GpxModel(QObject *parent) : QAbstractListModel{parent}
{
}


/** **********************************************************************************************************
 * @brief Retourne le nombre de fichiers GPX dans le modèle.
 * ***********************************************************************************************************/
int GpxModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid()) return 0;
    return m_files.size();
}


/** **********************************************************************************************************
 * @brief Retourne la donnée pour un rôle donné.
 * ***********************************************************************************************************/
QVariant GpxModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() >= m_files.size())
        return {};

    const GpxFileInfo& f = m_files.at(index.row());
    switch (role)
    {
        case NameRole:      return f.name;
        case FilePathRole:  return f.filePath;
        case StartTimeRole: return f.startTime;
    }
    return {};
}


/** **********************************************************************************************************
 * @brief Retourne la table de correspondance rôle → nom QML.
 * ***********************************************************************************************************/
QHash<int, QByteArray> GpxModel::roleNames() const
{
    return {
        { NameRole,      "name"      },
        { FilePathRole,  "filePath"  },
        { StartTimeRole, "startTime" },
    };
}


/** **********************************************************************************************************
 * @brief Vide le modèle et le remplit avec les fichiers GPX trouvés dans les sous-dossiers.
 *
 * Recherche dans <folderUrl>/GPX/ et <folderUrl>/GPSLOG/ (insensible à la casse sur Windows).
 * Les GPX sont dans les sous-dossiers GPX/ ou GPSLOG/.
 * Les fichiers sont triés par ordre alphabétique.
 * @param folderUrl : URL du dossier de photos actif.
 * ***********************************************************************************************************/
void GpxModel::refresh(const QUrl& folderUrl)
{
    const QString folderPath = folderUrl.toLocalFile();
    if (folderPath.isEmpty()) return;

    beginResetModel();
    m_files.clear();

    QDir baseDir(folderPath);
    for (const QString& subdir : {"GPX", "GPSLOG"})
    {
        QDir gpxDir(baseDir.filePath(subdir));
        if (!gpxDir.exists()) continue;

        const QFileInfoList entries = gpxDir.entryInfoList({"*.gpx", "*.GPX"}, QDir::Files, QDir::Name);
        for (const QFileInfo& fi : entries)
        {
            GpxFileInfo info;
            info.name      = fi.fileName();
            info.filePath  = fi.absoluteFilePath();
            info.startTime = readStartTime(fi.absoluteFilePath());
            m_files.append(info);
        }
    }

    endResetModel();

    // On vide le tracé courant — il n'est plus valide après un changement de dossier.
    m_currentTrackPoints.clear();
    emit currentTrackPointsChanged();
}


/** **********************************************************************************************************
 * @brief Charge le tracé du fichier GPX sélectionné dans currentTrackPoints.
 *
 * @param row : index dans le modèle. Passer -1 pour vider le tracé.
 * ***********************************************************************************************************/
void GpxModel::selectTrack(int row)
{
    if (row < 0 || row >= m_files.size())
    {
        m_currentTrack.clear();
        m_currentTrackPoints.clear();
        emit currentTrackPointsChanged();
        return;
    }
    m_currentTrack = parseTrack(m_files.at(row).filePath);
    m_currentTrackPoints.clear();
    for (const GpxTrackPoint& pt : std::as_const(m_currentTrack))
        m_currentTrackPoints.append(QVariant::fromValue(pt.coord));
    emit currentTrackPointsChanged();
}


/** **********************************************************************************************************
 * @brief Parse tous les <trkpt> du fichier GPX et retourne les points avec coordonnées ET timestamps.
 *
 * Structure GPX : <trkpt lat="..." lon="..."><time>ISO8601</time>...</trkpt>
 * @param filePath : chemin absolu du fichier .gpx.
 * @return QVector<GpxTrackPoint> trié chronologiquement.
 * ***********************************************************************************************************/
QVector<GpxTrackPoint> GpxModel::parseTrack(const QString& filePath)
{
    QVector<GpxTrackPoint> points;
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return points;

    QXmlStreamReader xml(&file);
    while (!xml.atEnd() && !xml.hasError())
    {
        xml.readNext();
        if (!xml.isStartElement() || xml.name() != QLatin1String("trkpt"))
            continue;

        const QXmlStreamAttributes attrs = xml.attributes();
        bool latOk = false, lonOk = false;
        const double lat = attrs.value("lat").toDouble(&latOk);
        const double lon = attrs.value("lon").toDouble(&lonOk);
        if (!latOk || !lonOk) continue;

        // Lit les éléments enfants de <trkpt> pour trouver <time>
        QDateTime time;
        while (!xml.atEnd())
        {
            xml.readNext();
            if (xml.isEndElement() && xml.name() == QLatin1String("trkpt"))
                break;
            if (xml.isStartElement() && xml.name() == QLatin1String("time"))
                time = QDateTime::fromString(xml.readElementText(), Qt::ISODate);
        }

        points.append({QGeoCoordinate(lat, lon), time});
    }
    return points;
}


/** **********************************************************************************************************
 * @brief Pour chaque photo du modèle, recherche si son horodatage correspond à un point du track.
 *        En cas de correspondance, stocke les coordonnées GPS interpolées dans la photo (temporaire).
 *
 * @param photoModelObj : le PhotoModel (passé comme QObject* pour être appelable depuis QML).
 * @param offsetHours   : décalage caméra - GPS en heures entières.
 *                        Exemple : +2 signifie que la caméra affiche 14:00 quand le GPS indique 12:00.
 * ***********************************************************************************************************/
void GpxModel::matchPhotos(QObject* photoModelObj, int offsetHours)
{
    PhotoModel* photoModel = qobject_cast<PhotoModel*>(photoModelObj);
    if (!photoModel) return;
    // On resette la track précédente
    photoModel->resetOnTrack();
    if (m_currentTrack.isEmpty()) return;

    // On calcule l'heure de début et de fin de la track
    const qint64 offsetSecs  = qint64(offsetHours) * 3600;
    const QDateTime trackStart = m_currentTrack.first().time;
    const QDateTime trackEnd   = m_currentTrack.last().time;
    if (!trackStart.isValid() || !trackEnd.isValid()) return;

    // On parcourt tout le PhotoModel
    int firstOnTrackRow = -1;
    int matchCount = 0;
    for (int row = 0; row < photoModel->rowCount(); ++row)
    {
        const QModelIndex idx = photoModel->index(row, 0);
        const QString dateStr = idx.data(PhotoModel::DateTimeOriginalRole).toString();
        if (dateStr.isEmpty()) continue;

        // On lit de Datetime de chaque photo
        // Format EXIF : "yyyy:MM:dd HH:mm:ss", pas de fuseau horaire
        QDateTime photoTime = QDateTime::fromString(dateStr, "yyyy:MM:dd HH:mm:ss");
        if (!photoTime.isValid()) continue;

        // Heure Photo en équivalent GPS ("fixed time") = heure caméra - décalage
        const QDateTime photoFixedTime = photoTime.addSecs(-offsetSecs);

        // Si hors plage de la track → on ignore
        if (photoFixedTime < trackStart || photoFixedTime > trackEnd) continue;

        // Recherche le premier point dont time >= gpsTime
        // std::lower_bound (itérateur début, itr final, valeur cherchée, fonction de comparation "<")
        // Cela fait une recherche binaire dans un tableau trié (donc rapide).
        // Elle retourne un itérateur vers le premier élément qui n'est pas inférieur à la valeur cible.
        auto it = std::lower_bound(m_currentTrack.cbegin(), m_currentTrack.cend(), photoFixedTime,
            [](const GpxTrackPoint& pt, const QDateTime& t) { return pt.time < t; });
        // La fonction lambda indique à l'algorithme comment comparer un GpxTrackPoint et un QDateTime.

        double lat, lon;
        // si l'itérateur trouvé est le premier, on prend ses coordonnées.
        if (it == m_currentTrack.cbegin())
        {
            lat = it->coord.latitude();
            lon = it->coord.longitude();
        }
        // si l'itérateur trouvé est le dernier, on prend les coordonnées du précédent.
        else if (it == m_currentTrack.cend())
        {
            --it;
            lat = it->coord.latitude();
            lon = it->coord.longitude();
        }
        // Sinon: interpolation linéaire entre le point précédent et le point courant
        else
        {
            const auto prev  = std::prev(it); // prev = pointeur vers le TrackPoint précédent
            const qint64 span   = prev->time.secsTo(it->time); // nombre de secondes entre prev et it
            const qint64 offset = prev->time.secsTo(photoFixedTime); // nombre de secondes entre prev et photo
            const double t = (span > 0) ? double(offset) / double(span) : 0.0;
            // on applique le ratio d'interpolation
            lat = prev->coord.latitude()  + t * (it->coord.latitude()  - prev->coord.latitude());
            lon = prev->coord.longitude() + t * (it->coord.longitude() - prev->coord.longitude());
        }
        // La photo ayant été trouvée, on positionne le flag "isOnTrack" et on envoie ses coords supposées.
        photoModel->setOnTrack(row, lat, lon);
        if (firstOnTrackRow == -1) firstOnTrackRow = row;
        ++matchCount;
    }

    m_matchCount = matchCount;
    emit matchCountChanged();
    if (firstOnTrackRow >= 0)
        emit firstOnTrackFound(firstOnTrackRow);
}


/** **********************************************************************************************************
 * @brief Lit le premier élément <time> du fichier GPX et retourne l'heure au format "HH:MM:SS".
 *
 * Format ISO 8601 dans un GPX : "2017-08-18T09:12:00Z" ou "2017-08-18T09:12:00+02:00".
 * On extrait les 8 caractères après le 'T'.
 * @param filePath : chemin absolu du fichier .gpx.
 * @return "HH:MM:SS" ou chaîne vide si non trouvé / fichier illisible.
 * ***********************************************************************************************************/
QString GpxModel::readStartTime(const QString& filePath)
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return {};

    QXmlStreamReader xml(&file);
    while (!xml.atEnd() && !xml.hasError())
    {
        xml.readNext();
        if (xml.isStartElement() && xml.name() == QLatin1String("time"))
        {
            const QString isoTime = xml.readElementText();
            const int tIdx = isoTime.indexOf('T');
            if (tIdx >= 0 && isoTime.size() >= tIdx + 9)
                return isoTime.mid(tIdx + 1, 8);   // "HH:MM:SS"
            return {};
        }
    }
    return {};
}
