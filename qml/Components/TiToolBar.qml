import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12
import "TiUtilities.js" as Utilities

/**
  * @see https://doc.qt.io/qt-5/qtquickcontrols2-customize.html#customizing-button
  */
RowLayout{
    TiButton {
        //Layout.fillWidth: false
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
    ShadowButton {
        Layout.fillWidth: false
        id: rescanButton
        display: AbstractButton.TextBesideIcon
        icon.source: "qrc:/Images/rescan.png"
        text: qsTr("Rescan")
        onClicked: {
            console.log("Manual Rescan");
            window.scanFolder(folderListModel.folder)        // envoi signal
        }
    }
    Text {
        text: qsTr("Répertoire:")
    }
    Text {
        id: folderPath
        text: Utilities.toStandardPath(folderDialog.folder)  // TODO Enlever les 8 premiers caractères .substring(0,8)
        font.pixelSize: 16
    }
}
