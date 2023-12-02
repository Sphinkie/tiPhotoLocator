#include "utilities.h"




/* ********************************************************************************************************** */
Utilities::Utilities() {}


/* ********************************************************************************************************** */
/*!
 * \brief Convertit une chaine du type "25/08/2017 08:03" au format "2017:08:25 08:03:00".
 * \param value : Le QVariant contenant la date.
 * \return la date pouvant être écrite dans un tag Exif.
 */
QString Utilities::toExifDate(const QVariant value)
{
    QString date = value.toString();
    QString result = date.mid(6,4) + ':' + date.mid(3,2) + ':' + date.left(2) + date.mid(10,6) + ":00";
    return result;
}


/* ********************************************************************************************************** */
/*!
 * \brief Convertit une chaine du type "2017:08:25 08:03:16" au format naturel "25/0582017 08:03".
 * \param value : Le QVariant contenant la date issue d'un tag Exif.
 * \return la date pouvant être affichée dans un Chip.
 */
QString Utilities::toReadableDate(const QVariant value)
{
    QString date = value.toString();
    QString result = date.mid(8,2) + '/' + date.mid(5,2) + '/' + date.left(4) + ' ' + date.mid(11,5);
    return result;
}
