import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"
import ".."

/** **********************************************************************************************************
 * @brief Cette zone affiche les fichiers GPX associés au dossier de photos (onglet GPS LOGGER).
 * ***********************************************************************************************************/
Zone {
    property alias bt_refresh_gpx: bt_refresh_gpx
    // TODO :   cette zone n'a pas de controlleur

    iconZone: "qrc:/Images/icon-world3.png"
    txtZone: qsTr("GPX Tracking")

    /// Retourne l'heure caméra théorique en appliquant le décalage horaire au temps GPX.
    function cameraTime(gpxTime, offsetH) {
        if (!gpxTime)
            return "--:--:--";
        var parts = gpxTime.split(":");
        var h = ((parseInt(parts[0]) + offsetH) % 24 + 24) % 24;
        var m = parts[1];
        var s = parts[2];
        return (h < 10 ? "0" + h : "" + h) + ":" + m + ":" + s;
    }

    /// Les différents items de la zone, disposés en colonne.
    ColumnLayout {
        width: parent.width
        spacing: 4

        // Bouton pour raffraichier la ListViiew
        Button {
            id: bt_refresh_gpx
            enabled: window.currentFolderUrl != ""
            text: qsTr("Refresh")
            icon.source: "qrc:/Images/bt-refresh.png"
            Layout.leftMargin: 20
            Layout.topMargin: 16
            onClicked: _gpxModel.refresh(window.currentFolderUrl)
            ToolTip {
                visible: parent.hovered
                text: qsTr("Refresh GPX file list")
                delay: 500
                y: -height - 4
            }
        }

        /// ListView des fichiers GPX
        ListViewGPXfiles {
            id: listGpx
            Layout.fillWidth: true
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
                text: listGpx.currentStartTime || "--:--:--"
                font.bold: true
            }
        }

        /// Décalage caméra p/r GPS (-12h .. +12h)
        RowLayout {
            Layout.leftMargin: 20
            Label {
                text: qsTr("Offset:")
            }
            SpinBox {
                id: offsetSpinBox
                from: -12
                to: 12
                value: 0
                stepSize: 1
                textFromValue: function (value, locale) {
                    return (value >= 0 ? "+" : "") + value + " h";
                }
                valueFromText: function (text, locale) {
                    return parseInt(text);
                }
                onValueChanged: _gpxModel.matchPhotos(_photoModel, value)
            }
        }

        /// Re-match automatique quand une nouvelle track est chargée.
        Connections {
            target: _gpxModel
            function onCurrentTrackPointsChanged() {
                _gpxModel.matchPhotos(_photoModel, offsetSpinBox.value);
            }
        }

        /// Heure caméra théorique
        RowLayout {
            Layout.leftMargin: 20
            Label {
                text: qsTr("Camera time:")
            }
            Label {
                text: cameraTime(listGpx.currentStartTime, offsetSpinBox.value)
                font.bold: true
                color: Style.chipGeoColor
            }
        }
    }
}
