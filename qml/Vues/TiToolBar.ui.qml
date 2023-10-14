import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12
import "../Javascript/TiUtilities.js" as Utilities
import "../Components"

RowLayout {
    property alias bt_reload: bt_reload
    property alias bt_rescan: bt_rescan

    TiButton {
        id: bt_reload
        icon.source: "qrc:/Images/reload.png"
        text: qsTr("Reload")
    }
    TiButton {
        Layout.fillWidth: false
        id: bt_rescan
        icon.source: "qrc:/Images/rescan.png"
        text: qsTr("Rescan")
    }
    Text {
        text: qsTr("Répertoire:")
    }
    Text {
        id: folderPath
        text: Utilities.toStandardPath(folderDialog.folder)
        font.pixelSize: 16
    }
}
