import QtQuick 2.4
import QtQuick.Layouts 1.3
import "../Components"

Item {
    width: 400
    height: 600
    property alias chipName: chipName
    property alias chipSize: chipSize
    property alias chipDate: chipDate
    property alias chipTime: chipTime
    property alias chipMake: chipMake
    property alias chipCamModel: chipCamModel

    Zone {

        ColumnLayout {
            Text {
                Layout.topMargin: 20
                Layout.leftMargin: 10
                text: qsTr("Photographie:")
            }
            Chips {
                id: chipName
                Layout.leftMargin: 20
                //content: tabbedPage.selectedData.filename
                editable: false
                deletable: false
            }
            Chips {
                id: chipSize
                Layout.leftMargin: 20
                //content: imageWidth + " x " + imageHeight
                editable: false
                deletable: false
            }
            Chips {
                id: chipDate
                Layout.leftMargin: 20
                //content: "DD/MM/YYYY"
                editable: false
                deletable: false
            }
            Chips {
                id: chipTime
                Layout.leftMargin: 20
                //content: "HH:MM"
                editable: false
                deletable: false
            }
            Text {
                Layout.leftMargin: 10
                text: qsTr("Appareil photo:")
            }
            Chips {
                id: chipMake
                Layout.leftMargin: 20
                //content: "make"
                editable: false
                deletable: false
            }
            Chips {
                id: chipCamModel
                Layout.leftMargin: 20
                //content: camModel
                editable: false
                deletable: false
            }
        }
    }
}
