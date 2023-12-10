#ifndef CAMERA_H
#define CAMERA_H

#include <QString>

/* ********************************************************************************************************** */
/*!
 * \brief A data structure containing the attributes of a camera picture: Camera Model , camera thumbnail.
 */
struct Camera
{
    //! Default constructor
    Camera() {}


    //! Constructeur avec valeurs
    Camera( const QString &camera_name,
           const QString &camera_thumbnail
           )
    {
        name = camera_name;
        thumbnail = camera_thumbnail;
    }

    // Elements de la structure
    QString name;           //!< Example: "E-M10"
    QString thumbnail;      //!< Example: "qrc:///Camera/E-M10.png"
};


#endif // CAMERA_H
