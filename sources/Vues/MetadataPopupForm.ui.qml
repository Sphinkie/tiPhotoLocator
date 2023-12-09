
/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import "../Components"

Popup {
    id: metadataForm
    width: 520
    height: 720
    property alias buttonClose: buttonClose
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Rectangle {
        color: TiStyle.tertiaryBackgroundColor
        border.color: TiStyle.tertiaryForegroundColor
        border.width: 2
    }
    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        color: "#80f3f9ec"
    }
    anchors.centerIn: Overlay.overlay

//    Rectangle {
  //      id: rectangle
    //    width: metadataForm.width
      //  height: metadataForm.height
        //color: TiStyle.surfaceContainerColor

        Text {
            id: desc1
            clip: true
            readonly property string t1: qsTr("...")
            readonly property string t2: qsTr("")
            text: t1 + t2
            anchors.top: parent.top
            anchors.topMargin: 0
        }

        Grid {
            id: exifTable
            anchors.top: desc1.bottom
            width: metadataForm.width - 24
            height: 460
            rightPadding: 12
            leftPadding: 12
            topPadding: 5
            spacing: 1
            rows: 10
            columns: 4

            Text {
                id: text01
                text: qsTr("..")
                font.pixelSize: 12
            }

            Text {
                id: text02
                text: qsTr("..")
                font.pixelSize: 12
            }

            Text {
                id: text03
                text: qsTr("..")
                font.pixelSize: 12
            }
            Text {
                id: text04
                text: qsTr("..")
                font.pixelSize: 12
            }
            Text {
                id: text10
                text: qsTr("..")
                font.pixelSize: 12
            }
            Text {
                id: text11
                text: qsTr("..")
                font.pixelSize: 12
            }
            Text {
                id: text12
                text: qsTr("..")
                font.pixelSize: 12
            }
            Text {
                id: text13
                text: qsTr("..")
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
                text: qsTr("...")
            }
            Text {
                y: 60
                clip: true
                text: qsTr("...")
            }
        }
//    }

    TiButton {
        id: buttonClose
        text: qsTr("Fermer")
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 38
        color: TiStyle.tertiaryForegroundColor
    }
}
