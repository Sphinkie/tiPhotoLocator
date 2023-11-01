import QtQuick
import QtQuick.Layouts
import "../Components"

Zone{
    id: geolocZone
//    property alias geolocZone: geolocZone
    property alias chipLat: chipLat
    property alias chipLong: chipLong
    property alias chipCity: chipCity
    property alias chipCountry: chipCountry

    iconZone: "qrc:/Images/world.png"
    txtZone: qsTr("Géolocalisation")

    ColumnLayout {

        Chips {
            id: chipLat
            editable: false
            deletable: true
            visible: (mapTab.photoLatitude != 0)
        }
        Chips {
            id: chipLong
            editable: false
            deletable: true
            visible: (mapTab.photoLongitude != 0)
        }
        Chips {
            id: chipCity
            editable: false
            deletable: true
        }
        Chips {
            id: chipCountry
            editable: false
            deletable: true
        }
    }
}
