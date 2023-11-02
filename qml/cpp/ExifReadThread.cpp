#include "ExifReadThread.h"
#include "ExifReadWorker.h"

ExifReadThread::ExifReadThread(QString filePath, uint debut, uint fin, QObject *parent) :  QObject(parent), debut_(debut), fin_(fin), thread_(new QThread(this))
{
    m_filePath = filePath;
}


void ExifReadThread::start()
{
    ExifReadWorker* worker = new ExifReadWorker(m_filePath, debut_, fin_);

    connect(worker, SIGNAL(signalWorkerEnded(uint)), this, SLOT(onWorkerEnded(uint)));
    connect(worker, SIGNAL(destroyed()), thread_, SLOT(deleteLater())); //Auto-nettoyage du thread

    connect(thread_, SIGNAL(finished()), worker, SLOT(deleteLater()));
    //Quelle est l'affinité de thread de worker ?
    worker->moveToThread(thread_);

    //QTimer::singleShot(0, worker, &MonWorker::start);
    QMetaObject::invokeMethod(worker, "start", Qt::QueuedConnection); //Ne pas appeler directement la fonction start() !
    thread_->start();

    connect(thread_, &QThread::started, [=]{ qDebug() << "MonThread::start, thread " << " id=" << thread_->currentThreadId(); });
    connect(thread_, &QObject::destroyed, this, &QObject::deleteLater);

    qDebug() << "";
    qDebug() << "MonThread::start, caller thread id=" << thread()->currentThreadId();

}

void ExifReadThread::stop()
{
    //Mettre du code ici pour permettre d'interrompre le fonctionnement du worker
}


void ExifReadThread::onWorkerEnded(uint val)
{
    emit signalNouvelleValeur(val);
    thread_->exit(); //On en profite pour terminer le thread
}
