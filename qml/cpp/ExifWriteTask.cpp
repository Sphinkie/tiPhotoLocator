#include "ExifWriteTask.h"

#include <QProcess>
#include <QDebug>


/* ********************************************************************************************************** */
/**
 * @brief Constructeur. On enregistre les paramètres.
 * @param exifData: la liste des metadata à écrire dans le fichier JPG
 * @param generateBackup: true si un backup de l'image doit être généré avant sa modification.
 */
ExifWriteTask::ExifWriteTask(const QVariantMap exifData, bool generateBackup)
{
    m_exifData = exifData;
    m_generateBackup = generateBackup;
}

/* ********************************************************************************************************** */
/**
 * @brief: Lancement de la tache. On lance exifTool dans un process, et on écrit les metadata dans l'image JPG.
 * Cette tache est exécutée dans un Thread.
 */
void ExifWriteTask::run()
{
    QString filePath = m_exifData.value("imageUrl").toString();
    // qDebug() << "writeMetadata" << filePath ;
    filePath.remove(0,8);
    if (filePath.isEmpty())
        return;

    QProcess exifProcess;
    QString program = "exifTool";
    QStringList arguments;
    arguments.append("-preserve");             // Preserve file modification date/time
    //    arguments.append("-dateFormat");         // datetime format
    //    arguments.append("'%d-%m-%Y'");          // DD-MM-YYYY
    arguments.append("-ext");                  // Filtre sur les extensions
    arguments.append("JPG");
    arguments.append("-ext");                  // Filtre sur les extensions
    arguments.append("JPEG");
    // Genere un backup si demandé
    if (!m_generateBackup) arguments.append("-overwrite_original");
    // Liste des tags à écrire
    QMapIterator<QString, QVariant> itr(m_exifData);
    while (itr.hasNext()) {
        itr.next();
        arguments.append("-" + itr.key() + "=" + itr.value().toString());
    }
    // Le fichier à modifier
    arguments.append(filePath);
    // ---------------------------------------
    // Appel de ExifTool
    // ---------------------------------------
    qDebug() << program << arguments;
    exifProcess.start(program, arguments);
    while(exifProcess.state() != QProcess::NotRunning)
    {
        // We wait the end
        if (exifProcess.atEnd())
            exifProcess.waitForReadyRead();
        // When a CRLF is receive, it is finished
        qInfo() << exifProcess.readLine();  // On affiche une éventuelle erreur
    }
    // qDebug() << "Finished with code" << exifProcess.exitCode() << exifProcess.exitStatus() ;
}



