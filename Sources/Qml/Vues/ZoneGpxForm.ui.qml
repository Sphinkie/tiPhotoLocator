import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"

/** **********************************************************************************************************
 * @brief Cette zone affiche les fichiers GPX associés au dossier de photos (onglet GPS LOGGER).
 * ***********************************************************************************************************/
Zone {
    id: gpxZone
    property alias bt_refresh_gpx: bt_refresh_gpx
    property alias lb_camera_time: lb_camera_time
    property alias offsetSpinBox: offsetSpinBox
    property alias list_gpxfiles: list_gpxfiles

    iconZone: "qrc:/Images/icon-world3.png"
    txtZone: qsTr("GPX Tracking")

    /// Les différents items de la zone, disposés en colonne.
    ColumnLayout {
        // width: parent.width
        anchors.fill: parent
        spacing: 4

        RowLayout {
            Layout.leftMargin: 20
            /// Bouton pour raffraichir la ListView
            Button {
                id: bt_refresh_gpx
                enabled: window.currentFolderUrl != ""
                text: qsTr("Refresh")
                icon.source: "qrc:/Images/bt-refresh.png"
                Layout.leftMargin: 20
                Layout.topMargin: 16
            }
            /// Bouton pour déselectionner la track
            Button {
                id: bt_clear_gpx
                enabled: window.currentFolderUrl != ""
                text: qsTr("Unselect")
                icon.source: "qrc:/Images/bt-clear.png"
                Layout.leftMargin: 20
                Layout.topMargin: 16
            }
        }
        /// ListView des fichiers GPX
        ListViewGPXfiles {
            id: list_gpxfiles
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Layout.topMargin: 8
        }

        /// Nombre de photos associées (matchées)
        RowLayout {
            Layout.leftMargin: 20
            Layout.topMargin: 12
            Label {
                text: qsTr("Photo count:")
            }
            Label {
                text: _gpxModel.matchCount
                font.bold: true
            }
        }

        /// Heure de début de la track GPS sélectionnée
        RowLayout {
            Layout.leftMargin: 20
            Layout.topMargin: 12
            Label {
                text: qsTr("GPX start:")
            }
            Label {
                text: list_gpxfiles.currentStartTime || "--:--:--"
                font.bold: true
            }
            Label {
                leftPadding: 40
                text: qsTr("Camera time:")
            }
            Label {
                id: lb_camera_time
                font.bold: true
                color: Style.chipGeoColor
            }
        }

        /// Décalage caméra p/r GPS (-12h .. +12h)
        RowLayout {
            Layout.leftMargin: 20
            Layout.bottomMargin: 20
            Label {
                text: qsTr("Offset:")
            }
            SpinBox {
                id: offsetSpinBox
                from: -12
                to: 12
                value: 0
                stepSize: 1
            }
        }

        // Heure caméra théorique
        //RowLayout {
        //    Layout.leftMargin: 20
        //}
    }
}
