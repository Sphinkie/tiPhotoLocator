import QtQuick 2.15
import Qt.labs.folderlistmodel 2.15


// ----------------------------------------------------------------
// Ce modele contient la liste des fichiers du dossier
// ----------------------------------------------------------------
FolderListModel {

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
