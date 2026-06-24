#ifndef GPXMODEL_H
#define GPXMODEL_H

#include <QAbstractListModel>
#include <QDateTime>
#include <QGeoCoordinate>
#include <QUrl>

/** ******************************************************************
 * @brief Un point du tracé GPX avec sa position et son horodatage.
 * *******************************************************************/
struct GpxTrackPoint {
    QGeoCoordinate coord;
    QDateTime      time;
};

/** ******************************************************************
 * @brief Structure interne décrivant un fichier GPX.
 * *******************************************************************/
struct GpxFileInfo {
    QString name;       //!< Nom de fichier (sans chemin).
    QString filePath;   //!< Chemin absolu complet.
    QString startTime;  //!< Heure de début au format "HH:MM:SS" (vide si non trouvé).
};

/** **********************************************************************************************************
 * @brief The GpxModel class expose la liste des fichiers GPX du sous-dossier de photos.
 *
 * Les fichiers sont recherchés dans les sous-dossiers "GPX" et "GPSLOG" du dossier de photos courant.
 * L'heure de début de chaque track est extraite du premier élément <time> du fichier XML GPX.
 * ***********************************************************************************************************/
class GpxModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QVariantList currentTrackPoints READ currentTrackPoints NOTIFY currentTrackPointsChanged)
    Q_PROPERTY(int matchCount       READ matchCount       NOTIFY matchCountChanged)
    Q_PROPERTY(int trackPointCount  READ trackPointCount  NOTIFY trackPointCountChanged)

public:
    QVariantList currentTrackPoints() const { return m_currentTrackPoints; }
    int          matchCount()         const { return m_matchCount; }
    int          trackPointCount()    const { return m_trackPointCount; }
    /** ******************************************************************************************************
     * @brief Rôles exposés au QML.
     * *******************************************************************************************************/
    enum Roles {
        NameRole      = Qt::UserRole,  //!< Nom du fichier.
        FilePathRole,                  //!< Chemin absolu.
        StartTimeRole                  //!< Heure de début "HH:MM:SS".
    };

    explicit GpxModel(QObject *parent = nullptr);

    // Surcharges obligatoires
    int      rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void refresh(const QUrl& folderUrl);
    void selectTrack(int row);
    void matchPhotos(QObject* photoModelObj, int offsetHours);

signals:
    void currentTrackPointsChanged();      //!< Emis quand une nouvelle track est chargée
    void matchCountChanged();              //!< Emis quand le nombre de photos matchées change.
    void trackPointCountChanged();         //!< Emis quand le nombre de points du track change.
    void firstOnTrackFound(int sourceRow); //!< Émis après matchPhotos() si au moins une photo est sur la track.

private:
    QString                readStartTime(const QString& filePath);
    QString                readNmeaStartTime(const QString& filePath);
    QString                readGpxStartTime(const QString& filePath);
    QVector<GpxTrackPoint> parseTrack(const QString& filePath);
    QVector<GpxTrackPoint> parseNmeaTrack(const QString& filePath);
    QVector<GpxTrackPoint> parseGpxTrack(const QString& filePath);

    QVector<GpxFileInfo>   m_files;              //!< Liste des fichiers GPX détectés.
    QVector<GpxTrackPoint> m_currentTrack;       //!< Points du track sélectionné (avec timestamps).
    QVariantList           m_currentTrackPoints; //!< Coordonnées seules pour MapPolyline QML.
    int                    m_matchCount = 0;     //!< Nombre de photos matchées sur le track courant.
    int                    m_trackPointCount = 0;//!< Nombre de points GPS dans le track courant.
};

#endif // GPXMODEL_H
