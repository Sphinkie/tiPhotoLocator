#include "ExifWriteTask.h"
#include <QProcess>
#include <QUrl>
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>
#include <QDebug>


/** **********************************************************************************************************
 * @brief Constructeur. On enregistre les paramètres.
 * @param exifData: la liste des metadata à écrire dans le fichier JPG.
 * @param generateBackup: \c true si un backup de l'image doit être généré avant sa modification.
 * Code de remplissage de la QMap:
   @code
        QVariantMap exifData;
        exifData.insert("index",            idx;                       // Index de la photo
        exifData.insert("imageUrl",         idx.data(ImageUrlRole));   // Ce champ sert de clef
        exifData.insert("GPSLatitude",      idx.data(LatitudeRole));
        exifData.insert("GPSLongitude",     idx.data(LongitudeRole));
        exifData.insert("GPSLatitudeRef",   idx.data(LatitudeRole).toInt()>0 ? "N" : "S" );
        exifData.insert("GPSLongitudeRef",  idx.data(LongitudeRole).toInt()>0 ? "E" : "W" );
        exifData.insert("DateTimeOriginal", idx.data(DateTimeOriginalRole));
        exifData.insert("MetadataEditingSoftware", metadataSoftware);
        exifData.insert("Creator",          idx.data(CreatorRole));       // MWG écrit aussi dans Artist
        exifData.insert("City",             idx.data(CityRole));          // MWG écrit dans EXIF et dans IptcExt
        exifData.insert("Country",          idx.data(CountryRole));       // MWG écrit dans EXIF et dans IptcExt
        exifData.insert("Location",         idx.data(LocationRole));      // MWG écrit dans EXIF et dans IptcExt
        exifData.insert("Description",      idx.data(DescriptionRole));   // MWG écrit aussi dans ImageDescription
        exifData.insert("CaptionWriter",    idx.data(CaptionWriterRole)); // On ecrit le Writer que s'il y a une description.
        exifData.insert("Keywords",         idx.data(KeywordsRole));      // Liste des keywords
  @endcode
 * ***********************************************************************************************************/
ExifWriteTask::ExifWriteTask(const QVariantMap exifData, PhotoModel* photoModel, bool generateBackup)
{
    m_exifData = exifData;
    m_photoModel = photoModel;
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
    QUrl url(m_exifData.value("imageUrl").toString());
    // ------------------------------------------------------------------
    // On transforme le chemin du format QML en chemin au format natif.
    // Exemple local path: `file:///P:/Photo/56784.jpg` -> `P:\\Photo\\56784.jpg`
    // Exemple UNC path  : `file:////nas/Photo/141.jpg` -> `\\\\nas\\Photo\\141.jpg`
    // ------------------------------------------------------------------
    QString localPath = url.toLocalFile();
    if (localPath.isEmpty() && url.scheme() == QLatin1String("file") && !url.host().isEmpty())
        localPath = "//" + url.host() + url.path(QUrl::FullyDecoded);
    QString filePath = QDir::toNativeSeparators(localPath);
    if (filePath.isEmpty())
        return;

    QProcess exifProcess;
    QString program = "Bin/exifTool.exe";
    QStringList arguments;
    arguments << "-preserve";           // Preserve file modification date/time
    arguments << "-ext" << "JPG";       // Filtre sur les extensions
    arguments << "-ext" << "JPEG";      // Filtre sur les extensions
    arguments << "-use" << "MWG";       // Use MetadataWorkingGroup recommendations
    arguments << "-charset" << "IPTC=UTF8";
    //arguments << "-dateFormat" << "'%d-%m-%Y'";                    // datetime format DD-MM-YYYY
    if (!m_generateBackup) arguments.append("-overwrite_original");  // Génère un backup si demandé

    // Les valeurs des tags passent par un fichier UTF-8 pour éviter les problèmes
    // d'encodage des arguments en ligne de commande sur Windows (Perl/ExifTool).
    // Fichier temporaire : "C:/Users/David/AppData/Local/Temp/exiftool_write.args"
    QString argsFilePath = QStandardPaths::writableLocation(QStandardPaths::TempLocation) + "/exiftool_write.args";
    QFile argsFile(argsFilePath);
    if (argsFile.open(QFile::WriteOnly | QFile::Text))
    {
        QTextStream out(&argsFile);
        out.setEncoding(QStringConverter::Utf8);
        QMapIterator<QString, QVariant> itr(m_exifData);
        while (itr.hasNext()) {
            itr.next();
            if (itr.key() == "index" || itr.key() == "imageUrl") continue;
            if (itr.key() == "Keywords")
            {
                out << "-Keywords=\n";  // Vide la liste existante
                for (const QString& keyword : itr.value().toStringList())
                    out << "-Keywords=" << keyword << "\n";
            }
            else
            {
                out << "-" << itr.key() << "=" << itr.value().toString() << "\n";
            }
        }
        argsFile.close();
    }
    arguments << "-@" << argsFilePath;
    // Le fichier JPG à modifier
    arguments.append(filePath);
    // ---------------------------------------
    // Appel de ExifTool
    // ---------------------------------------
    qInfo() << program << arguments;
    exifProcess.start(program, arguments);
    while(exifProcess.state() != QProcess::NotRunning)
    {
        // We wait the end
        if (exifProcess.atEnd())
            exifProcess.waitForReadyRead();
        // When a CRLF is receive, it is finished
        QString report = exifProcess.readLine();
        if (!report.isEmpty())
            qInfo() << report.chopped(2);  // On affiche le statut de l'écriture des metadata exif
    }
    // ---------------------------------------
    // Execution terminée pour une photo
    // ---------------------------------------
    QModelIndex idx = m_exifData.value("index").toModelIndex();
    m_photoModel->setData(idx, false, PhotoModel::ToBeSavedRole);
    m_photoModel->setWriteProgress();
}



