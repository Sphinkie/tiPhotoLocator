import QtQuick
import QtQuick.Layouts
import "../Components"

Item {
    width: 400
    property alias cameraZone: cameraZone
    property alias chipModel: chipModel
    property alias chipMaker: chipMaker
    property alias chipFocale: chipFocale
    property alias chipSpeed: chipSpeed

    Zone {
        id: cameraZone
        anchors.fill: parent
        iconZone: "qrc:/Images/icon-camera.png"
        txtZone: qsTr("Tags générés par l'appareil photo<br>au moment de la prise de vue.")

        ColumnLayout {
            Chips {
                id: chipModel
                editable: false
                deletable: false
            }
            Chips {
                id: chipMaker
                editable: false
                deletable: false
            }
            Chips {
                id: chipFocale
                editable: false
                deletable: false
            }
            Chips {
                id: chipSpeed
                editable: false
                deletable: false
            }
        }
    }
}
