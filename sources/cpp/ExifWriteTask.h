#ifndef EXIFWRITETASK_H
#define EXIFWRITETASK_H

#include <QRunnable>
#include <QVariant>

/** *********************************************************************************************************
 * @brief La classe ExifWriteTask permet d'écrire des metadata dans les photos JEG de façon asynchrone.
 *
 *  Tache asynchrone par utilisation de QThreadPool.
 *
 *  @note: les QRunnable n'héritent pas de QObject et ne peuvent donc pas communiquer avec les autres objets à l'aide de signaux.
 *         Donc, à la fin du traitement, pour actualiser les données du PhotoModel, il faut faire un appel direct.
 *         Cependant, cela n'est pas contraire aux recommandations: mettre à jour des données peut se faire par appel synchrone.
 * ********************************************************************************************************** */
class ExifWriteTask : public QRunnable
{
public:
    explicit ExifWriteTask(const QVariantMap exifData, bool generateBackup=false);
    virtual void run();

private:
    // ------------------------------
    // Membres
    // ------------------------------
    QVariantMap m_exifData;          //!< Liste des metadata à ecrire
    bool m_generateBackup;           //!< True si un backup de l'image doit être généré.

};

#endif // EXIFWRITETASK_H


