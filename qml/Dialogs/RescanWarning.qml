import QtQuick 2.0
import QtQuick.Dialogs 1.3

MessageDialog {
    title: "Rescan folder"
    icon: StandardIcon.Warning
    readonly property string t1: qsTr("Attention: les informations des images du répertoire vont être rechargées.<br/>")
    readonly property string t2: qsTr("Tous les changements non enregistrés vont être perdus.")
    text: t1 + t2
    informativeText: qsTr("Voulez-vous continuer?")
    standardButtons: StandardButton.Ok | StandardButton.Cancel
    Component.onCompleted: visible=false
    onAccepted: {
        console.log("Manual Rescan");
        window.scanFile(folderListModel.folder)        // envoi signal
    }
}
