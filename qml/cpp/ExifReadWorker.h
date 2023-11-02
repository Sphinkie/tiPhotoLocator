#ifndef EXIFREADWORKER_H
#define EXIFREADWORKER_H

#include <QObject>
#include <QDebug>


/**
 * @brief The ExifReadWorker class
 */
class ExifReadWorker : public QObject
{
    Q_OBJECT

public:
    ExifReadWorker(QString filePath, uint debut, uint fin,  QObject* parent = 0);
    ~ExifReadWorker() { qDebug() << "Destruction du worker"; }
    void setArgFile(QString argFile);


public slots:
    void start();
    void stop();

signals:
    void signalWorkerEnded();

private:
    uint valeur_;
    uint debut_;
    uint fin_;

    void processLine(QByteArray line);
    QString m_filePath;            /// Nom du fichier contenant les argements de ExifTool
    QByteArray m_rxLine;           /// Ligne ExifTool en cours de réception
    static QString m_argFile;      /// A renseigner lors du premier appel.

};

#endif // EXIFREADWORKER_H



/*
 * Methode 2:
 * Utilisation de QThread: une classe ExifReadThread + une classe ExifReadWorker + une classe ExifReadController
 *
 */
