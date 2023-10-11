#ifndef PHOTOMODEL_H
#define PHOTOMODEL_H

#include <QAbstractListModel>
#include <QColor>

/**
 * @brief The Data structure contain all the attribute for a photo picture: filename, GPS ccordinates, etc.
 */
struct Data
{
    // Default constructor
    Data() {}
    // Constructeur avec valeurs
    Data( const QString &file_name,
          const QString &image_url,
          double gps_latitude = 0,
          double gps_longitude = 0,
          bool is_selected = false
          )
    {
        filename = file_name;
        imageUrl = image_url;
        gpsLatitude = gps_latitude;
        gpsLongitude = gps_longitude;
        hasGPS    = (gps_latitude!=0) || (gps_longitude!=0);
        isSelected = is_selected;
    }

    // Elements de la structure
    QString filename;       // Example: "IMG_20230823_1234500.jpg"
    QString imageUrl;       // Example: "qrc:///Images/ibiza.png"
    double gpsLatitude;     // Example: 38.980    // GPS coordinates
    double gpsLongitude;    // Example: 1.4333    // (Ibiza)
    // Elements déterminés automatiquement
    bool hasGPS = false;       // has GPS coordinates (latitude/longitude)
    bool isSelected;           // Indique que cet item est sélectionné dans la ListView
    bool insideCircle = false; // inside the radius of nearby photos
    bool toBeSaved = false;    // true if one of the following fields has been modified
    // EXIF tags
    QString dateTimeOriginal;   // Time when the camera shutter was pressed (no changes allowed in this app)
    QString camModel;           // camera model (no changes allowed in this app)
    QString make;               // camera maker (no changes allowed in this app)
    int imageWidth;             // image width (no changes allowed in this app)
    int imageHeight;            // image height (no changes allowed in this app)
    // IPTC tags
    QString artist;             // can be: Artist or Creator
    QString gpsLatitudeRef;
    QString gpsLongitudeRef;
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
// Class
// -----------------------------------------------------------------------
class PhotoModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        FilenameRole = Qt::UserRole,  // The first role that can be used for application-specific purposes.
        ImageUrlRole,
        LatitudeRole,
        LongitudeRole,
        HasGPSRole,
        IsSelectedRole,
        InsideCircleRole,
        ToBeSavedRole,
        DateTimeOriginalRole,
        CamModelRole,
        MakeRole,
        ImageWidthRole,
        ImageHeightRole,
        ArtistRole,
        GPSLatitudeRefRole,
        GPSLongitudeRefRole,
        CityRole,
        CountryRole,
        DescriptionRole,
        DescriptionWriterRole,
        HeadlineRole,
        KeywordsRole
    };

    Q_PROPERTY(int selectedRow READ getSelectedRow WRITE selectedRow NOTIFY selectedRowChanged)

    QHash<int, QByteArray> roleNames() const override;

    // Surcharges obligatoires
    explicit PhotoModel(QObject *parent = nullptr);
    int      rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

    // Méthodes pouvant être appelées depuis QML
    Q_INVOKABLE QVariant getUrl(int index);
    Q_INVOKABLE QVariantMap get(int row);
    Q_INVOKABLE void dumpData();
    Q_INVOKABLE void clear();
    // Methodes publiques
    void append(QVariantMap data_dict);
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;  // setData est deja dans la surclasse
    void setData(QVariantMap &value_list);
    void selectedRow(int row);
    int getSelectedRow();

public slots:
    void append(QString filename, QString url);
    void fetchExifMetadata();
    void duplicateData(int row);
    void removeData(int row);

private:
    void addTestItem();

private slots:
    void growPopulation();

signals:
    void selectedRowChanged();
    void scanFile(QString imagePath);

private: //members
    QVector<Data> m_data;
    int m_lastSelectedRow = 0;  // Au départ, on a un item: Kodak
    int m_dumpedRow = 0;        // Compteur pour le dump de debug
};

#endif // PHOTOMODEL_H
