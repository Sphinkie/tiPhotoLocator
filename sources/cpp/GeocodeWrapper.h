#ifndef GEOCODEWRAPPER_H
#define GEOCODEWRAPPER_H

#include <QObject>
#include <QtLocation/QGeoCodingManager>
#include "Models/SuggestionModel.h"


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
    void requestCoordinates(QString location);

private slots:
    void geoCodeFinished(QGeoCodeReply* reply);

private:
    // -----------------------------------
    // Membres
    // -----------------------------------
    QGeoCodingManager* m_geoManager;
    SuggestionModel* m_suggestionModel;

};

#endif // GEOCODEWRAPPER_H



