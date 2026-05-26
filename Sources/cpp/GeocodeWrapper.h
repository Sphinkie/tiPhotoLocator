#ifndef GEOCODEWRAPPER_H
#define GEOCODEWRAPPER_H

#include <QObject>
#include <QPoint>
#include <QtLocation/QGeoCodingManager>
#include <QGeoLocation>
#include <QGeoCoordinate>
#include "Models/SuggestionModel.h"

/** **********************************************************************************************************
 * @brief The GeocodeWrapper class allows requests to OpenStreetMap for reverse geocoding.
 * @note
    Nécessite d'ajouter les lignes suivantes dans le fichier .pro.
    @code
        QT += positioning
        QT += location
    @endcode
 * ***********************************************************************************************************/

class GeocodeWrapper : public QObject
{
    Q_OBJECT

// -----------------------------------
// Méthodes
// -----------------------------------
public:
    explicit GeocodeWrapper(SuggestionModel* suggestion_model);

signals:
    void centerMap(QGeoCoordinate coord);

public slots:
    void requestReverseGeocode(double lati, double longi);
    void requestCoordinates(const QString& city, const bool home);
    void onShowNextCoords();

private slots:
    void geoCodeFinished(QGeoCodeReply* reply);

private:
    // -----------------------------------
    // Membres
    // -----------------------------------
    QGeoCodingManager* m_geoManager;       //!< Geocoding Manager pour les requètes REST
    SuggestionModel* m_suggestionModel;    //!< Le SuggestionModel qui stockera les reponses.
    QList<QGeoLocation> m_locations;       //!< La liste des différentes coordonnées GPS correspondant au label donné.
    int m_index; //!< L'index des coordonnées GPS actuellement affichées.
};

#endif // GEOCODEWRAPPER_H



