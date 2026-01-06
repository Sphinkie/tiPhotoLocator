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

    //! selectedRow is the Photo row in the model corresponding to the selected photo in the ListView.
    Q_PROPERTY(int selectedRow READ getSelectedRow WRITE selectedRow NOTIFY selectedRowChanged)
    //! selectedCoords is the GPS coordinates of the selected Photo.
    Q_PROPERTY(QGeoCoordinate selectedCoords READ getSelectedCoords WRITE selectedCoords NOTIFY selectedCoordsChanged)
    //! indique si un SavedPosition existe dan le modèle.
    Q_PROPERTY(bool savedPositionExists MEMBER m_savedPositionExists NOTIFY savedPositionExistsChanged)

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
        IsSelectedRole,
        IsMarkerRole,
        IsWelcomeRole,
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
        KeywordsRole
    };

    // -----------------------------------------------------
    // Surcharges obligatoires
    // -----------------------------------------------------
    explicit PhotoModel(QObject *parent = nullptr);
    int      rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QHash<int, QByteArray> roleNames() const override;

    // -----------------------------------------------------
    // Méthodes pouvant être appelées depuis QML
    // -----------------------------------------------------
    Q_INVOKABLE QString getRoleName(int role);
    Q_INVOKABLE QVariant getUrl(int row);
    Q_INVOKABLE QVariantMap get(int row);
    Q_INVOKABLE void dumpData();
    Q_INVOKABLE void clear();
    Q_INVOKABLE void removePhotoKeyword(QString keyword);
    Q_INVOKABLE void updatePhotoKeyword(QString keyword, int index);
    Q_INVOKABLE void findInCirclePhotos(int circle_radius = -1);

    // -----------------------------------------------------
    // Methodes publiques
    // -----------------------------------------------------
    void append(const QVariantMap data);
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;  // Surcharge
    void setData(const QVariantMap &value_list);
    void selectFirstPhoto();

private:
    // -----------------------------------------------------
    // Méthodes privées
    // -----------------------------------------------------
    void addTestItem();
    void resetCircle();
    void selectedRow(const int row);
    void selectedCoords(const QGeoCoordinate coords);
    int  getSelectedRow();
    QGeoCoordinate getSelectedCoords();
    bool belong(double pLa, double pLo, double oLa, double oLo, float rLa, float rLo);

public slots:
    // -----------------------------------------------------
    // Slots
    // -----------------------------------------------------
    void append(const QString filename, const QString url);
    //void appendSavedPosition(QGeoCoordinate coords );
    void appendSavedPosition();
    void fetchExifMetadata(int row = -1);
    void saveMetadata();
    void setData(int row, QString value, QString property);
    void setInCircleItemCoords(const double latitude, const double longitude);
    void setPhotoProperty(const int photo, const QString value, const QString property);
    void applyCreatorToAll();
    void removeSavedPosition();
    void duplicateData(int row);
    void removeData(int row);


signals:
    // -----------------------------------------------------
    // Signaux émis
    // -----------------------------------------------------
    void selectedRowChanged(const int row);                                        //!< Signal émis quand la Photo sélectionnée change.
    void selectedCoordsChanged();                                                  //!< Signal émis quand les coordonnées GPS de la Photo sélectionnée changent.
    void sendSuggestion(QString text, QString target, QString category, int row);  //!< Ce signal envoie une Suggestion au SuggestionModel.
    void dataCleared();                                                            //!< Signal émis quand le modèle a été vidé.
    void dataSaved();                                                              //!< Signal émis quand les données ont été enregistrées sur le disque.
    void firstCoordsReady();                                                       //!< Signal émis quand les coordonnées GPS de la première photo sont disponibles.
    void savedPositionExistsChanged();                                             //!< Signal émis quand une SavedPosition est créée ou supprimée.

    // -----------------------------------------------------
    // Membres
    // -----------------------------------------------------
public:
    QModelIndex m_markerIndex = QModelIndex();  //!< Index du marker SavedPosition. Initialisé à une valeur invalide.
protected:
    int m_markerRow = -1;                       //!< Position du marker SavedPosition
private:
    QVector<Photo> m_photos;                    //!< La liste des Photo du modèle
    int m_lastSelectedRow = 0;                  //!< L'indice de la précédente photo sélectionnée. (initialisé à 0 car au départ, on a un item: le Welcome Rolleyflex)
    int m_dumpedRow = 0;                        //!< Compteur pour le dump de debug
    int m_lastCircleRadius = 0;                 //!< Valeur précdente du rayon de recherche
    bool m_circleResetted = true;               //!< True si le rayon du cercle est à 0, et que le flag insideCircle a été resetté sur toutes les photos.
    bool m_savedPositionExists = false;         //!< True si le marker SavedPosition existe
};

#endif // PHOTOMODEL_H
