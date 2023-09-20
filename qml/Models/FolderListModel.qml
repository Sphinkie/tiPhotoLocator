import QtQuick 2.15
import Qt.labs.folderlistmodel 2.15


// ----------------------------------------------------------------
// Modèles de donnees
// ----------------------------------------------------------------

// ----------------------------------------------------------------
// Ce modele contient la liste des fichiers du dossier
// ----------------------------------------------------------------
FolderListModel {

    sortCaseSensitive: false
    showDirs: false
    nameFilters: ["*.jpg", "*.JPG", "*.jpeg", "*.JPEG"]
    folder: ""

    onFolderChanged: {
        console.log("folder changed");}

    onCountChanged: {
        // En cas de changement, on met à jour la PhotoListModel
        console.log("FolderListModel count changed:"+count);
        // TODO : mettre un timer pour copier fileName et fileUrl dans la PhotoListModel
    }

}
