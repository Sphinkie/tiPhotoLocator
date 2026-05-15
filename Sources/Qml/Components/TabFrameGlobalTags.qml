import QtQuick
import QtQuick.Layouts
import "../Controllers"


/** *************************************************************************************
 * @brief Onglet avec les tags EXIF et IPTC.
 * *************************************************************************************/
ColumnLayout {


    /*    /// Tableau des tags EXIF
    ZoneExif {
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
*/
    /// Tableau des tags IPTC
    ZoneIptc {
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
