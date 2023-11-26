import QtQuick
import QtQuick.Layouts
import "../Controllers"


GridLayout {
    columns: 3

    ZoneCamera {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
    }

    ZonePicture {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
    }

    ZoneUserdata {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
    }


    ZoneSuggestedTags {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.columnSpan: 3
        Layout.margins: 10
        color: "lightblue"
        iconZone: "qrc:/Images/icon-suggestion.png"
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

