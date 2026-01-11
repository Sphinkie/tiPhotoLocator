import QtQuick
import QtQuick.Dialogs


/** **********************************************************************************************************
 * @brief QML: Ouvre un popup puis relit les Exif des photos si OK.
 * *********************************************************************************************************** */
MessageDialog {
    title: "Rescan folder"
    readonly property string t1: qsTr("Attention: les informations des images du répertoire vont être rechargées.<br/>")
    readonly property string t2: qsTr("Tous les changements non enregistrés vont être perdus.")
    text: t1 + t2
    informativeText: qsTr("Voulez-vous continuer?")
    buttons: MessageDialog.Ok | MessageDialog.Cancel
    Component.onCompleted: visible = false

    /// Si Ok, on relit les Exif des photos
    onAccepted: {
        console.log("Manual Rescan")
        _photoModel.clear()
        _suggestionModel.clear()
        // On ajoute une à une les photos du dossier dans le modèle
        for (var i = 0; i < folderListModel.count; i++) {
            window.append(folderListModel.get(i, "fileName"),
                          folderListModel.get(i, "fileUrl").toString())
        }
        window.fetchExifMetadata() // envoi signal
    }
}
