#ifndef CAMERASET_H
#define CAMERASET_H

#include <QNetworkAccessManager>
#include <QObject>
#include <QString>
#include <QSet>

/** **********************************************************************************************************
 * @brief La classe CameraSet gère un ensemble de vignettes, correspondant chacune à un modèle d'appareil photo.
 * @note: Necessite QT += network
 * ***********************************************************************************************************/
class CameraSet : public QObject
{
Q_OBJECT

public:
    explicit CameraSet(QObject *parent = nullptr);

    Q_INVOKABLE void    append(const QString& cam_maker, const QString& cam_model);
    Q_INVOKABLE bool    contains(const QString& cam_model);
    Q_INVOKABLE QString diskUrl(const QString& cam_model) const;
    Q_INVOKABLE bool    qrcExists(const QString& qrcPath) const;

signals:
    /** @brief Émis quand la vignette d'un modèle d'APN a été téléchargée et sauvegardée sur disque.
     *  @param cam_model : nom du modèle (clef de lookup).
     *  @param fileUrl   : URL file:/// de l'image sauvegardée. */
    void thumbnailReady(const QString& cam_model, const QString& fileUrl);

public slots:
    void onFinished(QNetworkReply* reply);
    void onError();

private:
    void insert(const QString& cam_model);
    void requestThumb(const QString& cam_maker, const QString& cam_model);

    QSet<QString> m_cameras ;               //!< L'ensemble des Camera
    QNetworkAccessManager* m_networkMgr;    //!< Network Manager pour les accès web
    QString m_deepaiKey;                    //!< API key pour les requètes deepAI
};

#endif // CAMERASET_H
