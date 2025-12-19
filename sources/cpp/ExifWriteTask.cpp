#include "ExifWriteTask.h"
#include "utilities.h"
#include <QProcess>
#include <QDebug>


/** **********************************************************************************************************
 * @brief Constructeur. On enregistre les paramètres.
 * @param exifData: la liste des metadata à écrire dans le fichier JPG.
 * @param generateBackup: \c true si un backup de l'image doit être généré avant sa modification.
   @code
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
  @endcode
 * ***********************************************************************************************************/
ExifWriteTask::ExifWriteTask(const QVariantMap exifData, bool generateBackup)
{
    m_exifData = exifData;
    m_generateBackup = generateBackup;
}


/** **********************************************************************************************************
 * @brief Lancement de la tache. On lance **exifTool** dans un QProcess, et on écrit les metadata dans l'image JPG.
 *        Cette tache est exécutée dans un thread QRunnable.
 * @note Le mode MWG de ExifTool permet d'ecrire en une fois dans les différents tags équivalents (ex: Artist et Creator,
 *       ou bien EXIF:City et IptcExt:City, etc). Le Metadata Working Group recommande de garder ces tags EXIF et IPTC
 *       synchronisés.
 * @note Pour vérifier les tags écrits: `exiftool -G1 -a -s -XMP-iptcCore:All -XMP-iptcExt:All mypicture.jpg`
 *       (-G1 = Group 1 = "Location")
 *       (-s = shows tag names instead of description)
 * @sa https://exiftool.org/TagNames/MWG.html
 * ***********************************************************************************************************/
void ExifWriteTask::run()
{
    QString filePath = m_exifData.value("imageUrl").toString();
    filePath.remove(0,8);
    if (filePath.isEmpty())
        return;

    QProcess exifProcess;
    QString program = "exifTool";
    QStringList arguments;
    arguments << "-preserve";           // Preserve file modification date/time
    arguments << "-ext" << "JPG";       // Filtre sur les extensions
    arguments << "-ext" << "JPEG";      // Filtre sur les extensions
    arguments << "-use" << "MWG";       // Use MetadataWorkingGroup recommendations
    //arguments << "-dateFormat" << "'%d-%m-%Y'";   // datetime format DD-MM-YYYY
    //arguments.append("-use"); arguments.append("MWG");    // Use MetadataWorkingGroup recommendations
    if (!m_generateBackup) arguments.append("-overwrite_original");     // Genere un backup si demandé
    // Liste des tags à écrire
    QMapIterator<QString, QVariant> itr(m_exifData);
    while (itr.hasNext()) {
        itr.next();
        if (itr.key() == "Keywords")
        {
            // La valeur est une liste de mot-clefs
            foreach (QString keyword, itr.value().toStringList())
            {
                arguments.append("-Keywords=" + keyword.toUtf8());
            }
        }
        else
        {
            // On normalise la String en pur ASCII
            arguments.append("-" + itr.key() + "=" + Utilities::normalise(itr.value().toString()));
        }
    }
    // Le fichier JPG à modifier
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



