#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkReply>
#include <QRegularExpression>
#include <QSettings>
#include <QStandardPaths>
#include <QUrl>

#include "CameraSet.h"


/** **********************************************************************************************************
 * @brief Ce Constructeur instancie le Network Manager utilisé pour les requètes REST.
 * @param parent: l'objet parent.
 * ***********************************************************************************************************/
CameraSet::CameraSet(QObject *parent) : QObject(parent)
{
    // Pour l'IA générative, la clef-Api est dans les Settings, de façon à ne pas apparaitre en clair dans le code.
    QSettings settings;
    m_deepaiKey = settings.value("deepaikey", "quickstart-QUdJIGlzIGNvbWluZy4uLi4K").toString();
	// Qt recommande de n'instancier le Manager qu'une seule fois. On le fait donc dans le constructeur.
    m_networkMgr = new QNetworkAccessManager(this);
    // Connexion unique : si connect() était appelé dans chaque méthode request*(),
    // le slot onFinished() serait déclenché N fois pour une seule réponse.
    connect(m_networkMgr, &QNetworkAccessManager::finished, this, &CameraSet::onFinished);
}


/** **********************************************************************************************************
 * @brief Ajout d'un modèle de caméra dans la liste.
 *        S'il n'y est pas, on demande à deepAI de générer une imagette.
 * @param cam_maker : marque de l'appareil photo. (champ EXIF Make).
 * @param cam_model : nom du modèle d'appareil photo. (champ EXIF Model).
 * ***********************************************************************************************************/
void CameraSet::append(const QString& cam_maker, const QString& cam_model)
{
    // m_cameras évite les requêtes API en double pour un même modèle.
    if (m_cameras.contains(cam_model))
        return;
    m_cameras.insert(cam_model);
    qInfo() << "** Camera model has no thumbnail, requesting from API:" << cam_model;
    this->requestThumb(cam_maker, cam_model);
}


/** **********************************************************************************************************
 * @brief Retourne l'URL file:/// de la vignette IA en cache sur disque, ou une chaîne vide si absente.
 * @param cam_model : nom du modèle d'appareil photo.
 * @return URL file:/// de l'image, ou QString() si non trouvée.
 * ***********************************************************************************************************/
QString CameraSet::diskUrl(const QString& cam_model) const
{
    QString filename = cam_model;
    filename.remove(QRegularExpression(R"([\s\\/])"));
    const QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)
                         + "/Cameras_AI/" + filename + ".png";
    qDebug() << "scan disc diskUrl:" << filename;
    return QFile::exists(path) ? QUrl::fromLocalFile(path).toString() : QString();
}


/** **********************************************************************************************************
 * @brief Indique si le modèle d'appareil photo demandé est déjà référencé.
 *        Si oui, il possède alors déjà une vignette.
 * @param cam_model : le nom d'un modèle d'appareil photo.
 * @return true si ce modèle existe déja dans le Set.
 * ***********************************************************************************************************/
bool CameraSet::contains(const QString& cam_model)
{
    return m_cameras.contains(cam_model);
}

/** **********************************************************************************************************
 * @brief Ajoute un modèle d'appareil photo dans le Set. On lui fabrique alors une vignette.
 * @param cam_model : le nom d'un modèle d'appareil photo.
 * ***********************************************************************************************************/
void CameraSet::insert(const QString& cam_model)
{
    m_cameras.insert(cam_model);
}


/** **********************************************************************************************************
 * @brief Envoi d'une requete POST à deepai.
 * @param cam_maker : marque de l'appareil photo issue des donnés EXIF.
 * @param cam_model : modèle de camera issue des donnés EXIF.
 * ***********************************************************************************************************/
void CameraSet::requestThumb(const QString& cam_maker, const QString& cam_model)
{
    qDebug() << "requestThumb:" << cam_model;

    // Construction du body JSON via QJsonDocument : gère l'échappement automatiquement.
    // (évite la concaténation manuelle qui casse le JSON si cam_model contient " ou \)
    QJsonObject body;
    body["text"]      = "Realistic front-view photo of camera " + cam_maker + " " + cam_model + ", white background, product shot";
    body["grid_size"] = "1";
    body["width"]     = "320";
    body["height"]    = "320";
    const QByteArray jsonData = QJsonDocument(body).toJson(QJsonDocument::Compact);

    QUrl resource("https://api.deepai.org/api/text2img");
    QNetworkRequest request;
    request.setUrl(resource);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Api-Key", m_deepaiKey.toUtf8());
    // On tague la requête avec le nom du modèle pour pouvoir le récupérer dans onFinished().
    request.setAttribute(QNetworkRequest::User, cam_model);

    m_networkMgr->post(request, jsonData);
}



/** **********************************************************************************************************
 * @brief Appelé lors de la réception d'une réponse à une requete deepai.
 * @param reply : Le contenu de la réponse (URL d'une image).
 * @code
    {   "id": "6e91fc87-f176-45a1-9644-a787238bee10",
        "output_url": "https://api.deepai.org/job-view-file/6e91fc87-f176-45a1-9644-a787238bee10/outputs/output.jpg",
        "share_url": "https://images.deepai.org/art-image/dbc2662a3c824d6a9034f2872f33f1c7/realistic-front-view-photo-of-camera-e-m10markii-whit.jpg",
        "backend_request_id": "e10ccd26-fdc5-45ee-bdd7-187f68734907"
    }
 * @endcode
 * ***********************************************************************************************************/
void CameraSet::onFinished(QNetworkReply* reply)
{
    if (reply->error() != QNetworkReply::NoError) {
        qWarning() << "CameraSet network error:" << reply->errorString();
        reply->deleteLater();
        return;
    }

    const QString cam_model = reply->request().attribute(QNetworkRequest::User).toString();

    if (reply->operation() == QNetworkAccessManager::PostOperation)
    {
        // Étape 1 — réponse text2img : extraire output_url et télécharger l'image
        const QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
        const QString outputUrl = doc.object().value("output_url").toString();
        qDebug() << "CameraSet output_url:" << outputUrl;
        if (!outputUrl.isEmpty()) {
            QNetworkRequest imgReq((QUrl(outputUrl)));
            imgReq.setAttribute(QNetworkRequest::User, cam_model);
            m_networkMgr->get(imgReq);
        }
    }
    else
    {
        // Étape 2 — image reçue : sauvegarder dans AppData/Cameras_AI/
        const QString cacheDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)
                                 + "/Cameras_AI/";
        QDir().mkpath(cacheDir);
        QString filename = cam_model;
        filename.remove(QRegularExpression(R"([\s\\/])"));
        const QString filePath = cacheDir + filename + ".png";
        QFile file(filePath);
        if (file.open(QIODevice::WriteOnly)) {
            file.write(reply->readAll());
            file.close();
            m_cameras.insert(cam_model);
            const QString fileUrl = QUrl::fromLocalFile(filePath).toString();
            emit thumbnailReady(cam_model, fileUrl);
            qInfo() << "Camera thumbnail saved:" << filePath;
        } else {
            qWarning() << "CameraSet: cannot write" << filePath;
        }
    }
    reply->deleteLater();
}


/** **********************************************************************************************************
 * @brief Fonction appelée en cas d'erreur de la demande Rest.
 *        A voir si on met quelque chose d'utile ici.
 * ***********************************************************************************************************/
void CameraSet::onError()
{

}

