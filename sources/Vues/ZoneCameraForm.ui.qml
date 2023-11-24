import QtQuick
import QtQuick.Layouts
import "../Components"



Item {
    width: 400
    property alias cameraZone: cameraZone
    property alias chipModel: chipModel
    property alias chipMaker: chipMaker
    property alias chipFocale: chipFocale

    Zone {
        id: cameraZone
        anchors.fill: parent
        iconZone: "qrc:/Images/camera.png"
        txtZone: qsTr("Tags générés par l'appareil<br>photo au moment de la prise de vue.")

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
        }
    }

}


