#include <QFile>
#include <QTextStream>
#include <QProcess>
#include <QDebug>
#include <QCoreApplication>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QJsonObject>
#include "ExifWrapper.h"

/**
 * @brief Contructeur. Initialise le fichier de configuration pour exifTools.
 **/
ExifWrapper::ExifWrapper(PhotoModel* photomodel)
{
    m_photoModel = photomodel;
    this->writeArgsFile();
}

/**
 * @brief ExifWrapper::scanFolder scans all the pictures in a folder with ExifTools.
 * @param folderPath : the folder to scan (ex: "E:\\TiPhotos")
 * @return true if successfull
 * @see https://stackoverflow.com/questions/20331668/qxmlstreamreader-reading-from-slow-qprocess
 **/
bool ExifWrapper::scanFolder(QString folderPath)
{
    qDebug() << "scanFolder parameter :" << folderPath;
    folderPath.remove(0,8);
    // if (folderPath.isEmpty())
        folderPath = "E:/TiPhotos";
    qDebug() << "scanFolder final format" << folderPath;

    QProcess exifProcess;
    QString program = "exifTool";
    QStringList arguments;
    // Formattage du flux de sortie de ExifTool
    arguments.append("-json");                      // output in JSON format
    arguments.append("--printConv");                // no print conversion (-n)
    arguments.append("-preserve");                  // Preserve file modification date/time
    arguments.append("-veryShort");                 // very short output format  (-S)
    arguments.append("-dateFormat");    // datetime format
    arguments.append("'%Y-%m-%d'");    // YYYY-MM-DD : N'est pas pris en compte ...
    arguments.append("-ext");                  // Filtre sur les extensions
    arguments.append("JPG");
    arguments.append("-ext");                  // Filtre sur les extensions
    arguments.append("JPEG");
    // Liste des tags à lire
    arguments.append("-@");
    arguments.append(m_argFile);
    // Le dossier à scanner
    arguments.append(folderPath);
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
    qDebug() << "Finished with code" << exifProcess.exitCode() << exifProcess.exitStatus() ;
    return true;
}


/**
 * @brief Write the Arg file for ExifTool.
 * @return true if the file was successfully created.
 * @see https://www.carlseibert.com/guide-iptc-photo-metadata-fields/ to learn about the usage of IPTC tags.
 * @see https://iptc.org/std/photometadata/documentation/mappingguidelines/
 **/
bool ExifWrapper::writeArgsFile()
{
    m_argFile = QStandardPaths::writableLocation(QStandardPaths::TempLocation) + "/exiftool.args";
    qDebug() << "TempLocation:" << m_argFile;
    QFile file(m_argFile);

    if (!file.open(QFile::WriteOnly))
        return false;

    QTextStream out(&file);
    // Liste des tags Exif à extraire
    out << "-FileName"          << Qt::endl;    // "P8180028.JPG"
    out << "-FileCreateDate"    << Qt::endl;    // "2018:01:28 20:14:44+01:00" - Ceci semble la date de la prise de vue
    out << "-CreateDate"        << Qt::endl;    // "2017:08:23 08:03:16"
    out << "-DateTimeOriginal"  << Qt::endl;    // "2017:08:23 08:03:16"
    out << "-ModifyDate"        << Qt::endl;    // "2017:08:23 08:03:16"
    out << "-Model"             << Qt::endl;    // "E-M10MarkII"
    out << "-Make"              << Qt::endl;    // "OLYMPUS"
    out << "-ImageWidth"        << Qt::endl;    // 4608
    out << "-ImageHeight"       << Qt::endl;    // 3072
    // GPS coordinates
    out << "-GPSLatitude"       << Qt::endl;    // 45.4325547675333
    out << "-GPSLongitude"      << Qt::endl;    // 12.3374594498028
    out << "-GPSLatitudeRef"    << Qt::endl;    // "N"
    out << "-GPSLongitudeRef"   << Qt::endl;    // "E"
    // IPTC tags
    // TODO : Menu settings: choisir le tag à écrire: Description ou ImageDescription ou Caption
    out << "-Description"       << Qt::endl;    // Description du contenu de la photo (important)
    out << "-ImageDescription"  << Qt::endl;    // Alternate tag label for "Description" (EXIF)
    out << "-Caption"           << Qt::endl;    // Alternate tag label for "Description" (IPTC)
    out << "-Keywords"          << Qt::endl;    // ["Sestire di San Marco","Veneto","Italy","geotagged","geo:lat=45.432555","geo:lon=12.337459"]
    // TODO : Menu settings: renseigner la valeur par défaut pour Artist/Creator
    // TODO : Menu settings: choisir le tag à écrire: Artist ou Creator
    out << "-Artist"            << Qt::endl;    // Name of the photographer (EXIF tag label)
    out << "-Creator"           << Qt::endl;    // Name of the photographer (IPTC tag label)
    // Reverse Geocoding
    out << "-City"              << Qt::endl;
    out << "-Country"           << Qt::endl;
    // TODO : Rendre les tags ci-dessous activables depuis le menu settings
    // TODO : Menu settings: renseigner la valeur par défaut pour DescriptionWriter
    out << "-DescriptionWriter" << Qt::endl;    // (optional) Initials of the writer
    out << "-Headline"          << Qt::endl;    // (optional) Short description in 2 to 5 words

    // Fermeture du fichier
    file.close();
    return true;
}

/*
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

*/


/**
 * @brief ExifWrapper::processLine analyse une partie de texte reçu de exifTool.
 * @param line : the received text
 * @example (N times inside a table [...] ):
        "{\r\n"
        "  \"SourceFile\": \"E:/TiPhotos/P8160449.JPG\",\r\n"
        "  \"FileName\": \"P8160449.JPG\",\r\n"
        "  \"FileCreateDate\": \"2023:09:18 21:38:26+02:00\",\r\n"   -- QString
        "  \"CreateDate\": \"2023:08:16 13:30:20\",\r\n"
        "  \"DateTimeOriginal\": \"2023:08:16 13:30:20\",\r\n"
        "  \"ModifyDate\": \"2023:08:16 13:30:20\",\r\n"
        "  \"Model\": \"E-M10MarkII\",\r\n"
        "  \"Make\": \"OLYMPUS CORPORATION\",\r\n"
        "  \"ImageWidth\": 4608,\r\n"                                -- qlonglong
        "  \"ImageHeight\": 3072,\r\n"
        "  \"Artist\": \"\",\r\n"
        "  \"ImageDescription\": \"OLYMPUS DIGITAL CAMERA\",\r\n"
        "  \"GPSLatitude\": 48.7664165199528,\r\n"                   -- double
        "  \"GPSLongitude\": 14.0194248700017,\r\n"
        "  \"GPSLatitudeRef\": \"N\",\r\n"
        "  \"GPSLongitudeRef\": \"E\",\r\n"
        "  \"City\": \"Paris\"\r\n"
        "},\r\n"
 * Premiere ligne: "[{\r\n"
 * Dernière ligne: "}]\r\n"
 */
void ExifWrapper::processLine(QByteArray line)
{
    qDebug(line);
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
        QVariantMap photo_desc;
        photo_desc = jsonObject.toVariantMap();
        m_photoModel->setData(photo_desc);          // TODO : remplacer par un signal
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

/*
setData
QVariantMap: QMap(
("FileName",    QVariant(QString, "P8160449.JPG"))
("Artist",      QVariant(QString, "Picasa"))
("CreateDate",  QVariant(QString, "2023:08:16 13:30:20"))
("DateTimeOriginal",    QVariant(QString, "2023:08:16 13:30:20"))
("FileCreateDate",      QVariant(QString, "2023:09:18 21:38:26+02:00"))
("GPSLatitude",         QVariant(double, 48.7664))("GPSLatitudeRef", QVariant(QString, "N"))
("GPSLongitude",        QVariant(double, 14.0194))("GPSLongitudeRef", QVariant(QString, "E"))
("ImageDescription",    QVariant(QString, "OLYMPUS DIGITAL CAMERA         "))
("ImageHeight", QVariant(qlonglong, 3072))
("ImageWidth",  QVariant(qlonglong, 4608))
("Make",        QVariant(QString, "OLYMPUS CORPORATION"))
("Model",       QVariant(QString, "E-M10MarkII"))
("ModifyDate",  QVariant(QString, "2023:08:16 13:30:20"))
("SourceFile",  QVariant(QString, "E:/TiPhotos/P8160449.JPG")))

*/
