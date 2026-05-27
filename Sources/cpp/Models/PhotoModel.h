#ifndef PHOTOMODEL_H
#define PHOTOMODEL_H

#include <QAbstractListModel>
#include <QGeoCoordinate>

#include "Photo.h"

/** **********************************************************************************************************
 * @brief The PhotoModel class manages a list of photo data.
 * ***********************************************************************************************************/
class PhotoModel : public QAbstractListModel
{
    Q_OBJECT

    //! currentItemRow is the Photo row in the model corresponding to the current photo in the ListView.
    Q_PROPERTY(int currentItemRow READ getCurrentItemRow WRITE currentItemRow NOTIFY currentItemRowChanged)
    //! currentItemCoords is the GPS coordinates of the current Photo.
    Q_PROPERTY(QGeoCoordinate currentItemCoords READ getCurrentItemCoords WRITE currentItemCoords NOTIFY currentItemCoordsChanged)
    //! currentItemHasGPS indicate if the current Photo has GPS coordinates.
    Q_PROPERTY(bool currentItemHasGPS READ getCurrentItemHasGPS NOTIFY currentItemHasGPSChanged)
    //! Indique si un SavedPosition existe dans le modèle.
    Q_PROPERTY(bool savedPositionExists MEMBER m_savedPositionExists NOTIFY savedPositionExistsChanged)
    //! Indique si le modele est en train de lire les données Exif.
    Q_PROPERTY(bool loading MEMBER m_loading NOTIFY loadingChanged)
    //! Indique si le modele est en train d'écrire les données Exif.
    Q_PROPERTY(qreal writeProgress MEMBER m_writeProgress NOTIFY writeProgressChanged)
    //! Le nombre de photos dans la sélection.
    Q_PROPERTY(int selectionCount MEMBER m_selectionCount NOTIFY selectionCountChanged)
    //! Le nombre total de photos dans le modèle.
    Q_PROPERTY(int count READ getCount NOTIFY countChanged)


public:
    /** *****************************************************************************************************
     * @brief The Roles enum lists the roles associated to each attribute of a Photo
     * ******************************************************************************************************/
    enum Roles {
        FilenameRole  = Qt::UserRole,  // The first role that can be used for application-specific purposes.
        ImageUrlRole,
        LatitudeRole,
        LongitudeRole,
        HasGPSRole,
        IsCurrentRole,
        IsSelectedRole,
        IsMarkerRole,
        InsideCircleRole,
        ToBeSavedRole,
        DateTimeOriginalRole,
        CamModelRole,
        MakeRole,
        ImageWidthRole,
        ImageHeightRole,
        OrientationRole,
        ShutterSpeedRole,
        FNumberRole,
        CreatorRole,
        CityRole,
        CountryRole,
        LocationRole,
        DescriptionRole,
        CaptionWriterRole,
        SoftwareRole,
        MetadataRole,
        KeywordsRole
    };

    // -----------------------------------------------------
    // Surcharges obligatoires
    // -----------------------------------------------------
    explicit PhotoModel(QObject *parent = nullptr);
    int      rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QHash<int, QByteArray> roleNames() const override;

    // -----------------------------------------------------
    // Méthodes pouvant être appelées depuis QML
    // -----------------------------------------------------
    Q_INVOKABLE QString getRoleName(int role);
    Q_INVOKABLE QVariant getUrl(int row);
    Q_INVOKABLE QVariantMap get(int row);
    // Gestion de de la sélection
    Q_INVOKABLE void addToSelection(int row, bool exclusive=false);
    Q_INVOKABLE void removeFromSelection(int row);
    Q_INVOKABLE void resetSelection();
    Q_INVOKABLE void selectUnlocalized();
    Q_INVOKABLE void selectUndated();
    Q_INVOKABLE void selectAll();
    Q_INVOKABLE void findInCirclePhotos(int circle_radius = -1);
    Q_INVOKABLE void selectionCount();
    // Gestion  des keywords
    Q_INVOKABLE void removePhotoKeyword(const QString& keyword);
    Q_INVOKABLE void replaceKeywordForCurrent(const QString& keyword, int index);
    Q_INVOKABLE void replaceKeywordForSelection(const QString& oldKeyword, const QString& newKeyword);
    Q_INVOKABLE void addKeywordToAll(const QString& keyword);
    Q_INVOKABLE void addKeywordToSelection(const QString& keyword);
    Q_INVOKABLE void setSelectedItemsCoords(QGeoCoordinate coords);
    // Gestion des suggestions
    Q_INVOKABLE void suggestFromSelection();
    Q_INVOKABLE void suggestFromPhoto(const int row);
    Q_INVOKABLE int  scanFolder(const QString& folderUrl);
    Q_INVOKABLE void dumpData();
    Q_INVOKABLE void clear();

    // -----------------------------------------------------
    // Methodes publiques
    // -----------------------------------------------------
    void append(const QVariantMap& data);
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;  // Surcharge
    void setData(const QVariantMap &value_list);
    void selectFirstPhoto();
    void setWriteProgress(const int total = 0);
    int  getCount() const { return rowCount(); }

private:
    // -----------------------------------------------------
    // Méthodes privées
    // -----------------------------------------------------
    void addTestItem();
    void resetCircle();
    void setLoading(const bool state);
    void currentItemRow(const int row);
    void currentItemCoords(const QGeoCoordinate coords);
    int  getCurrentItemRow();
    bool getCurrentItemHasGPS();
    QGeoCoordinate getCurrentItemCoords();
    bool belong(double pLa, double pLo, double oLa, double oLo, double rLa, double rLo);

public slots:
    // -----------------------------------------------------
    // Slots
    // -----------------------------------------------------
    void append(const QString& filename, const QString& url);
    void appendSavedPosition();
    void fetchExifMetadata(int row = -1);
    void readTaskFinished();
    void saveMetadata();
    void setData(int row, const QString& value, const QString& property);
    void setInCircleItemCoords(const double latitude, const double longitude);
    void setPhotoProperty(const int photo, const QString& value, const QString& property);
    void applyCreatorToAll();
    void removeSavedPosition();
    void duplicateData(int row);
    void removeData(int row);


signals:
    // -----------------------------------------------------
    // Signaux émis
    // -----------------------------------------------------
    void sendSuggestion(QString text, QString target, QString category, int row);  //!< Ce signal envoie une Suggestion au SuggestionModel.
    void writeProgressChanged();                                                   //!< Ce signal est émis chaque fois qu'une nouvelle donnée Exif est écrite dans un JPG.
    void currentItemRowChanged(const int row);                                     //!< Signal émis quand la Photo courante change.
    void currentItemCoordsChanged();                                               //!< Signal émis quand les coordonnées GPS de la Photo courante changent.
    void currentItemHasGPSChanged();                                               //!< Signal émis quand le flag hasGPS de la photo courante change.
    void dataCleared();                                                            //!< Signal émis quand le modèle a été vidé.
    void dataSaved();                                                              //!< Signal émis quand les données ont été enregistrées sur le disque.
    void firstCoordsReady();                                                       //!< Signal émis quand les coordonnées GPS de la première photo sont disponibles.
    void savedPositionExistsChanged();                                             //!< Signal émis quand une SavedPosition est créée ou supprimée.
    void loadingChanged();                                                         //!< Signal émis quand le status loading change.
    void selectionCountChanged();                                                  //!< Signal émis quand le nombre de photos sélectionnées change.
    void countChanged();                                                           //!< Signal émis quand le nombre total de photos change.

    // -----------------------------------------------------
    // Membres
    // -----------------------------------------------------
public:
    QModelIndex m_markerIndex = QModelIndex();  //!< Index du marker SavedPosition. Initialisé à une valeur invalide.   
protected:
    int m_markerRow = -1;                       //!< Position du marker SavedPosition
private:
    QVector<Photo> m_photos;               //!< La liste des Photo du modèle
    int m_lastCurrentRow = 0;              //!< L'indice de la précédente photo sélectionnée. (initialisé à 0 car au départ, on a un item: le Welcome Rolleyflex)
    int m_dumpedRow = 0;                   //!< Compteur pour le dump de debug
    int m_lastCircleRadius = 0;            //!< Valeur précédente du rayon de recherche
    double m_lastCircleLat  = -1000.0;     //!< Latitude du dernier centre de cercle calculé (-1000 = jamais calculé)
    double m_lastCircleLong = -1000.0;     //!< Longitude du dernier centre de cercle calculé
    bool m_circleResetted = true;          //!< True si le rayon du cercle est à 0, et que le flag insideCircle a été resetté sur toutes les photos.
    bool m_savedPositionExists = false;    //!< True si le marker SavedPosition existe
    bool m_loading = false;                //!< True si le modèle est en train de scanner le répertoire.
    int m_pendingReadTasks = 0;            //!< Nombre de ExifReadTask encore en cours d'exécution.
    qreal m_writeProgress = 0;             //!< Progression de l'écriture des données Exif dans les JPG. Varie de 0 à 1.
    int m_totalWrite = 1;                  //!< Nombre de fichiers JPEG à modifier avec de nouvelles metadata.
    int m_countWrite = 0;                  //!< Nombre de fichiers JPEG modifiés avec de nouvelles metadata.
    int m_selectionCount = 0;              //!< Nombre de photos dans la sélection.
};

#endif // PHOTOMODEL_H
