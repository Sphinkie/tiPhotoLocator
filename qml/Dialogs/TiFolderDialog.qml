import QtQuick 2.15
import Qt.labs.platform 1.1


// ----------------------------------------------------------------
// Fenetre de dialogue pour selectionner le dossier
// example folder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
// ----------------------------------------------------------------
FolderDialog {
    // id: folderDialog
    currentFolder: "file:///C:"
    // URL du dossier de départ
    folder: ""
    onAccepted: {
        // On passe par ici qund on clique sur OK, donc, même si on reselectionne le même folder
        folderListModel.folder = folder;
        console.log("Accepted");
        console.log(folderListModel.folder);
    }
}
