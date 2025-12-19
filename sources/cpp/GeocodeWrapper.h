#ifndef GEOCODEWRAPPER_H
#define GEOCODEWRAPPER_H

#include <QObject>
#include <QtLocation/QGeoCodingManager>
#include "Models/SuggestionModel.h"

/* ********************************************************************************************************** */
/* **********************************************************************************************************
 * \class GeocodeWrapper
 * @brief The GeocodeWrapper class allows requests to OpenStreetMap for reverse geocoding.
 * \note
    Nécessite d'ajouter les lignes suivantes dans le fichier .pro.
    \code
        QT += positioning
        QT += location
    \endcode
*/
/* ********************************************************************************************************** */

class GeocodeWrapper : public QObject
{
    Q_OBJECT

public:
    // -----------------------------------
    // Méthodes
    // -----------------------------------
    explicit GeocodeWrapper(SuggestionModel* suggestion_model);

public slots:
    // -----------------------------------
    // Slots
    // -----------------------------------
    void requestReverseGeocode(double latitude, double longitude);
    void requestCoordinates(QString city);

private slots:
    void geoCodeFinished(QGeoCodeReply* reply);

private:
    // -----------------------------------
    // Membres
    // -----------------------------------
    QGeoCodingManager* m_geoManager;       //!< Geocoding Manager pour les requètes REST
    SuggestionModel* m_suggestionModel;    //!< Le SuggestionModel qui stockera les reponses.

};

#endif // GEOCODEWRAPPER_H



