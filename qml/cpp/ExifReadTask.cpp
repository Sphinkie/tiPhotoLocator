#include "ExifReadTask.h"

#include <QProcess>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>
#include <QDebug>

// ------------------------------------------
// Membres statiques
// ------------------------------------------
PhotoModel* ExifReadTask::m_photoModel;
QString ExifReadTask::m_argFile;



/* ********************************************************************************************************** */
/**
 * @brief Constructeur. On enregistre les parmètres.
 * @param filePath: le nom du fichier JPG à lire
 */
ExifReadTask::ExifReadTask(QString filePath)
{
    // On enlève les premiers catactères (cad "file:///")
    qDebug() << "scanFile parameter" << filePath;
    filePath.remove(0,8);
    qDebug() << "scanFile modified" << filePath;
    m_filePath = filePath;
}

/* ********************************************************************************************************** */
/**
 * @brief: Lancement de la tache. On lance exifTool dans un process, et on analyse la réponse.
 * Cette tache est exécutée dans un Thread.
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
    qDebug() << program << arguments;
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
/**
 * @brief La méthode processLine() est appelée répétitivement et analyse une partie du flux texte reçu de exifTool.
 * @param line : the received text
 * @example pour le flux d'une image:
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
        // On envoie les data
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
/**
 * @brief A appeler lors de la première utilisation. Mémorise quelques infos statiques.
 * @param photoModel : la classe appelante, à qui il faudra renvoyer les metadata lues.
 */
void ExifReadTask::init(PhotoModel* photoModel)
{
    ExifReadTask::writeArgsFile();
    ExifReadTask::m_photoModel = photoModel;
}


/* ********************************************************************************************************** */
/**
 * @brief List the tags to be read in the JPG files, and put them in the Arguments file for ExifTool.
 * @return true if the file was successfully created.
 * To learn about the usage of IPTC tags:
 * @see https://iptc.org/std/photometadata/documentation/mappingguidelines/
 * @see https://www.carlseibert.com/guide-iptc-photo-metadata-fields/
 **/
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

