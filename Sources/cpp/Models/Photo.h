#ifndef PHOTO_H
#define PHOTO_H

#include <QList>
#include <QString>

/** **********************************************************************************************************
 * @brief A data structure containing all the attributes for a photo picture: filename, GPS coordinates, etc.
 * ***********************************************************************************************************/
struct Photo
{
    //! Default constructor
    Photo() {}

    //! Constructeur avec valeurs
    Photo( const QString &file_name,
          const QString &image_url,
          const bool is_marker = false,
          const bool is_welcome = false,
          bool is_current = false
          )
    {
        filename = file_name;
        imageUrl = image_url;
        isMarker = is_marker;
        isWelcome = is_welcome;
        isCurrent = is_current;
        isSelected = is_current;
    }

    // Elements de la structure
    QString filename;           //!< Example: "IMG_20230823_1234500.jpg"
    QString imageUrl;           //!< Example: "qrc:///Images/ibiza.png"
    double gpsLatitude = 0;     //!< GPS coordinates. Example: 38.980 (Ibiza)
    double gpsLongitude = 0;    //!< GPS coordinates. Example: 1.4333 (Ibiza)
    // Elements déterminés automatiquement
    bool hasGPS = false;        //!< has GPS coordinates (latitude/longitude)
    bool isCurrent;             //!< Indique que cet item est l'item courant de la ListView
    bool isSelected;            //!< Indique que cet item est sélectionné dans la ListView
    bool isMarker = false;      //!< Exemple: une position sauvegardée sur la carte
    bool isWelcome = false;     //!< Exemple: L'image de la page d'acceuil
    bool insideCircle = false;  //!< inside the radius of nearby photos
    bool toBeSaved = false;     //!< true if one of the following fields has been modified
    // EXIF tags
    QString dateTimeOriginal;   //!< Time when the camera shutter was pressed (no changes allowed in this app)
    QString camModel;           //!< Camera model (no changes allowed in this app)
    QString make;               //!< Camera manifacturer (no changes allowed in this app)
    int imageWidth = 0;         //!< Image width  (no changes allowed in this app)
    int imageHeight = 0;        //!< Image height (no changes allowed in this app)
    int orientation = 1;        //!< 1 = Horizontal
    float shutterSpeed = -1;    //!< Durée d'exposition (no changes allowed in this app)
    float fNumber = -1;         //!< Ouverture (no changes allowed in this app)
    // IPTC tags
    QString creator;            //!< Name of the photographer
    QString city;               //!< City shown in the Photo
    QString country;            //!< Country where the Photo was taken
    QString location;           //!< City quarter or nearby monument or natural monument.
    QString description;        //!< can be: Description, ImageDescription or Caption;
    QString captionWriter;      //!< Initials of the description writer
    QString software;           //!< Software of the camera or scanner device
    QStringList keywords;       //!< This is a list of keywords describing the image

    // Surcharges d'operateurs
    bool operator == (const QString &file_name);
    bool operator == (const Photo &photo);

};



#endif // PHOTO_H
