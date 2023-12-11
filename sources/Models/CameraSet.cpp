#include <QJsonDocument>
#include <QNetworkReply>
#include <QSettings>
#include <QUrlQuery>

#include "CameraSet.h"

// Note: il faut ajouter la ligne suivante dans le fichier .pro
// QT += network


/* ********************************************************************************************************** */
CameraSet::CameraSet(QObject *parent) : QObject(parent)
{
	// pour deepAI, la clef-Api est dans les Settings, de façon à ne pas apparaitre en clair dans le code.
    QSettings settings;
    m_deepaiKey = settings.value("deepaikey", "quickstart-QUdJIGlzIGNvbWluZy4uLi4K").toString();
	// Qt recommande de n'instancier le Manager qu'une seule fois. On le fait donc dans le constructeur.
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
		// Modèle de caméra dejà connu : on ne fait rien
        return;
    else
        // Modèle de caméra inconnu :
        this->requestMeteo();   // on demande le temps qu'il fait
    // this->requestThumb(cam_model); // on demande une imagette à DeepAI
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
/*!
 * \brief Envoi d'une requete POST à deepai.
 * \param cam_model : non utilisé pour l'instant
 */
void CameraSet::requestThumb(const QString cam_model)
{

  //  QNetworkAccessManager* m_networkMgr = new QNetworkAccessManager(this);  // A été mis dans le Constructeur. Mais peut être mis ici pour les premiers tests. 


	// On definit les paramètres de la requète:
    QUrlQuery params;
	
    // Dans le cas d'une requete POST, les params sont envoyés dans le body 
	// Note: Si on utilise params.addQueryItem() le body sera au format "KEY=VALUE", ce qui ne convient pas pour deepai qui attend un format JSON.
	// On utilise alors plutôt params.setQuery()
    params.setQuery( "{\"text\":\"fastboat in a night storm\"}" );
    // DDL : autres paramètres pour deepai, à ajouter plus tard...
    //    {"grid_size" : "1"}     {"width" : "240"}     {"height" : "240"}

    qDebug() << "params.query:" << params.query(QUrl::FullyDecoded).toUtf8();


    // On definit l'URL de l'API
    QUrl resource("https://api.deepai.org/api/cyberpunk-generator");
    // Apparement, on peut aussi mettre les paramètres dans la query, plutôt que dans la commande m_networkMgr->post()
    // ... A voir ...
    // resource.setQuery(params);

    // On definit la requète HTTP (avec son header)
    QNetworkRequest request;
    request.setUrl(resource);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Api-Key", m_deepaiKey.toUtf8());


    // Envoi de la requète POST
    m_networkMgr->post(request, params.query(QUrl::FullyDecoded).toUtf8());

    // On definit la fonction a appeler lors de la réception de la méthode: CameraSet::onFinished
    connect(m_networkMgr, &QNetworkAccessManager::finished, this, &CameraSet::onFinished);
		
}

/* ********************************************************************************************************** */
/*!
 * \brief Envoi d'une requete GET à openweathermap.
 */
void CameraSet::requestMeteo()
{

    //  QNetworkAccessManager* m_networkMgr = new QNetworkAccessManager(this);  // A été mis dans le Constructeur. Mais peut être mis ici pour les premiers tests.

    // On definit les paramètres de la requète:
    QUrlQuery params;
    // Dans le cas d'une requete GET, les params sont envoyés à la suite de l'url après le ?.
    params.addQueryItem("appid", "000");                            // Mettre son API KEY ici
    params.addQueryItem("q", "Montpellier,FR");
    params.addQueryItem("lang", "fr");

    // On definit l'URL de l'API
    QUrl resource("http://api.openweathermap.org/data/2.5/weather");   // Call current weather data
    resource.setQuery(params);

    // On definit la requète HTTP (avec son header)
    QNetworkRequest request;
    request.setUrl(resource);

    qDebug() << "resource:" << resource.toString();

    // Envoi de la requete GET
    m_networkMgr->get(request);

    // On definit la fonction a appeler lors de la réception de la méthode: CameraSet::onFinished
    connect(m_networkMgr, &QNetworkAccessManager::finished, this, &CameraSet::onFinished);
}

/* ********************************************************************************************************** */
/*!
 * \brief Appelé lors de la réception d'une réponse à une requete deepai.
 * \param Le contenu de la réponse de deepai.
 */
void CameraSet::onFinished(QNetworkReply *reply)
{
	// Pour l'instant, on ne fait juste qu'afficher le contenu de la réponse 	

	// On récupère les headers
    QList<QByteArray> headers = reply->rawHeaderList();
	
	// On affiche, un par un, tous les headers de la réponse. (Bien qu'un seul soit interessant).
    QListIterator<QByteArray> it(headers);
    while (it.hasNext())
    {
        QByteArray hName = it.next();
        qDebug() << "Header:" << hName << reply->rawHeader(hName);
    };

	// On affiche le contenu de la réponse
    QByteArray contenu = reply->readAll();
    qDebug() << "Reply:" << contenu;
}



/* ********************************************************************************************************** */
void CameraSet::onError()
{
	// A voir si on met quelque chose d'utile ici.
}

