#ifndef EXIFREADTHREAD_H
#define EXIFREADTHREAD_H

#include <QObject>
#include <QThread>
#include <QDebug>

class ExifReadThread : public QObject
{
    Q_OBJECT

public:
    explicit ExifReadThread(QString filePath, uint debut, uint fin, QObject *parent = 0);

public slots:
    void start();
    void stop();

signals:
    void signalNouvelleValeur(uint);

private slots:
    void onWorkerEnded(uint);

private:
    uint debut_;
    uint fin_;
    QString m_filePath;
    QThread* thread_;
};

#endif // EXIFREADTHREAD_H
