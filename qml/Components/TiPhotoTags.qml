import QtQuick 2.0
import QtQuick.Layouts 1.15
import "../Controllers"


GridLayout {
    columns: 3
    //columnSpacing: 20
    //rowSpacing: 20

    Zone {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
        txtZone: qsTr("Appareil photo")
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
        Layout.margins: 10
        txtZone: qsTr("Photo")
    }

    ZoneUserdata {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
        //Layout.rightMargin: 30
        //Layout.topMargin: 20
    }


    Zone {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.columnSpan: 3
        Layout.margins: 10
        color: "lightblue"
        iconZone: "qrc:/Images/suggestion.png"
        txtZone: qsTr("Suggestions")
    }

    Zone {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.columnSpan: 3
        Layout.margins: 10
        color: "lightgrey"
        iconZone: "qrc:/Images/trashcan.png"
        txtZone: qsTr("Corbeille")
    }
}

