import QtQuick
import QtQuick.Layouts
import "../Controllers"


/** *************************************************************************************
 * @brief Onglet avec les tags EXIF et IPTC.
 * *************************************************************************************/
ColumnLayout {

    /// Tableau des tags pouvant être appliqués globalement
    ZoneGlobalTags {
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
