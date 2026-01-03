#ifndef EXIFWRITETASK_H
#define EXIFWRITETASK_H

#include <QRunnable>
#include <QVariant>
#include "Models/PhotoModel.h"


/** *********************************************************************************************************
 * @brief La classe ExifWriteTask permet d'écrire des metadata dans une photo JPEG de façon asynchrone.
 *
 *  Tache asynchrone par utilisation de QThreadPool.
 *
 *  @note: les QRunnable n'héritent pas de QObject et ne peuvent donc pas communiquer avec les autres objets à
 *         l'aide de signaux.
 *         Cependant, on peut faire un appel direct à la fin du traitement, pour informer le PhotoModel.
 *         Cela n'est pas contraire aux recommandations: modifier des données peut se faire par appel synchrone.
 * ********************************************************************************************************** */
class ExifWriteTask : public QRunnable
{
public:
    explicit ExifWriteTask(const QVariantMap exifData, PhotoModel* photoModel, bool generateBackup=false);
    virtual void run();

private:
    // ---------------------------------------------------------------------------------------
    // Membres
    // ---------------------------------------------------------------------------------------
    QVariantMap m_exifData;        //!< Liste des metadata à écrire.
    bool m_generateBackup;         //!< True si un backup de l'image doit être généré.
    PhotoModel* m_photoModel;      //!< Modèle des photos.

};

#endif // EXIFWRITETASK_H


