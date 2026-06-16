#ifndef LANDMARKWRAPPER_H
#define LANDMARKWRAPPER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

/** **********************************************************************************************************
 * @brief Interroge le modèle Llama-3.2-Vision (HuggingFace Inference API) pour identifier
 *        un monument ou un lieu célèbre visible sur une photo.
 *
 * Signaux émis après la réponse :
 *  - landmarkFound(name, lat, lon) : un lieu a été identifié
 *  - locationUnknown()             : aucun lieu identifiable
 *  - networkError(message)         : erreur réseau ou API
 * ***********************************************************************************************************/
class LandmarkWrapper : public QObject
{
    Q_OBJECT

public:
    explicit LandmarkWrapper(QObject* parent = nullptr);

    Q_INVOKABLE void identify(const QString& imageUrl, const QString& apiKey);

signals:
    void landmarkFound(const QString& name, double latitude, double longitude);
    void locationUnknown();
    void networkError(const QString& message);

private slots:
    void onReplyFinished();

private:
    QNetworkAccessManager m_manager;
};

#endif // LANDMARKWRAPPER_H
