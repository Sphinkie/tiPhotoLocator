import QtQuick 2.4
import QtQuick.Layouts 1.3
import "../Components"

Item {
    width: 400
    property alias chipModel: chipModel
    property alias chipMaker: chipMaker
    property alias chipFocale: chipFocale
    property alias cameraZone: cameraZone

    Zone {
        id: cameraZone
        anchors.fill: parent
        iconZone: "qrc:/Images/camera.png"
        txtZone: qsTr("Appareil Photo")

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


