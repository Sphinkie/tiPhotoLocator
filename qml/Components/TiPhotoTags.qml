import QtQuick 2.0
import QtQuick.Layouts 1.15


GridLayout {
    columns: 2
    columnSpacing: 20
    rowSpacing: 20

    Zone {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Text {
            text: "Appareil photo"
        }
        Chips{
            Layout.leftMargin: 20
            content: tabbedPage.selectedData.make
            editable: false
            deletable: false
        }
        Chips{
            Layout.leftMargin: 20
            content: tabbedPage.selectedData.camModel
            editable: false
            deletable: false
        }
    }
    Zone {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Text {
            text: "Photo"
        }
    }


    Zone {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.columnSpan: 2
        color: "lightblue"
        iconZone: "qrc:/Images/suggestion.png"
        txtZone: qsTr("Suggestions")
        Text {
            text: "Suggestions"
        }
    }

    Zone {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.columnSpan: 2
        color: "lightgrey"
        iconZone: "qrc:/Images/trashcan.png"
        txtZone: qsTr("Corbeille")
    }
}

