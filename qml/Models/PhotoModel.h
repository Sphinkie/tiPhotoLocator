#ifndef PHOTOMODEL_H
#define PHOTOMODEL_H

#include <QAbstractListModel>

// -----------------------------------------------------------------------
/**
 * @brief A data structure containing all the attributes for a photo picture: filename, GPS coordinates, etc.
 */
struct Data
{
    enum ItemType {photo, marker, welcome};

    // Default constructor
    Data() {}
    // Constructeur avec valeurs
    Data( const QString &file_name,
          const QString &image_url,
//        const Data::ItemType image_type = photo,
          const bool is_marker = false,
          const bool is_welcome = false,
          bool is_selected = false
          )
    {
        filename = file_name;
        imageUrl = image_url;
        isMarker = is_marker;
        isWelcome = is_welcome;
        isSelected = is_selected;
    }

    // Elements de la structure
    QString filename;          // Example: "IMG_20230823_1234500.jpg"
    QString imageUrl;          // Example: "qrc:///Images/ibiza.png"
    double gpsLatitude = 0;    // Example: 38.980    // GPS coordinates
    double gpsLongitude = 0;   // Example: 1.4333    // (Ibiza)
    // Elements déterminés automatiquement
    bool hasGPS = false;       // has GPS coordinates (latitude/longitude)
    bool isSelected;           // Indique que cet item est sélectionné dans la ListView
    bool isMarker = false;     // Exemple: une position sauvegardée sur la carte
    bool isWelcome = false;    // Exemple: L'image de la page d'acceuil
    bool insideCircle = false; // inside the radius of nearby photos
    bool toBeSaved = false;    // true if one of the following fields has been modified
    // EXIF tags
    QString dateTimeOriginal;   // Time when the camera shutter was pressed (no changes allowed in this app)
    QString camModel;           // camera model (no changes allowed in this app)
    QString make;               // camera maker (no changes allowed in this app)
    int imageWidth = 0;         // image width (no changes allowed in this app)
    int imageHeight = 0;        // image height (no changes allowed in this app)
    // IPTC tags
    QString artist;             // can be: Artist or Creator
    //QString gpsLatitudeRef;
    //QString gpsLongitudeRef;
    QString city;
    QString country;
    QString description;        // can be: Description, ImageDescription or Caption;
    QString descriptionWriter;
    QString headline;           // short description
    QString keywords;           // this is a list of keywords

    // Surcharges d'operateurs
    bool operator == (const QString &file_name);
    bool operator == (const Data &data);

};


// -----------------------------------------------------------------------
/**
 * @brief The PhotoModel class manages a list of photo Data.
 */
class PhotoModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int selectedRow READ getSelectedRow WRITE selectedRow NOTIFY selectedRowChanged)

public:
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
        ArtistRole,
        GPSLatitudeRefRole,    // TODO A voir s'il faut le conserver
        GPSLongitudeRefRole,   // ou s'il n'y en a pas besoin
        CityRole,
        CountryRole,
        DescriptionRole,
        DescriptionWriterRole,
        HeadlineRole,
        KeywordsRole
    };
    QHash<int, QByteArray> roleNames() const override;

    // -----------------------------------------------------
    // Surcharges obligatoires
    // -----------------------------------------------------
    explicit PhotoModel(QObject *parent = nullptr);
    int      rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

    // -----------------------------------------------------
    // Méthodes pouvant être appelées depuis QML
    // -----------------------------------------------------
    Q_INVOKABLE QVariant getUrl(int index);
    Q_INVOKABLE QVariantMap get(int row);
    Q_INVOKABLE void dumpData();
    Q_INVOKABLE void clear();

    // -----------------------------------------------------
    // Methodes publiques
    // -----------------------------------------------------
    void append(const QVariantMap data_dict);
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;  // On surcharge car setData() est deja dans la surclasse
    void setData(const QVariantMap &value_list);

private:
    // -----------------------------------------------------
    // Méthodes privées
    // -----------------------------------------------------
    void addTestItem();
    void selectedRow(int row);
    int getSelectedRow();


public slots:
    // -----------------------------------------------------
    // Slots
    // -----------------------------------------------------
    void append(const QString filename, const QString url);
    void fetchExifMetadata(int row = -1);
    void saveMetadata();
    void setInCircleItemCoords(double lati, double longi);
    void appendSavedPosition(double lati, double longi);
    void removeSavedPosition();
    void setData(int row, QString value, QString property);
    void duplicateData(int row);
    void removeData(int row);


signals:
    // -----------------------------------------------------
    // Signaux émis
    // -----------------------------------------------------
    void selectedRowChanged(const int row);


    // -----------------------------------------------------
    // Membres
    // -----------------------------------------------------
public:
    QModelIndex m_markerIndex = QModelIndex();  /// Index du marker SavedPosition. Initialisé à une valeur invalide.
protected:
    int m_markerRow = -1;                       /// Position du marker SavedPosition
private:
    QVector<Data> m_data;                       /// La liste des photos
    int m_lastSelectedRow = 0;                  /// L'indice de la précédente photo sélectionnée. (initilaisé à 0 car au départ, on a un item: le Welcome Rolleyflex)
    int m_dumpedRow = 0;                        /// Compteur pour le dump de debug
};

#endif // PHOTOMODEL_H
