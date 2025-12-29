import QtQuick
import QtQuick.Layouts
import "../Components"

Item {
    width: 400
    property alias cameraZone: cameraZone
    property alias chipModel: chipModel
    property alias chipMaker: chipMaker
    property alias chipSoftware: chipSoftware
    property alias chipAperture: chipAperture
    property alias chipSpeed: chipSpeed
    property alias camThumb: camThumb

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
                id: chipSoftware
                editable: false
                deletable: false
            }
            Chips {
                id: chipAperture
                editable: false
                deletable: false
            }
            Chips {
                id: chipSpeed
                editable: false
                deletable: false
            }
            Item{
                width: 128
                height: 128
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 10
                Image {
                    id: camThumb
                    height: 128
                    source: "../Cameras/default.png"
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
    }
}
