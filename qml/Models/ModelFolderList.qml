import QtQuick 2.15
import Qt.labs.folderlistmodel 2.15


// ----------------------------------------------------------------
// Modèles de donnees
// ----------------------------------------------------------------

// ----------------------------------------------------------------
// Ce modele contient la liste des fichiers du dossier
// ----------------------------------------------------------------
FolderListModel {     // TODO solve warning

    sortCaseSensitive: false
    showDirs: false
    nameFilters: ["*.jpg", "*.JPG", "*.jpeg", "*.JPEG"]
    folder: ""

    onFolderChanged: {
        console.log("folder changed");
    }
    onCountChanged: {
        console.log("FolderListModel count changed:"+count);
    }

}
