#include "ExifWriteTask.h"
#include <QProcess>
#include <QDebug>


/* ********************************************************************************************************** */
/*!
 * \class ExifWriteTask
 * \inmodule TiPhotoLocator
 * \brief La classe ExifWriteTask permet d'écrire des metadata dans les photos JEG de façon asynchrone.

   Tache asynchrone par utilisation de QThreadPool.

   \note: les QRunnable n'héritent pas de QObject et ne peuvent donc pas communiquer avec les autres objets à l'aide de signaux.\br
          Donc, à la fin du traitement, pour actualiser les données du PhotoModel, il faut faire un appel direct.\br
          Cependant, cela n'est pas contraire aux recommandations: mettre à jour des données peut se faire par appel synchrone.
 */
/* ********************************************************************************************************** */


/* ********************************************************************************************************** */
/*!
 \brief Constructeur. On enregistre les paramètres.\br
 \a exifData: la liste des metadata à écrire dans le fichier JPG.\br
 \a generateBackup: \c true si un backup de l'image doit être généré avant sa modification.
 \code
     QVariantMap: QMap(
      ("SourceFile",       QVariant(QString,   "E:/TiPhotos/P8160449.JPG"))
      ("FileName",         QVariant(QString,   "P8160449.JPG"))
      ("Artist",           QVariant(QString,   "Blemia Borowicz"))
      ("DateTimeOriginal", QVariant(QString,   "2023:08:16 13:30:20"))
      ("GPSLatitude",      QVariant(double,    48.7664))
      ("GPSLatitudeRef",   QVariant(QString,   "N"))
      ("GPSLongitude",     QVariant(double,    14.0194))
      ("GPSLongitudeRef",  QVariant(QString,   "E"))
      ("Make",             QVariant(QString,   "OLYMPUS CORPORATION"))
      ("Model",            QVariant(QString,   "E-M10MarkII"))
      )
  \endcode
 */
ExifWriteTask::ExifWriteTask(const QVariantMap exifData, bool generateBackup)
{
    m_exifData = exifData;
    m_generateBackup = generateBackup;
}


/* ********************************************************************************************************** */
/*!
 * \brief Lancement de la tache. On lance \b exifTool dans un QProcess, et on écrit les metadata dans l'image JPG. \br
 * Cette tache est exécutée dans un thread QRunnable.
 */
void ExifWriteTask::run()
{
    QString filePath = m_exifData.value("imageUrl").toString();
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
    // Genere un backup (si demandé)
    if (!m_generateBackup) arguments.append("-overwrite_original");
    // Liste des tags à écrire
    QMapIterator<QString, QVariant> itr(m_exifData);
    while (itr.hasNext()) {
        itr.next();
        arguments.append("-" + itr.key() + "=" + itr.value().toString().toUtf8());
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



