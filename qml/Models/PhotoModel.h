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
struct Data {
    // Default constructor
    Data() {}
    // Constructor avec valeurs
    Data( const QString &filename,
          const QString &imageUrl,
          double latitude,
          double longitude,
          bool isSelected  = false
          )
        : filename(filename), imageUrl(imageUrl), latitude(latitude), longitude(longitude), isSelected(isSelected) {}
    // Elements de la structure
    QString filename;
    QString imageUrl;
    double latitude;
    double longitude;
    bool isSelected;
};

// -----------------------------------------------------------------------
// Class
// -----------------------------------------------------------------------
class PhotoModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        FilenameRole,  //  = Qt::UserRole, (pour les enums ?)
        ImageUrlRole,
        LatitudeRole,
        LongitudeRole,
        IsSelectedRole
    };

    Q_PROPERTY(bool selectedIndex READ getSelectedIndex WRITE selectedIndex NOTIFY selectedIndexChanged)

    QHash<int, QByteArray> roleNames() const override;
    explicit PhotoModel(QObject *parent = nullptr);
    int rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    Q_INVOKABLE QVariant getUrl(int index);
    Q_INVOKABLE QVariantMap get(int row);
    Q_INVOKABLE void append(QString filename, QString url, double latitude=0, double longitude=0 );
    void selectedIndex(int index);
    int getSelectedIndex();
    bool setData2(const QModelIndex &index, const QVariant &value, int role);  // setData est deja dans la surclasse

public slots:
    void duplicateData(int row);
    void removeData(int row);

private slots:
    void growPopulation();

signals:
    void selectedIndexChanged();

private: //members
    QVector<Data> m_data;
    int m_lastSelectedIndex = 0;
};

#endif // PHOTOMODEL_H

/* -----
 * My Roles:
        filename:           // "IMG_20230823_1234500.jpg"
        imageUrl:           // "qrc:///Images/ibiza.png"
        isDirty: false      // true if one of the following fields has been modified
        latitude: 38.980    // GPS coordinates
        longitude: 1.433    // (Ibiza)
        hasGPS: false       // has GPS coordinates
        nearSelected: false // inside the radius of nearby photos
 *
 * */
