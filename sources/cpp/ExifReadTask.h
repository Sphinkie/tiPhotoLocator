#ifndef EXIFREADTASK_H
#define EXIFREADTASK_H

#include <QRunnable>
#include <QString>
#include "Models/PhotoModel.h"


class ExifReadTask : public QRunnable
{
public:
    explicit ExifReadTask(QString filePath);
    static void init(PhotoModel* photoModel);
    virtual void run();

private:
    void processLine(QByteArray line);
    static bool writeArgsFile();

    // ------------------------------
    // Membres
    // ------------------------------
    QString m_filePath;                //! Nom du fichier contenant les arguments de ExifTool
    QByteArray m_rxLine;               //! Données ExifTool en cours de réception
    static QString m_argFile;          //! A renseigner lors du premier appel.
    static PhotoModel* m_photoModel;   //! Modèle contenant les photos et leurs tags

};

#endif // EXIFREADTASK_H

