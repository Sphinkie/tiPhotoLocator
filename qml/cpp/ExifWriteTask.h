#ifndef EXIFWRITETASK_H
#define EXIFWRITETASK_H

#include <QRunnable>
#include <QVariant>

/*!
 * \class ExifWriteTask
 * \brief The ExifWriteTask class
 */
class ExifWriteTask : public QRunnable
{
public:
    explicit ExifWriteTask(const QVariantMap exifData, bool generateBackup=false);
    virtual void run();

private:
    // ------------------------------
    // Membres
    // ------------------------------
    QVariantMap m_exifData;          /// Liste des metadata à ecrire
    bool m_generateBackup;           /// True si un backup de l'image doit être généré.

};

#endif // EXIFWRITETASK_H


/*
 * Methode par utilisation de QThreadPool:
 * Attention: les QRunnnable n'héritent pas de QObject et ne peuvent donc pas communiquer avec les autres objets à l'aide de signaux.
 * Donc, à la fin du traitement, pour actualiser les données du PhotoModel, il faut faire un appel direct.
 * Mais ce n'est pas contraire aux recommandations: metter à jour des données se fait par appel synchrone.
 */
