import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12
import "TiUtilities.js" as Utilities


RowLayout{
    TiButton {
        id: reloadButton
        icon.source: "qrc:/Images/reload.png"
        text: qsTr("Reload")
        onClicked: {
            console.log("Manual Reload");
            _photoListModel.clear();
            // On ajoute les photos du dossier dans le modèle
            for (var i = 0; i < folderListModel.count; i++)  {
                window.append(folderListModel.get(i,"fileName"), folderListModel.get(i,"fileUrl").toString() )
            }
        }
    }
    TiButton {
        Layout.fillWidth: false
        id: rescanButton
        icon.source: "qrc:/Images/rescan.png"
        text: qsTr("Rescan")
        onClicked: rescanWarning.open()
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
