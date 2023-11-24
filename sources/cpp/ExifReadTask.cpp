#include "ExifReadTask.h"

#include <QProcess>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>
#include <QDebug>


/* ********************************************************************************************************** */
/*!
 * \class ExifReadTask
 * \inmodule TiPhotoLocator
 * \brief La tache asynchrone ExifReadTask permet de lire les metadonnées d'une photo JPG sur le disque dur.

 Tache asynchrone par utilisation de QThreadPool.

 \note:
    les QRunnable n'héritent pas de QObject et ne peuvent donc pas communiquer avec les autres objets à l'aide de signaux.\br
    Donc, à la fin du traitement, pour actualiser les données du PhotoModel, il faut faire un appel direct à une méthode du modèle.\br
    Cependant, cela n'est pas contraire aux recommandations: mettre à jour des données peut se faire par appel synchrone.

   \details Exiftool json options
   Description of \b JSON options for \c ExifTool.
   \code
  -j[[+]=*JSONFILE*] (-json)
  Use JSON (JavaScript Object Notation) formatting for console output (or import a JSON file if *JSONFILE* is specified).
  This option may be combined with:
    -g to organize the output into objects by group,
    or -G to add group names to each tag.
    -a option is implied when -json is used, but entries with identical JSON names are suppressed in the output.
    -G4 may be used to ensure that all tags have unique JSON names.
    -D or -H option changes tag values to JSON objects with "val" and "id" fields
    -l adds a "desc" field, and a "num" field if the numerical value is different from the converted "val".
    -b option may be added to output binary data, encoded in base64 if necessary (indicated by ASCII "base64:" as the first 7 bytes of the value)
    -t may be added to include tag table information (see -t for details).

    List-type tags with multiple items are output as JSON arrays unless -sep is used.
    The JSON output is UTF-8 regardless of any -L or -charset option setting, but the UTF-8 validation is disabled if a character set other than UTF-8 is specified.
    By default XMP structures are flattened into individual tags in the JSON output, but the original structure may be preserved with the -struct option (this also causes all list-type XMP tags to be output as JSON arrays, otherwise single-item lists would be output as simple strings).
    Note that ExifTool quotes JSON values only if they don't look like numbers (regardless of the original storage format or the relevant metadata specification).
  \endcode
  \enddetails
*/
/* ********************************************************************************************************** */

// ------------------------------------------
// Membres statiques
// ------------------------------------------
PhotoModel* ExifReadTask::m_photoModel;
QString     ExifReadTask::m_argFile;


/* ********************************************************************************************************** */
/*!
 * \brief Constructeur. On enregistre le paramètre \a filePath qui le chemin + nom du fichier JPG à lire.\br
 *        A noter que si on passe un nom de chemin, le process va traiter toutes les images du dossier.
 *        Cependant, on évite de le faire car, en termes de performances, ce n'est pas optimisé.
 */
ExifReadTask::ExifReadTask(QString filePath)
{
    // On enlève les premiers caractères (cad "file:///")
    filePath.remove(0,8);
    m_filePath = filePath;
}

/* ********************************************************************************************************** */
/*!
 * \brief: Lancement de la tache. On lance \b exifTool dans un process, et on analyse la réponse.
 * Cette tache est exécutée dans un thread QRunnable.
 */
void ExifReadTask::run()
{
    if (m_filePath.isEmpty())
        m_filePath = QStandardPaths::displayName(QStandardPaths::PicturesLocation);  // TODO : vérifier le résultat

    QProcess exifProcess;
    QString program = "exifTool";
    QStringList arguments;
    // Formattage du flux de sortie de ExifTool
    arguments.append("-json");                 // output in JSON format
    arguments.append("--printConv");           // no print conversion (do not use human-readable tag names)
    arguments.append("-veryShort");            // very short output format  (-S)
    arguments.append("-ext");                  // Filtre sur les extensions
    arguments.append("JPG");
    arguments.append("-ext");                  // Filtre sur les extensions
    arguments.append("JPEG");
    // Liste des tags à lire
    arguments.append("-@");
    arguments.append(m_argFile);
    // Le dossier à scanner
    arguments.append(m_filePath);
    // ---------------------------------------
    // Appel de ExifTool
    // ---------------------------------------
    // qDebug() << program << arguments;
    exifProcess.start(program, arguments);
    while(exifProcess.state() != QProcess::NotRunning)
    {
        // In case of a pause in the reception, we wait.
        if (exifProcess.atEnd())
            exifProcess.waitForReadyRead();
        // When a CRLF is receive, we process the line
        this->processLine(exifProcess.readLine());
    }
    qDebug() << "Task finished" ;
}



/* ********************************************************************************************************** */
/*!
 * \brief Analyse une partie du flux texte reçu de exifTool. Cette méthode est appelée répétitivement. \br
 * \a line : the received text
 * \quotation pour le flux d'une image:
        "[{\r\n"
        "  \"SourceFile\": \"E:/TiPhotos/P8160449.JPG\",\r\n"
        "  \"FileName\": \"P8160449.JPG\",\r\n"
        "  \"DateTimeOriginal\": \"2023:08:16 13:30:20\",\r\n"
        "  \"Model\": \"E-M10MarkII\",\r\n"
        "  \"Make\": \"OLYMPUS CORPORATION\",\r\n"
        "  \"ImageWidth\": 4608,\r\n"
        "  \"ImageHeight\": 3072,\r\n"
        "  \"Artist\": \"\",\r\n"
        "  \"ImageDescription\": \"OLYMPUS DIGITAL CAMERA\",\r\n"
        "  \"GPSLatitude\": 48.7664165199528,\r\n"
        "  \"GPSLongitude\": 14.0194248700017,\r\n"
        "  \"City\": \"Paris\"\r\n"
        "}]\r\n"
    \endquotation
 */
void ExifReadTask::processLine(QByteArray line)
{
    // qDebug() << line;
    if (line.startsWith("{"))
    {
        // Première ligne
        m_rxLine.clear();
        m_rxLine.append(line);
    }
    else if (line.startsWith("}"))
    {
        // Dernière ligne d'une image: on envoie les data
        m_rxLine.append("}");
        QJsonDocument jsonDoc = QJsonDocument::fromJson(m_rxLine);
        QJsonObject jsonObject = jsonDoc.object();
        // On envoie les data au PhotoModel
        m_photoModel->setData(jsonObject.toVariantMap());
    }
    else if (line.startsWith("[{"))
    {
        // Première ligne de la première image
        m_rxLine.clear();
        m_rxLine.append("{");
    }
    else
        m_rxLine.append(line);
}

/* ********************************************************************************************************** */
/*
 * \brief A appeler lors de la première utilisation. Mémorise quelques infos statiques. \br
 * \a photoModel : la classe appelante, à qui il faudra renvoyer les metadata lues.
 */
void ExifReadTask::init(PhotoModel* photoModel)
{
    ExifReadTask::writeArgsFile();
    ExifReadTask::m_photoModel = photoModel;
}


/* ********************************************************************************************************** */
/*!
 * \brief List the tags to be read in the JPG files, and put them in the Arguments file for \c ExifTool.
 * Returns \c true if the file was successfully created. \br
 * To learn about the usage of IPTC tags:
 * \list
 *   \li \l {https://iptc.org/std/photometadata/documentation/mappingguidelines/}
 *   \li \l {https://www.carlseibert.com/guide-iptc-photo-metadata-fields/}
 * \endlist
 */
bool ExifReadTask::writeArgsFile()
{
    ExifReadTask::m_argFile = QStandardPaths::writableLocation(QStandardPaths::TempLocation) + "/exiftool.args";
    qDebug() << "writableLocation:" << m_argFile;
    QFile file(m_argFile);

    if (!file.open(QFile::WriteOnly))
        return false;

    QTextStream out(&file);
    // Liste des tags Exif à extraire
    out << "-FileName"          << Qt::endl;    // "P8180028.JPG"
    //  out << "-FileCreateDate"    << Qt::endl;    // "2023:10:05 20:14:44+01:00" -- Date de copie du fichier sur le disque.
    out << "-DateTimeOriginal"  << Qt::endl;    // "2017:08:25 08:03:16" -- Time of the shutter actuation (normally identical to CreateDate).
    //  out << "-CreateDate"        << Qt::endl;    // "2017:08:25 08:03:16" -- Time that the file was written to the memory card.
    //  out << "-ModifyDate"        << Qt::endl;    // "2021:02:18 16:15:21" -- Date of modification by Photoshop or other
    out << "-Model"             << Qt::endl;    // "E-M10MarkII"         -- Camera model
    out << "-Make"              << Qt::endl;    // "OLYMPUS"             -- Camera maker
    out << "-ImageWidth"        << Qt::endl;    // 4608
    out << "-ImageHeight"       << Qt::endl;    // 3072
    // GPS coordinates
    out << "-GPSLatitude"       << Qt::endl;    // 45.4325547675333
    out << "-GPSLongitude"      << Qt::endl;    // 12.3374594498028
    //  out << "-GPSLatitudeRef"    << Qt::endl;    // "N"
    //  out << "-GPSLongitudeRef"   << Qt::endl;    // "E"
    // IPTC tags
    out << "-Description"       << Qt::endl;    // Description du contenu de la photo (important)
    out << "-ImageDescription"  << Qt::endl;    // Alternate tag label for "Description" (EXIF)
    out << "-Caption"           << Qt::endl;    // Alternate tag label for "Description" (IPTC)
    out << "-Keywords"          << Qt::endl;    // ["Sestire di San Marco","Veneto","Italy","geotagged","geo:lat=45.432555","geo:lon=12.337459"]
    out << "-Artist"            << Qt::endl;    // Name of the photographer (EXIF tag label)
    out << "-Creator"           << Qt::endl;    // Name of the photographer (IPTC tag label)
    // Reverse Geocoding
    out << "-City"              << Qt::endl;
    out << "-Country"           << Qt::endl;
    out << "-Landmark"          << Qt::endl;
    // TODO : Rendre les tags ci-dessous activables depuis le menu settings
    out << "-DescriptionWriter" << Qt::endl;    // (optional) Initials of the writer
    out << "-Headline"          << Qt::endl;    // (optional) Short description in 2 to 5 words

    // Fermeture du fichier
    file.close();
    return true;
}



