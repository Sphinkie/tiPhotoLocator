#include "LandmarkWrapper.h"

#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QImage>
#include <QBuffer>
#include <QFile>
#include <QUrl>

static const char* API_URL =
    "https://api.groq.com/openai/v1/chat/completions";

static const char* PROMPT =
    "Examine this photo carefully.\n\n"
    "If you can identify a specific famous landmark, monument, historic site, or well-known tourist location, "
    "respond with ONLY these lines (no extra text):\n"
    "NAME: <name of the place>\n"
    "LAT: <decimal latitude>\n"
    "LON: <decimal longitude>\n\n"
    "If the photo shows only generic content (countryside, fields, sea, sky, portrait, animals, food "
    "or any unidentifiable place), respond with ONLY:\n"
    "LOCATION: unidentified";

/** **********************************************************************************************************
 * @brief Contructeur.
 * ***********************************************************************************************************/
LandmarkWrapper::LandmarkWrapper(QObject* parent) : QObject(parent) {}


/** **********************************************************************************************************
 * @brief Encode l'image en binaire et envoie la requete REST à l'API Groq.
 * @note: Le token Groq doit avoir été mis dans la configuration
 * ***********************************************************************************************************/
void LandmarkWrapper::identify(const QString& imageUrl, const QString& apiKey)
{
    if (apiKey.isEmpty()) {
        emit networkError(tr("VisionLanguageModel API key is not set."));
        return;
    }

    // Chargement et redimensionnement de l'image (max 1024px)
    QString localPath = QUrl(imageUrl).toLocalFile();
    QImage img(localPath);
    if (img.isNull()) {
        emit networkError(tr("Cannot read image: ") + localPath);
        return;
    }
    if (img.width() > 1024 || img.height() > 1024)
        img = img.scaled(1024, 1024, Qt::KeepAspectRatio, Qt::SmoothTransformation);

    QByteArray imageData;
    QBuffer buffer(&imageData);
    buffer.open(QIODevice::WriteOnly);
    img.save(&buffer, "JPEG", 85);

    QString dataUrl = "data:image/jpeg;base64," + imageData.toBase64();

    // Construction du corps JSON (format OpenAI-compatible)
    QJsonObject imageUrlObj;
    imageUrlObj["url"] = dataUrl;

    QJsonObject imageContent;
    imageContent["type"]      = "image_url";
    imageContent["image_url"] = imageUrlObj;

    QJsonObject textContent;
    textContent["type"] = "text";
    textContent["text"] = PROMPT;

    QJsonArray content;
    content.append(imageContent);
    content.append(textContent);

    QJsonObject userMessage;
    userMessage["role"]    = "user";
    userMessage["content"] = content;

    QJsonArray messages;
    messages.append(userMessage);

    QJsonObject body;
    body["model"]            = "qwen/qwen3.6-27b";
    body["messages"]         = messages;
    body["max_tokens"]       = 150;
    body["reasoning_effort"] = "none"; // qwen3.6 est un modèle "thinking" par défaut. Or on veut une réponse directe.

    QNetworkRequest request((QUrl(API_URL)));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", ("Bearer " + apiKey).toUtf8());

    QNetworkReply* reply = m_manager.post(request, QJsonDocument(body).toJson());
    connect(reply, &QNetworkReply::finished, this, &LandmarkWrapper::onReplyFinished);
}


/** **********************************************************************************************************
 * @brief Signal appelé lors de la réception de la réponse à la request.
 * La réponse contient un JSON, soit vide; soit avec un texte contenant NAME, LON, LAT.
 * ***********************************************************************************************************/
void LandmarkWrapper::onReplyFinished()
{
    auto* reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply) return;
    reply->deleteLater();

    const QByteArray body = reply->readAll();
    const int httpStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

    if (reply->error() != QNetworkReply::NoError) {
        qDebug() << "LandmarkWrapper body error:" << body;
        if (httpStatus == 429)
            emit networkError(tr("Groq rate limit reached, please wait a moment before retrying."));
        else
            emit networkError(reply->errorString() + " | " + QString::fromUtf8(body));
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(body);
    if (doc.isNull()) {
        emit networkError(tr("Invalid JSON response from API."));
        return;
    }

    QString content = doc["choices"][0]["message"]["content"].toString().trimmed();

    if (content.contains("LOCATION: unidentified", Qt::CaseInsensitive)) {
        qDebug() << "LandmarkWrapper cannot identify location:" << body;
        emit locationUnknown();
        return;
    }

    // Parsing des lignes NAME / LAT / LON
    QString name;
    double lat = 0.0, lon = 0.0;
    bool okLat = false, okLon = false;
    qDebug() << "LandmarkWrapper has identified a location:" << body;

    for (const QString& line : content.split('\n')) {
        const QString t = line.trimmed();
        if (t.startsWith("NAME:"))
            name = t.mid(5).trimmed();
        else if (t.startsWith("LAT:"))
            lat = t.mid(4).trimmed().toDouble(&okLat);
        else if (t.startsWith("LON:"))
            lon = t.mid(4).trimmed().toDouble(&okLon);
    }

    if (!name.isEmpty() && okLat && okLon) {
        qDebug() << "LandmarkWrapper:" << name << "LAT:" << lat << "LON:" << lon;
        emit landmarkFound(name, lat, lon);
    } else {
        qDebug() << "LandmarkWrapper: location unidentified. Raw response:" << content;
        emit locationUnknown();
    }
}
