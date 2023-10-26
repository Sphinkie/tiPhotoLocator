import QtQuick 2.4
import QtQuick.Layouts 1.3
import "../Components"

Item {
    width: 400
    height: 600
    property alias chipDate: chipDate
    property alias chipTime: chipTime

    Zone {

        ColumnLayout {
            Text {
                Layout.topMargin: 20
                Layout.leftMargin: 10
                text: qsTr("Photographie:")
            }
            Chips {
                Layout.leftMargin: 20
                content: filename
                editable: false
                deletable: false
            }
            Chips {
                Layout.leftMargin: 20
                content: imageWidth + " x " + imageHeight
                editable: false
                deletable: false
            }
            Chips {
                id: chipDate
                Layout.leftMargin: 20
                content: "DD/MM/YYYY"
                editable: false
                deletable: false
            }
            Chips {
                id: chipTime
                Layout.leftMargin: 20
                content: "HH:MM"
                editable: false
                deletable: false
            }
            Text {
                Layout.leftMargin: 10
                text: qsTr("Appareil photo:")
            }
            Chips {
                Layout.leftMargin: 20
                content: make
                editable: false
                deletable: false
            }
            Chips {
                Layout.leftMargin: 20
                content: camModel
                editable: false
                deletable: false
            }
        }
    }
}
