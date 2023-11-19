#include <QtLocation>
#include <QtLocation/QGeoServiceProvider>
#include <QtPositioning/QGeoCoordinate>
#include <QSslSocket>                              // pour le plugin OSM
#include <QDebug>

#include "GeocodeWrapper.h"

/*!
 * \class GeocodeWrapper
 * \inmodule TiPhotoLocator 
 * \brief The GeocodeWrapper class allows requests to OpenStreetMap for reverse geocoding.
* 
* \note: Ajouter les lignes suivantes dans le fichier \c .pro.
* \code
    QT += positioning
    QT += location
* \endcode
*/

#define QT_NO_DEBUG_OUTPUT

/* ********************************************************************************************************** */
/*!
 * \brief Le contructeur initialise le \e  Provider OSM.
 **/
GeocodeWrapper::GeocodeWrapper(SuggestionModel* suggestion_model)
{
    m_suggestionModel = suggestion_model;
    QString providerName = "osm";  // "osm" ou "esri"
    QVariantMap parameters;

    parameters.insert("osm.geocoding.host", "https://nominatim.openstreetmap.org");

    QGeoServiceProvider* geoProvider = new QGeoServiceProvider(providerName, parameters);
    m_geoManager = geoProvider->geocodingManager();
    connect(m_geoManager, SIGNAL(finished(QGeoCodeReply*)), this, SLOT(geoCodeFinished(QGeoCodeReply*)));

    qDebug()
        << QSslSocket::supportsSsl()                   // doit retourner true
        << QSslSocket::sslLibraryBuildVersionString()  // la version utilisee pour compiler Qt   ("OpenSSL 1.1.1d  10 Sep 2019")
        << QSslSocket::sslLibraryVersionString();      // la version disponible
    // Installer les binaries openSSL avec le Qt Maintenance Tool

}

/* ********************************************************************************************************** */
/*!
 * \brief Envoie une requete pour obtenir des informations sur un jeu de coordonnées GPS: \a latitude et \a longitude. (exemple: 38.980 et  1.433) \l {https://nominatim.openstreetmap.org/ui/details.html?osmtype=W&osmid=313893003&class=highway}{result}
 */
void GeocodeWrapper::requestReverseGeocode(double latitude, double longitude)
{
    QGeoCoordinate coordinate = QGeoCoordinate(latitude, longitude);
    QGeoCodeReply* geoReply = m_geoManager->reverseGeocode(coordinate);

    // On regarde s'il y a une erreur immédiate
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
        QGeoLocation geolocation = reply->locations().value(0);
        const QGeoAddress adresse = geolocation.address();
        qDebug() << adresse.text();
        // On mémorise les suggestions
        m_suggestionModel->append(adresse.street(), "city", "Geo");
        m_suggestionModel->append(adresse.district(), "city", "Geo");
        m_suggestionModel->append(adresse.city(), "city", "Geo");
        m_suggestionModel->append(adresse.county(), "city", "Geo");
        m_suggestionModel->append(adresse.state(), "country", "Geo");
        m_suggestionModel->append(adresse.country(), "country", "Geo");
    }
}


/* ********************************************************************************************************** */
//    delete geoProvider;
