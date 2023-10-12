import QtQuick 2.0
import QtQuick.Layouts 1.15


ColumnLayout {
    spacing: 8

    Text {
        Layout.alignment: Qt.AlignLeft
        text: "Tags:"
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "navajowhite"
    }

    Pastille {
        id: p1
    }

    Text {
        Layout.alignment: Qt.AlignLeft
        text: "Trashcan:"
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "navajowhite"
    }

}

