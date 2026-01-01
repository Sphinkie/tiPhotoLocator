import QtQuick
import QtQuick.Layouts
import "../Controllers"


/** *************************************************************************************
 * @brief Onglet avec les tags pouvant être appliquées à toutes les photos du dossier.
 * *************************************************************************************/
ColumnLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true

    /// Titre des tags EXIF
    ExifTitle {
        Layout.fillWidth: true
    }

    /// Tableau des tags EXIF
    ExifGrid {
        Layout.fillWidth: true
    }

    /// Titre des tags IPTC
    IptcTitle {
        Layout.fillWidth: true
    }

    /// Tableau des tags IPTC
    IptcGrid {
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
