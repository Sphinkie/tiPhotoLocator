#ifndef GPXMODEL_H
#define GPXMODEL_H

#include <QAbstractListModel>
#include <QGeoCoordinate>
#include <QUrl>

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

public:
    QVariantList currentTrackPoints() const { return m_currentTrackPoints; }
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

signals:
    void currentTrackPointsChanged();

private:
    QString      readStartTime(const QString& filePath);
    QVariantList parseTrackPoints(const QString& filePath);

    QVector<GpxFileInfo> m_files;             //!< Liste des fichiers GPX détectés.
    QVariantList         m_currentTrackPoints; //!< Points du track sélectionné (QGeoCoordinate).
};

#endif // GPXMODEL_H
