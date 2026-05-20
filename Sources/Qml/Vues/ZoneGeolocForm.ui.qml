import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"


/** **********************************************************************************************************
 * @brief Cette zone affiche les Chips de catégorie "geo" associés à la photo.
 * ***********************************************************************************************************/
Zone {
    id: geolocZone
    property alias chipLat: chipLat
    property alias chipLong: chipLong
    property alias chipCity: chipCity
    property alias chipCountry: chipCountry
    property alias chipLocation: chipLocation
    property alias bt_clear_coords: bt_clear_coords

    iconZone: "qrc:/Images/icon-world.png"
    txtZone: qsTr("Geolocation")

    ColumnLayout {

        Button {
            id: bt_clear_coords
            enabled: false
            text: qsTr("Clear GPS Coords")
            icon.source: "qrc:/Images/bt-suppr.png"
            Layout.leftMargin: 20
            Layout.topMargin: 16
            ToolTip.text: qsTr("Clear GPS photo coordinates (if some privacy is needed)")
            ToolTip.visible: hovered
            ToolTip.delay: 500
        }

        Chips {
            id: chipLat
            editable: false
            deletable: true
            target: "latitude"
        }
        Chips {
            id: chipLong
            editable: false
            deletable: true
            target: "longitude"
        }
        Chips {
            id: chipCountry
            editable: false
            deletable: true
            target: "country"
        }
        Chips {
            id: chipCity
            editable: false
            deletable: true
            target: "city"
            swappable: true
        }
        Chips {
            id: chipLocation
            editable: false
            deletable: true
            target: "location"
            swappable: true
        }
    }
}
