
/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import "../Components"

Item {
    id: metadataWindow
    width: 1024
    height: 768
    anchors.centerIn: Overlay.overlay

    property alias closeButton: button

    Rectangle {
        id: rectangle
        width: metadataWindow.width
        height: metadataWindow.height
        color: TiStyle.surfaceContainerColor

        Text {
            id: desc1
            clip: true
            readonly property string t1: qsTr("Les tags EXIF contiennent principalement des informations techniques (Modèle d'appareil, objectif...)")
            readonly property string t2: qsTr("Les données EXIF ne sont pas destinées à être modifiées.")
            text: t1 + t2
            anchors.top: parent.top
            anchors.topMargin: 0
        }

        Grid {
            id: exifTable
            anchors.top: desc1.bottom
            width: rectangle.border.width - 24
            height: 460
            rightPadding: 12
            leftPadding: 12
            topPadding: 5
            spacing: 1
            rows: 10
            columns: 4

            Text {
                id: text01
                text: qsTr("Text")
                font.pixelSize: 12
            }

            Text {
                id: text02
                text: qsTr("Text")
                font.pixelSize: 12
            }

            Text {
                id: text03
                text: qsTr("Text")
                font.pixelSize: 12
            }
            Text {
                id: text04
                text: qsTr("Text")
                font.pixelSize: 12
            }
            Text {
                id: text10
                text: qsTr("Text")
                font.pixelSize: 12
            }
            Text {
                id: text11
                text: qsTr("Text")
                font.pixelSize: 12
            }
            Text {
                id: text12
                text: qsTr("Text")
                font.pixelSize: 12
            }
            Text {
                id: text13
                text: qsTr("Text")
                font.pixelSize: 12
            }
        }

        Item {
            id: groupBox4
            anchors.top: exifTable.bottom
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.topMargin: 20
            width: parent.width - 20
            clip: true
            height: 80
            Text {
                y: 40
                clip: true
                text: qsTr("Elle sont définies (normalement) au moment de la prise de vue.")
            }
            Text {
                y: 60
                clip: true
                text: qsTr("Les tags IPTC contiennent principalement des informations éditoriales (Description de l'image...)    ")
            }
        }
    }

    TiButton {
        id: button
        text: qsTr("Fermer")
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 38
    }
}
