import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"
import ".."

/** **********************************************************************************************************
 * @brief Cette zone affiche les fichiers GPX associés au dossier de photos.
 * ***********************************************************************************************************/
Zone {
    property alias bt_clear_coords: bt_refresh_gpx

    iconZone: "qrc:/Images/icon-world3.png"
    txtZone: qsTr("GPX Tracking")

    /// Retourne l'heure caméra théorique en appliquant le décalage horaire au temps GPX.
    function cameraTime(gpxTime, offsetH) {
        if (!gpxTime)
            return "--:--";
        var parts = gpxTime.split(":");
        var h = ((parseInt(parts[0]) + offsetH) % 24 + 24) % 24;
        var m = parts[1];
        var s = parts[2];
        return (h < 10 ? "0" + h : "" + h) + ":" + m + ":" + s;
    }

    ColumnLayout {
        spacing: 4

        Button {
            id: bt_refresh_gpx
            enabled: true
            text: qsTr("Refresh")
            icon.source: "qrc:/Images/bt-refresh.png"
            Layout.leftMargin: 20
            Layout.topMargin: 16
            ToolTip {
                visible: parent.hovered
                text: qsTr("Refresh GPX file list")
                delay: 500
                y: -height - 4
            }
        }

        ListViewGPXfiles {
            id: listGpx
            Layout.fillWidth: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Layout.topMargin: 8
        }

        /// Heure de début du track GPX sélectionné
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

        /// Décalage caméra / GPS (-12h .. +12h)
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
