#ifndef GEOCODEWRAPPER_H
#define GEOCODEWRAPPER_H

#include <QObject>
#include <QtLocation/QGeoCodingManager>


class GeocodeWrapper : public QObject
{
    Q_OBJECT

//    Q_PROPERTY(bool generateBackup MEMBER m_generateBackup)

public:
    explicit GeocodeWrapper();

public slots:
    void requestReverseGeocode(double lati, double longi);

private slots:
    void geoCodeFinished(QGeoCodeReply* reply);

private:
    QGeoCodingManager* m_GeoManager;

};

#endif // GEOCODEWRAPPER_H



