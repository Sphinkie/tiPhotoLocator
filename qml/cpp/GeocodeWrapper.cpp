#include <QtLocation>
#include <QtLocation/QGeoServiceProvider>
#include <QtPositioning/QGeoCoordinate>
#include <QSslSocket>                              // pour le plugin OSM
#include <QDebug>

#include "GeocodeWrapper.h"

// Attention: Ajouter les lignes suivantes dans le fichier .pro
// QT += positioning
// QT += location

// #define QT_NO_DEBUG_OUTPUT

/* ********************************************************************************************************** */
/**
 * @brief Contructeur.
 **/
GeocodeWrapper::GeocodeWrapper()
{
    QString providerName = "osm";  // "osm" ou "esri"
    QVariantMap parameters;

    // Plugin OSM :
    // Paramètres du plugin osm : https://doc.qt.io/qt-5/location-plugin-osm.html
    parameters.insert("osm.geocoding.host", "https://nominatim.openstreetmap.org");
    // parameters.insert("osm.places.host", "https://nominatim.openstreetmap.org/reverse");
    // Conseils (inefficaces) pour éviter l'erreur: TLS initialization failed.
    // parameters.insert("osm.mapping.providersrepository.disabled", "true");
    // parameters.insert("osm.mapping.providersrepository.address", "http://maps-redirect.qt.io/osm/5.6/");
    // L'autre conseil étant d'installer OpenSSL pour Windows
    // Url string set when making network requests to the geocoding server. This parameter should be set to a valid server url with the correct osm API. If not specified the default url will be used.
    // Note: The API documentation is available at Project OSM Nominatim. https://wiki.openstreetmap.org/wiki/Nominatim
    // https://nominatim.openstreetmap.org/reverse?format=xml&lat=38.980&lon=1.433&zoom=15&addressdetails=1

    // les errerus rencontres
    //osm : qt.network.ssl: QSslSocket::connectToHostEncrypted: TLS initialization failed
    //esri: "Error transferring http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/reverseGeocode?f=json&langCode=fr&location=1.433,38.98 - server replied: Bad Request"


    // Plugin ESRI
    // petit laius sur ESRI et QT
    // https://www.esri.com/arcgis-blog/products/developers/uncategorized/esri-contributes-to-the-latest-version-of-the-qt-project/?rmedium=redirect&rsource=blogs.esri.com/esri/arcgis/2017/02/06/esri-becomes-a-contributor-to-the-qt-project
    // description de l'API reverseGeocode
    // https://developers.arcgis.com/rest/geocode/api-reference/geocoding-reverse-geocode.htm
    // Exemple
    // Attention: ESRI n'accespte plus les requetes en HTTP, il faut du HTTPS
    // https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/reverseGeocode?<PARAMETERS>
    // https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/reverseGeocode?f=json&langCode=fr&location=1.433,38.98
    // Le forum ESRI
    // https://community.esri.com/t5/qt-maps-sdk-questions/bd-p/arcgis-runtime-sdk-for-qt-questions
    // les paramètres
    // https://doc.qt.io/qt-5/location-plugin-esri.html
    // parameters.insert("esri.token", "notrequieredforgeocoding");

    QGeoServiceProvider* geoProvider = new QGeoServiceProvider(providerName, parameters);
    m_GeoManager = geoProvider->geocodingManager();

    qDebug()
        << QSslSocket::supportsSsl()                   // doit retourner true
        << QSslSocket::sslLibraryBuildVersionString()  // la version utilisee pour compiler Qt   ("OpenSSL 1.1.1d  10 Sep 2019")
        << QSslSocket::sslLibraryVersionString();      // la version disponible
    // Installer les binaries openSSL avec le Qt Maintenance Tool

}

/* ********************************************************************************************************** */
/**
 * @brief Envoie une requete pour obtenir des informations sur un jeu de coordonnées GPS.
 * @param lati : latitude
 * @param longi : Longitude
 * @example: 38.980   1.433
 * @see https://nominatim.openstreetmap.org/ui/details.html?osmtype=W&osmid=313893003&class=highway
 **/
void GeocodeWrapper::requestReverseGeocode(double lati, double longi)
{
    QGeoCoordinate coordinate = QGeoCoordinate(lati, longi);
    connect(m_GeoManager, SIGNAL(finished(QGeoCodeReply*)), this, SLOT(geoCodeFinished(QGeoCodeReply*)));
    QGeoCodeReply* geoReply = m_GeoManager->reverseGeocode(coordinate);

    qDebug() << geoReply;

    // On regarde s'il y a une erreur
    if (geoReply->isFinished())
        qWarning() << "requestReverseGeocode" << geoReply->error();
}



/* ********************************************************************************************************** */
/**
 * @brief Signal appelé lors de la réception de la réponse à la request
 * @param reply : le contenu de la réponse
 * @example "Santa Eulària des Riu, Ibiza, Îles Baléares, 07814, Espagne"
 */
void GeocodeWrapper::geoCodeFinished(QGeoCodeReply* reply)
{
    qDebug() << "finished with code" << reply->error();
    if (reply->error() != QGeoCodeReply::NoError)
        qWarning() << reply->errorString();
    else if (reply->locations().count() >0)
    {
        QGeoLocation g = reply->locations().value(0);
        const QGeoAddress a = g.address();
        qDebug() << a.text();
    }
}


/* ********************************************************************************************************** */
//    delete geoProvider;
