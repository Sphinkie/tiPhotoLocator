#include "ExifWrapper.h"
#include <QFile>
#include <QTextStream>
#include <QProcess>
#include <QDebug>
#include <QCoreApplication>


/**
 * @brief Contructeur. Initialise le fichier de configuration pour exifTools.
 **/
ExifWrapper::ExifWrapper()
{
    this->writeArgsFile();
}

/**
 * @brief Scan all the pictures in a folder with ExifTools
 * @return true if successfull
 **/
bool ExifWrapper::scanFolder(QString folder)
{
    QProcess exifProcess;
    QString folderPath = "E:/TiPhotos";

    qDebug() << QCoreApplication::applicationDirPath();  // For auxiliary binaries shipped with the application: "D:/Mes Programmes/Windows/tiPhotoLocator/build-tiPhotoLocator-Desktop_Qt_5_15_0_MSVC2019_64bit-Debug/debug"
    qDebug() << exifProcess.workingDirectory() ;
    exifProcess.setWorkingDirectory(QCoreApplication::applicationDirPath() + "/../../bin");
    qDebug() << exifProcess.workingDirectory() ;
    // QString program = QCoreApplication::applicationDirPath()+"/exifTool.exe";
    QString program = "exifTool.exe ";
    QStringList arguments;
    arguments << "-@ exiftool.args" << folderPath ;  // TODO to fix

    //    arguments << " > D:/Mes Programmes/Windows/tiPhotoLocator/bin/_result.txt" ;

    qDebug() << "scanFolder" << folder;

    exifProcess.start(program, arguments);
    while(exifProcess.state() != QProcess::NotRunning)
    {
        if (exifProcess.atEnd())
        {
            exifProcess.waitForReadyRead();
        }
        qDebug() << exifProcess.readLine();
    }
    qDebug() << "Finished with code" << exifProcess.exitCode() << exifProcess.exitStatus() ;

    // https://stackoverflow.com/questions/20331668/qxmlstreamreader-reading-from-slow-qprocess

    return true;
}



/**
 * @brief Write the Arg file for ExifTool.
 * @return true if the file was successfully created.
 **/
bool ExifWrapper::writeArgsFile()
{
    QFile file("exiftool.args");
    if (!file.open(QFile::WriteOnly))
        return false;

    QTextStream out(&file);
    // Formattage du flux de sortie de ExifTools
    out << "-preserve "          << Qt::endl;    // Preserve file modification date/time
    out << "-veryShort "          << Qt::endl;    // very short output format  (-S)
    out << "--printConv "          << Qt::endl;    // no print conversion (-n)
    out << "-dateFormat %%Y-%%m-%%d "          << Qt::endl;    // datetime format YYYY-MM-DD
    // Output format (au choix)
    out << "-json "          << Qt::endl;    // output in JSON format
    // out << "-xmlformat -escape(XML) -duplicates "          << Qt::endl;    // output in XML format
    out << Qt::endl;
    // Liste des tags Exif à extraire
    out << "-FileName"          << Qt::endl;    // "P8180028.JPG"
    out << "-FileCreateDate"    << Qt::endl;    // "2018:01:28 20:14:44+01:00" - Ceci semble la date de la prise de vue
    out << "-CreateDate"        << Qt::endl;    // "2017:08:23
    out << "-DateTimeOriginal"  << Qt::endl;    // "2017:08:23
    out << "-ModifyDate"        << Qt::endl;    // "2017:08:23
    out << "-Model"             << Qt::endl;    // "E-M10MarkII"
    out << "-Make"              << Qt::endl;    // "OLYMPUS"
    out << "-ImageWidth"        << Qt::endl;    // 4608
    out << "-ImageHeight"       << Qt::endl;    // 3072
    out << "-Artist"            << Qt::endl;    // "Picasa"
    out << "-ImageDescription"  << Qt::endl;
    // GPS coordinates
    out << "-GPSLatitude"       << Qt::endl;    // 45.4325547675333
    out << "-GPSLongitude"      << Qt::endl;    // 12.3374594498028
    out << "-GPSLatitudeRef"    << Qt::endl;    // "N"
    out << "-GPSLongitudeRef"   << Qt::endl;    // "E"
    // Reverse Geocoding
    out << "-City"              << Qt::endl;
    out << "-Country"           << Qt::endl;
    // TODO : Rendre certains tags configurables depuis le menu settings
    out << "-Caption"           << Qt::endl;
    out << "-DescriptionWriter" << Qt::endl;
    out << "-Headline"          << Qt::endl;
    out << "-Keywords"          << Qt::endl;    // ["Sestire di San Marco","Veneto","Italy","geotagged","geo:lat=45.432555","geo:lon=12.337459"]
    out << "-Title"             << Qt::endl;

    // Fermeture du fichier
    file.close();
    return true;
}

/*
-j[[+]=*JSONFILE*] (-json)
     Use JSON (JavaScript Object Notation) formatting for console output, or import JSON file if *JSONFILE* is specified. This option may be combined with -g to organize the output into objects by group, or -G to add group names to each tag. List-type tags with multiple items are output as JSON arrays unless -sep is used. By default XMP structures are flattened into individual tags in the JSON output, but the original structure may be preserved with the -struct option (this also causes all list-type XMP tags to be output as JSON arrays, otherwise single-item lists would be output as simple strings). The -a option is implied when -json is used,
     but entries with identical JSON names are suppressed in the output. (-G4 may be used to ensure that all tags have unique JSON names.)
     Adding the -D or -H option changes tag values to JSON objects with "val" and "id" fields, and adding -l adds a "desc" field, and a "num" field if the numerical value is different from the converted "val". The -b option may be added to output binary data, encoded in base64 if necessary (indicated by ASCII "base64:" as the first 7 bytes of the value), and -t may be added to include tag table information (see -t for details). The JSON output is UTF-8 regardless of any -L or -charset option setting, but the UTF-8 validation is disabled if a character set other than UTF-8 is specified. Note that ExifTool quotes JSON values only if they don't
     look like numbers (regardless of the original storage format or the relevant metadata specification).

     If *JSONFILE* is specified, the file is imported and the tag definitions from the file are used to set tag values on a per-file basis. The special "SourceFile" entry in each JSON object associates the information with a specific target file. An object with a missing SourceFile or a SourceFile of "*" defines default tags for all target files which are combined with any tags specified for the specific SourceFile processed. The imported JSON file must have the same format as the exported JSON files with the exception that options exporting JSON objects instead of simple values are not compatible with the import file format (ie. export
     with -D, -H, -l, or -T is not compatable, and use -G instead of -g). Additionally, tag names in the input JSON file may be suffixed with a "#" to disable print conversion.

     Unlike CSV import, empty values are not ignored, and will cause an empty value to be written if supported by the specific metadata type. Tags are deleted by using the -f option and setting the tag value to "-" (or to the MissingTagValue setting if this API option was used). Importing with -j+=*JSONFILE* causes new values to be added to existing lists.
*/


// Simple exemple. non utilisé.
bool ExifWrapper::write(const QString& filename, const QString& data)
{
    if (filename.isEmpty())
        return false;

    QFile file(filename);
    if (!file.open(QFile::WriteOnly | QFile::Truncate))
        return false;

    QTextStream out(&file);
    out << data;
    file.close();
    return true;
}
