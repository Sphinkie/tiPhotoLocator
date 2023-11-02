#ifndef EXIFREADTASK_H
#define EXIFREADTASK_H

#include <QRunnable>
#include <QString>
#include "Models/PhotoModel.h"

class ExifReadTask : public QRunnable
{
public:
    explicit ExifReadTask(QString filePath);
    virtual void run();
    static void setArgFile(PhotoModel* photoModel);

private:
    void processLine(QByteArray line);
    static bool writeArgsFile();

    // ------------------------------
    // Membres
    // ------------------------------
    QString m_filePath;                /// Nom du fichier contenant les arguments de ExifTool
    QByteArray m_rxLine;               /// Données ExifTool en cours de réception
    static QString m_argFile;          /// A renseigner lors du premier appel.
    static PhotoModel* m_photoModel;   /// Modèle contenant les photos et leurs tags

};

#endif // EXIFREADTASK_H


/*
 * Methode par utilisation de QThreadPool:
 * Attention: les QRunnnable n'héritent pas de QObject et ne peuvent donc pas communiquer avec les autres objets à l'aide de signaux.
 * Donc, à la fin du traitement, pour actualiser les données du PhotoModel, il faut faire un appel direct.
 * Mais ce n'est pas contraire aux recommandations: metter à jour des données se fait par appel synchrone.
 */
