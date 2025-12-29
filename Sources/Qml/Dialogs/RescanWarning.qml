import QtQuick
import QtQuick.Dialogs

MessageDialog {
    title: "Rescan folder"
    readonly property string t1: qsTr("Attention: les informations des images du répertoire vont être rechargées.<br/>")
    readonly property string t2: qsTr("Tous les changements non enregistrés vont être perdus.")
    text: t1 + t2
    informativeText: qsTr("Voulez-vous continuer?")
    buttons: MessageDialog.Ok | MessageDialog.Cancel
    Component.onCompleted: visible=false
    onAccepted: {
        console.log("Manual Rescan");
        window.fetchExifMetadata();       // envoi signal
    }
}
