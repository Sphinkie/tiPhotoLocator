import QtQuick
import QtQuick.Dialogs


/** **********************************************************************************************************
 * @brief QML: Ouvre un popup puis relit les Exif des photos si OK.
 * *********************************************************************************************************** */
MessageDialog {
    title: "Rescan folder"
    readonly property string t1: qsTr("Warning: the metadata of all images in the folder will be reloaded.<br/>")
    readonly property string t2: qsTr("All unsaved changes will be lost.")
    text: t1 + t2
    informativeText: qsTr("Do you want to continue?")
    buttons: MessageDialog.Ok | MessageDialog.Cancel
    Component.onCompleted: visible = false

    /// Si Ok, on relit les Exif des photos
    onAccepted: {
        console.log("Manual Rescan")
        _photoModel.clear()
        _suggestionModel.clear()
        // --------------------------------------------------------
        // On ajoute une à une les photos du dossier dans le modèle
        // --------------------------------------------------------
        // Cas d'un chemin local:
        if (folderListModel.count > 0) {
            for (var i = 0; i < folderListModel.count; i++) {
                window.append(folderListModel.get(i, "fileName"),
                              folderListModel.get(i, "fileUrl").toString())
            }
        } else // Cas d'un chemin UNC:
        {
            _photoModel.scanFolder(folderListModel.folder.toString())
        }
        window.fetchExifMetadata() // envoi signal
    }
}
