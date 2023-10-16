import QtQuick 2.0
import QtQuick.Layouts 1.15


GridLayout {
    columns: 2
    columnSpacing: 20
    rowSpacing: 20
   /*
    required property string filename
    required property int imageWidth
    required property int imageHeight
    required property string camModel
    required property string make
    required property string dateTimeOriginal
    required property string imageUrl
    */

    Zone {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Text {
            text: "Appareil photo"
        }
        Chips{
            Layout.leftMargin: 20
            content: make
            editable: false
            deletable: false
        }
        Chips{
            Layout.leftMargin: 20
            content: camModel
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
        Text {
            text: "Suggestions"
        }
    }

    Zone {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.columnSpan: 2
        color: "lightgrey"
        Text {
            text: "Corbeille"
        }
    }
}

