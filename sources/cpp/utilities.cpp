#include "utilities.h"


/* ********************************************************************************************************** */
Utilities::Utilities() {}


/* ********************************************************************************************************** */
/*!
 * \brief Convertit une chaine du type "25/08/2017 08:03" au format "2017:08:25 08:03:00".
 * \param value : Le QVariant contenant la nouvelle date.
 * \return la date pouvant être écrite dans un tag Exif.
 *
 * La fonction est intelligente et reconnait s'il s'agit d'une Date, d'un Time ou d'un DateTime.
 * - DateTime : "25/08/2017 08:03" ->  "2017:08:25 08:03:00" (convertion + ajout des secondes)
 * - Date     : "25/08/2017"       ->  "2017:08:25 02:15:45" (convertion + conservation du time)
 * - Time     : "08:03"            ->  "1934:01:10 08:03:00" (convertion + conservation de la date)
 */
QString Utilities::toExifDate(const QVariant value)
// QString Utilities::toExifDate(const QVariant value, const QString old_value)
{
    QString dtValue = value.toString();
    QString result;
    /*
    if (dtValue.length() == 5)
    {
        // Time
        result = dtValue + ":00";
    }
    else if (dtValue.length() == 10)
    {
        // Date
        result = dtValue.mid(6,4) + ':' + dtValue.mid(3,2) + ':' + dtValue.left(2);
    }
    else
        */
        // DateTime
    result = dtValue.mid(6,4) + ':' + dtValue.mid(3,2) + ':' + dtValue.left(2) + dtValue.mid(10,6) + ":00";
    qDebug() << dtValue << "->" << result;
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
