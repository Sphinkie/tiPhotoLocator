#include <QJsonDocument>
#include <QNetworkReply>
#include <QSettings>
#include <QUrlQuery>

#include "CameraSet.h"

// qmake: QT += network

/* ********************************************************************************************************** */
CameraSet::CameraSet(QObject *parent) : QObject(parent)
{
    QSettings settings;
    m_deepaiKey = settings.value("deepaikey", "quickstart-QUdJIGlzIGNvbWluZy4uLi4K").toString();
    m_networkMgr = new QNetworkAccessManager(this);
}


/* ********************************************************************************************************** */
/*!
 * \brief Ajout d'un modèle de caméra dans la liste.
 *        S'il n'y est pas, on demande à deepAI de générer une imagette.
 * \param cam_model
 */
void CameraSet::append(const QString cam_model)
{
    if (m_cameras.contains(cam_model))
        return;
    else
        this->requestThumb(cam_model);
}



/* ********************************************************************************************************** */
bool CameraSet::contains(const QString cam_model)
{
    return  m_cameras.contains(cam_model);
}


/* ********************************************************************************************************** */
void CameraSet::insert(const QString cam_model)
{
    m_cameras.insert(cam_model);
}


/* ********************************************************************************************************** */
void CameraSet::requestThumb(const QString cam_model)
{

  //  QNetworkAccessManager* m_networkMgr = new QNetworkAccessManager(this);

    QUrl resource("https://api.deepai.org/api/cyberpunk-generator");

    QNetworkRequest request;
    request.setUrl(resource);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Api-Key", m_deepaiKey.toUtf8());

    // Dans le cas d'un GET, les params sont envoyés à la suite de l'url
    // Dans le cas d'un POST, les params sont envoyés dans le body (mais au format "KEY=VALUE" )
    QUrlQuery params;
//    params.addQueryItem("text", "goelette");
//    params.addQueryItem("text", "goelette on sea, at dusk, in the storm");
//    params.addQueryItem("grid_size", "1");
//    params.addQueryItem("width", "240");
//    params.addQueryItem("height", "240");

    // Exemple de commande GET
    // QNetworkReply* reply = m_networkMgr->get(request);
    // Exemple de commande POST
    // QNetworkReply* reply = m_networkMgr->post(request, params.query(QUrl::FullyEncoded).toUtf8());

    /* methode mbded */
    params.setQuery( "{\"text\":\"fastboat in a night storm\"}" );
 //     resource.setQuery(params);
//     request.setUrl(resource);



    // QString param = "{\"text\":\"goelette\"}";


    qDebug() << "params:" << params.toString();
    qDebug() << "params.query:" << params.query(QUrl::FullyDecoded).toUtf8();

    QNetworkReply* reply = m_networkMgr->post(request, params.query(QUrl::FullyDecoded).toUtf8());
    // QNetworkReply* reply = m_networkMgr->post(request, param.toUtf8());

    connect(m_networkMgr, &QNetworkAccessManager::finished, this, &CameraSet::onFinished); // (autre façon de faire)
//    connect(reply, &QNetworkReply::finished, this, &CameraSet::onFinished);
//    connect(reply, &QNetworkReply::errorOccurred, this, &CameraSet::onError);
//     connect(reply, &QNetworkReply::sslErrors, this, &CameraSet::slotSslErrors);
}



/* ********************************************************************************************************** */
void CameraSet::onFinished(QNetworkReply *reply)
{
    QByteArray contenu = reply->readAll();

    QList<QByteArray> headers = reply->rawHeaderList();
    QListIterator<QByteArray> it(headers);
    while (it.hasNext())
    {
        QByteArray hName = it.next();
        qDebug() << "Header:" << hName << reply->rawHeader(hName);
    };
    qDebug() << "Reply:" << contenu;
}



/* ********************************************************************************************************** */
void CameraSet::onError()
{

}

