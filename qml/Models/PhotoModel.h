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
    Data() {}
    Data( const QString& filename,
          const QString& imageUrl,
          double latitude,
          double longitude
          )
        : filename(filename), imageUrl(imageUrl), latitude(latitude), longitude(longitude) {}
    QString filename;
    QString imageUrl;
    double latitude;
    double longitude;
};

// -----------------------------------------------------------------------
// Class
// -----------------------------------------------------------------------
class PhotoModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        FilenameRole,  //  = Qt::UserRole,
        ImageUrlRole,
        LatitudeRole,
        LongitudeRole
    };

    QHash<int, QByteArray> roleNames() const override;
    explicit PhotoModel(QObject *parent = nullptr);
    int rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    Q_INVOKABLE QVariant getUrl(int index);
    Q_INVOKABLE void append(QString filename, QString url, double latitude=0, double longitude=0 );

public slots:
    void duplicateData(int row);
    void removeData(int row);

private slots:
    void growPopulation();

private: //members
    QVector< Data > m_data;
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
