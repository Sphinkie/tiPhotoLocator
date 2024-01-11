import QtQuick
import Qt.labs.folderlistmodel


/*! *****************************************************************
 * Ce modele contient la liste des fichiers du dossier
 * ****************************************************************** */
FolderListModel {

    sortCaseSensitive: false
    showDirs: false
    nameFilters: ["*.jpg", "*.JPG", "*.jpeg", "*.JPEG"]
    folder: ""

}
