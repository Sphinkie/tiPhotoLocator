#include "GpxModel.h"

#include <QDir>
#include <QFile>
#include <QXmlStreamReader>


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
