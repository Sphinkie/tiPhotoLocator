import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12
import "../Components"

RowLayout {
    property alias bt_reload: bt_reload
    property alias bt_rescan: bt_rescan
    property alias folderPath: folderPath

    TiButton {
        id: bt_reload
        icon.source: "qrc:/Images/reload.png"
        text: qsTr("Reload")
        ToolTip.text: qsTr("Recharge la liste des photos du répertoire")
        ToolTip.visible: hovered
        ToolTip.delay: 500
    }
    TiButton {
        Layout.fillWidth: false
        id: bt_rescan
        icon.source: "qrc:/Images/rescan.png"
        text: qsTr("Rescan")
        ToolTip.text: qsTr("Rescanne les tags EXIF des photos du répertoire")
        ToolTip.visible: hovered
        ToolTip.delay: 500
    }
    Text {
        text: qsTr("Répertoire:")
    }
    Text {
        id: folderPath
        font.pixelSize: 16
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

