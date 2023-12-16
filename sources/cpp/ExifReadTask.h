#ifndef EXIFREADTASK_H
#define EXIFREADTASK_H

#include <QRunnable>
#include <QString>
#include "Models/PhotoModel.h"


/* ********************************************************************************************************** */
/*!
 * \class ExifReadTask
 * \inmodule TiPhotoLocator
 * \brief La tache asynchrone ExifReadTask permet de lire les metadonnées d'une photo JPG sur le disque dur.

 Tache asynchrone par utilisation de QThreadPool.

 \note
    les QRunnable n'héritent pas de QObject et ne peuvent donc pas communiquer avec les autres objets à l'aide de signaux.
    Donc, à la fin du traitement, pour actualiser les données du PhotoModel, il faut faire un appel direct à une méthode du modèle.
    Cependant, cela n'est pas contraire aux recommandations: mettre à jour des données peut se faire par appel synchrone.

   \details
   Description of \b JSON options for \c ExifTool.

   \code{.unparsed}
   -j[[+]=*JSONFILE*] (-json)

    Use JSON (JavaScript Object Notation) formatting for console output (or import a JSON file if *JSONFILE* is specified).

    This option may be combined with:
    -g to organize the output into objects by group, or
    -G to add group names to each tag.
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
*/
/* ********************************************************************************************************** */


class ExifReadTask : public QRunnable
{
public:
    explicit ExifReadTask(QString filePath);
    static void init(PhotoModel* photoModel);
    virtual void run();

private:
    void processLine(QByteArray line);
    static bool writeArgsFile();

    // ------------------------------
    // Membres
    // ------------------------------
    QString m_filePath;                //!< Nom du fichier contenant les arguments de ExifTool
    QByteArray m_rxLine;               //!< Données ExifTool en cours de réception
    static QString m_argFile;          //!< A renseigner lors du premier appel.
    static PhotoModel* m_photoModel;   //!< Modèle contenant les photos et leurs tags

};

#endif // EXIFREADTASK_H

