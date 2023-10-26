import QtQuick 2.4
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities

ZonePreviewForm {

    chipTime.content: Utilities.toStandardTime(dateTimeOriginal)
    chipDate.content: Utilities.toStandardDate(dateTimeOriginal)

}
