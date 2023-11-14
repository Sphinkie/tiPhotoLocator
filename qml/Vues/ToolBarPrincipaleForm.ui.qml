import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../Components"



Rectangle {
    color: TiStyle.surfaceContainerColor
    property alias bt_reload: bt_reload
    property alias bt_rescan: bt_rescan
    property alias folderPath: folderPath
    height: bt_reload.height+20
    implicitWidth: 800

    RowLayout {

        TiButton {
            id: bt_reload
            icon.source: "qrc:/Images/bt-reload.png"
            text: qsTr("Reload")
            ToolTip.text: qsTr("Recharge la liste des photos du répertoire")
            ToolTip.visible: hovered
            ToolTip.delay: 500
            // Positionnement à l'interieur du rectangle
            Layout.leftMargin: 20
            Layout.topMargin: 10
        }
        TiButton {
            id: bt_rescan
            icon.source: "qrc:/Images/bt-rescan.png"
            text: qsTr("Rescan")
            ToolTip.text: qsTr("Rescanne les tags EXIF des photos du répertoire")
            ToolTip.visible: hovered
            ToolTip.delay: 500
            // Positionnement à l'interieur du rectangle
            Layout.leftMargin: 20
            Layout.topMargin: 10
        }
        Text {
            text: qsTr("Répertoire:")
            font.pixelSize: 16
            color: TiStyle.secondaryTextColor
            // Positionnement à l'interieur du rectangle
            verticalAlignment: Text.AlignVCenter
            leftPadding: 20
        }
        Text {
            id: folderPath
            font.pixelSize: 16
            color: TiStyle.primaryTextColor
            font.family: "Courier"
            // Positionnement à l'interieur du rectangle
            verticalAlignment: Text.AlignVCenter
            leftPadding: 10
        }
    }
}



