#ifndef EXIFWRITETASK_H
#define EXIFWRITETASK_H

#include <QRunnable>
#include <QVariant>

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


