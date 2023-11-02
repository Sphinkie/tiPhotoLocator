#include "ExifReadWorker.h"
#include <QProcess>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>


// ------------------------------------------
// Membres statiques
// ------------------------------------------
QString ExifReadWorker::m_argFile;


/**
 * @brief Constructeur.
 */
    ExifReadWorker::ExifReadWorker(QString filePath, uint debut, uint fin, QObject *parent) : QObject(parent), valeur_(0), debut_(debut), fin_(fin)
{
    qDebug() << "scanFile parameter" << filePath;
    filePath.remove(0,8);
    qDebug() << "scanFile modified" << filePath;
    m_filePath = filePath;
}

void ExifReadWorker::start()
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
    qDebug() << "scanFile finished" ;
    emit signalWorkerEnded();
}



/* ********************************************************************************************************** */
/**
 * @brief La méthode processLine() analyse une partie de texte reçu de exifTool.
 * @param line : the received text
 * @example (N times inside a table [...] ):
        "{\r\n"
        "  \"SourceFile\": \"E:/TiPhotos/P8160449.JPG\",\r\n"
        "  \"FileName\": \"P8160449.JPG\",\r\n"
        "  \"DateTimeOriginal\": \"2023:08:16 13:30:20\",\r\n"
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
void ExifReadWorker::processLine(QByteArray line)
{
    qDebug() << line;
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
        // TODO m_photoModel->setData(photo_desc);          // TODO : Remplacer par un signal
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


void ExifReadWorker::setArgFile(QString argFile)
{
    ExifReadWorker::m_argFile = argFile;
}

void ExifReadWorker::stop()
{
    //Mettre du code ici pour interrompre le fonctionnement du worker
}

