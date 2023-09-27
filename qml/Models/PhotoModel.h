/*************************************************************************
 *
 *************************************************************************/

#ifndef PHOTOMODEL_H
#define PHOTOMODEL_H

#include <QAbstractListModel>
#include <QColor>

// -----------------------------------------------------------------------
// Data structure
// -----------------------------------------------------------------------
struct Data
{
    // Default constructor
    Data() {}
    // Constructor avec valeurs
    Data( const QString &file_name,
          const QString &image_url,
          double gps_latitude,
          double gps_longitude,
          bool is_selected = false
          )
    {
        filename = file_name;
        imageUrl = image_url;
        latitude = gps_latitude;
        longitude = gps_longitude;
        hasGPS    = (gps_latitude!=0) && (gps_longitude!=0);
        isSelected = is_selected;
    }

    // Elements de la structure
    QString filename;       // Example: "IMG_20230823_1234500.jpg"
    QString imageUrl;       // Example: "qrc:///Images/ibiza.png"
    double latitude;        // Example: 38.980    // GPS coordinates
    double longitude;       // Example: 1.4333    // (Ibiza)
    // Elements déterminés automatiquement
    bool hasGPS = false;    // has GPS coordinates (latitude/longitude)
    bool isSelected;
    // isDirty: false      // true if one of the following fields has been modified
    // insideCircle: false // inside the radius of nearby photos
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
        IsSelectedRole
    };

    Q_PROPERTY(int selectedRow READ getSelectedRow WRITE selectedRow ) // NOTIFY selectedRowChanged)

    QHash<int, QByteArray> roleNames() const override;

    explicit PhotoModel(QObject *parent = nullptr);
    // Surcharges obligatoires
    int      rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    // Methodes
    Q_INVOKABLE QVariant getUrl(int index);
    Q_INVOKABLE QVariantMap get(int row);
    Q_INVOKABLE void append(QString filename, QString url);   // , double latitude=0, double longitude=0 );
    Q_INVOKABLE void append(QVariantMap data_dict);
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;  // setData est deja dans la surclasse
    // Getter and Setter
    void selectedRow(int row);
    int getSelectedRow();

public slots:
    void duplicateData(int row);
    void removeData(int row);

private slots:
    void growPopulation();

// signals:
//    void selectedRowChanged();

private: //members
    QVector<Data> m_data;
    int m_lastSelectedRow = 0;  // Au départ, on a un item: Kodak
};

#endif // PHOTOMODEL_H
