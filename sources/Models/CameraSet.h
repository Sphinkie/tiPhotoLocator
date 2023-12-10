#ifndef CAMERASET_H
#define CAMERASET_H

#include <QNetworkAccessManager>
#include <QObject>
#include <QString>
#include <QSet>

class CameraSet : public QObject
{
Q_OBJECT

public:
    explicit CameraSet(QObject *parent = nullptr);

    Q_INVOKABLE void append(const QString cam_model);
    Q_INVOKABLE bool contains(const QString cam_model);

public slots:

    void onFinished(QNetworkReply* reply);
    void onError();

private:

    void insert(const QString cam_model);
    void requestThumb(const QString cam_model);

    QSet<QString> m_cameras ;               //!< L'ensemble des Camera
    QNetworkAccessManager* m_networkMgr;    //!< Network Manager pour les accès web
    QString m_deepaiKey;
};

#endif // CAMERASET_H
