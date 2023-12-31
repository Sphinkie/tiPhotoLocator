#include <QtLocation>
#include <QtLocation/QGeoServiceProvider>
#include <QtPositioning/QGeoCoordinate>
#include <QSslSocket>                              // pour le plugin OSM
#include <QSettings>
#include <QDebug>

#include "GeocodeWrapper.h"


#define QT_NO_DEBUG_OUTPUT

/* ********************************************************************************************************** */
/*!
 * \brief Le contructeur initialise le provider "OSM".
 * \param suggestion_model : permet de savoir quel objet SuggestionModel appeler une fois les résultats reçus.
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
/*!
 * \brief Envoie une requete pour obtenir des informations sur un jeu de coordonnées GPS.
 *        Par exemple: 38.980 et 1.433 => <a href="https://nominatim.openstreetmap.org/ui/details.html?osmtype=W&osmid=313893003&class=highway">Résultat</a>
 *        La réponse est traitée par geoCodeFinished()
 * \param latitude : coordonnées GPS
 * \param longitude: coordonnées GPS
 */
void GeocodeWrapper::requestReverseGeocode(double latitude, double longitude)
{
    // Réglage de la langues des tags
    QSettings settings;
    int tagLanguage = settings.value("tagLanguage",0).toInt();   // 0: English, 1: default
    if (tagLanguage==0)
        m_geoManager->setLocale(QLocale("en"));
    // Envoi de la requete
    QGeoCoordinate coordinate = QGeoCoordinate(latitude, longitude);
    QGeoCodeReply* geoReply = m_geoManager->reverseGeocode(coordinate);

    // On regarde s'il y a une erreur immédiate
    if (geoReply->isFinished())
    {
        qWarning() << "requestReverseGeocode" << geoReply->error();
        geoReply->deleteLater();
    }
}


/* ********************************************************************************************************** */
/*!
 * \brief Envoie une requete pour obtenir les coordonnées GPS d'un lieu donné par le paramètre city.
 *        La réponse est traitée par geoCodeFinished()
 * \param city : un nom de lieu, par exemple "Marsa el Brega" => 30.4074, 19.5784
 */
void GeocodeWrapper::requestCoordinates(QString city)
{
    QGeoAddress adresse = QGeoAddress();
    adresse.setCity(city);
    QGeoCodeReply* geoReply = m_geoManager->geocode(adresse);
    geoReply->setProperty("coordOnly", true);

    // On regarde s'il y a une erreur immédiate
    if (geoReply->isFinished())
    {
        qWarning() << "requestCoordinates" << geoReply->error();
        geoReply->deleteLater();
    }
}


/* ********************************************************************************************************** */
/*!
 * \brief Signal appelé lors de la réception de la réponse à la request.
 * \param reply : le contenu de la réponse à la request.
 * \note: Exemple: "Santa Eulària des Riu, Ibiza, Îles Baléares, 07814, Espagne"
 *
 * En cas de réponse à une demande de coordonnées: on les mémorise dans le QSettings "homeCoords".
 * En cas de réponse à une demande de reverse Localisation, on passe les réponses au SuggestionModel.
 */
void GeocodeWrapper::geoCodeFinished(QGeoCodeReply* reply)
{
    qDebug() << "finished with code" << reply->error();
    if (reply->error() != QGeoCodeReply::NoError)
        qWarning() << reply->errorString();
    else if (reply->locations().count() >0)
    {
        // On regarde quel type de requete était à l'origine de cette réponse
        QVariant replyType = reply->property("coordOnly");
        QGeoLocation geolocation = reply->locations().value(0);

        if (replyType.isValid())
        {
            // Cas 1 : On avait demandé des coords
            // On extrait les coords de la réponse
            QGeoCoordinate coords = geolocation.coordinate();
            // On les mémorise dans un settings
            QSettings settings;
            settings.setValue("homeCoords", QPointF(coords.latitude(), coords.longitude()));
        }
        else
        {
            // Cas 2 : On avait demandé des suggestions
            const QGeoAddress adresse = geolocation.address();
            qDebug() << adresse.text();
            // Il y a un bug dans Qt: county et district sont toujours vides. On va les chercher dans le texte.
            QStringList fieldlist = adresse.text().split(", ", Qt::SkipEmptyParts);
            // On mémorise les suggestions
            int nb_kw = 2;
            foreach (QString field, fieldlist) {
                bool isInt;
                field.toInt(&isInt);
                // Si c'est un numérique (ex: code postal), on l'ignore.
                if (!isInt)
                {
                    QString target;
                    // qDebug() << "compare" << field << adresse.country() << adresse.state();
                    if (field == adresse.country()) target = "country";
                    else if (field == adresse.state()) target = "country";
                    else target = "city";
                    m_suggestionModel->append(field, target, "geo");
                    // On ajoute aussi N fields (non-numériques) en tant que "tag"
                    if (nb_kw-- >0)
                        m_suggestionModel->append(field, "keywords", "tag");
                }
            }
        }
    }
    // The user is responsible for deleting the returned reply object.
    reply->deleteLater();
}


