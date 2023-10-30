import QtQuick 2.0
import QtQuick.Layouts 1.15
import "../Controllers"


GridLayout {
    columns: 3

    ZoneCamera {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
    }

    Zone {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
        iconZone: "qrc:/Images/camera.png"
        txtZone: qsTr("Photo")
    }

    ZoneUserdata {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
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

