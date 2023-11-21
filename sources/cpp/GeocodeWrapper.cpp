#include <QtLocation>
#include <QtLocation/QGeoServiceProvider>
#include <QtPositioning/QGeoCoordinate>
#include <QSslSocket>                              // pour le plugin OSM
#include <QDebug>

#include "GeocodeWrapper.h"

/*!
 * \class GeocodeWrapper
 * \inmodule TiPhotoLocator
    The GeocodeWrapper class allows requests to OpenStreetMap for reverse geocoding.
    Ajouter les lignes suivantes dans le fichier \c .pro.
    \code
        QT += positioning
        QT += location
    \endcode
*/

#define QT_NO_DEBUG_OUTPUT

/* ********************************************************************************************************** */
/*
 * \brief Le contructeur initialise le \e Provider OSM.
 * Le paramètre \a suggestion_model permet de savoir quel objet SuggestionModel appeler une fois les résultat reçus.
 */
GeocodeWrapper::GeocodeWrapper(SuggestionModel* suggestion_model)
{
    m_suggestionModel = suggestion_model;
    QString providerName = "osm";  // "osm" ou "esri"
    QVariantMap parameters;

    parameters.insert("osm.geocoding.host", "https://nominatim.openstreetmap.org");

    QGeoServiceProvider* geoProvider = new QGeoServiceProvider(providerName, parameters);
    m_geoManager = geoProvider->geocodingManager();
    // cet objet n'est créé qu'une fois, et sera détruit à la sortie de l'application.
    connect(m_geoManager, SIGNAL(finished(QGeoCodeReply*)), this, SLOT(geoCodeFinished(QGeoCodeReply*)));

    qDebug()
        << QSslSocket::supportsSsl()                   // doit retourner true
        << QSslSocket::sslLibraryBuildVersionString()  // la version utilisee pour compiler Qt   ("OpenSSL 1.1.1d  10 Sep 2019")
        << QSslSocket::sslLibraryVersionString();      // la version disponible
    // Installer les binaries openSSL avec le Qt Maintenance Tool

}

/* ********************************************************************************************************** */
/*
 * \brief Envoie une requete pour obtenir des informations sur un jeu de coordonnées GPS: \a latitude et \a longitude.
 * Exemple: 38.980 et 1.433 => \l {https://nominatim.openstreetmap.org/ui/details.html?osmtype=W&osmid=313893003&class=highway}{result}
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
/*
 * \brief Envoie une requete pour obtenir les coordonnées GPS d'un lieu donné par le paramètre \a location.
 * Exemple: "Marsa-el-Brega" => \l {https://nominatim.openstreetmap.org/ui/details.html?osmtype=W&osmid=313893003&class=highway}{result}
 */
void GeocodeWrapper::requestCoordinates(QString location)
{
    QGeoAddress adresse = QGeoAddress();
    adresse.setCity(location);
    QGeoCodeReply* geoReply = m_geoManager->geocode(adresse);

    // On regarde s'il y a une erreur immédiate
    if (geoReply->isFinished())
        qWarning() << "requestCoordinates" << geoReply->error();
}


/* ********************************************************************************************************** */
/*
 * \brief Signal appelé lors de la réception de la réponse à la request. Le paramètre \a reply contient le contenu de la réponse.
 * \note: Exemple: "Santa Eulària des Riu, Ibiza, Îles Baléares, 07814, Espagne"
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
        // CAS 1 : On avait demandé des coords
        // TODO
        // On extrait les coords de la réponse
        // On mémorise les coords dans un settings
        // Cas 2 : On avait demandé des suggestions
        qDebug() << adresse.text();
        // Il y a un bug dans Qt: county et district sont toujours vides. On va les chercher dans le texte.
        QStringList fieldlist = adresse.text().split(", ", Qt::SkipEmptyParts);
        // On mémorise les suggestions
        foreach (QString field, fieldlist) {
            bool isInt;
            field.toInt(&isInt);
            // Si c'est un numérique (ex: code postal), on l'ignore.
            if (!isInt)
            {
                QString target = "city";
                // qDebug() << "compare" << field << adresse.country() << adresse.state();
                if (field == adresse.country()) target = "country";
                else if (field == adresse.state()) target = "country";
                m_suggestionModel->append(field, target, "Geo");
            }
        }
    }
    // The user is responsible for deleting the returned reply object.
    reply->deleteLater();
}


