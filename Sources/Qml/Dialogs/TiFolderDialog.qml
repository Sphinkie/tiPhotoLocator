import QtQuick
import QtCore
import Qt.labs.platform
import "../Components"


/** ***************************************************************************************
 * @brief QML: Fenêtre de dialogue pour selectionner le dossier.
 * Folder example: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
 * ****************************************************************************************/
FolderDialog {
    id: folderDialog
    currentFolder: "file:///C:"
    // URL du dossier de départ
    folder: ""
    property int recentNumber: 0
    property var recentList: []


    /** ***********************************************************************************
     * Clic sur OK: on charge la liste des fichiers du répertoire sélectionné.
     * ************************************************************************************/
    onAccepted: {
        // On passe par ici quand on clique sur OK, donc, même si on reselectionne le même folder
        folderListModel.folder = folder
        // console.log("Accepted");
        // Ajout du folder dans les Settings "Recent Folders"
        addRecentFolder(folder)
        // On attend que le FolderModel soit à jour (timer 1 seconde),
        // puis on met à jour la liste du PhotoModel (fileName et fileUrl)
        folderTimer.start()
    }


    /** ***********************************************************************************
     * Timer de ralentissement (le C++ est plus rapide que le QML)
     * ************************************************************************************/
    FolderLoadTimer {
        id: folderTimer
    }


    /** ***********************************************************************************
     * Ajout du dossier ouvert à la liste des "recents" dans les Settings.
     * ************************************************************************************/
    function addRecentFolder(foldername) {
        var folderList = settings.recentList
        var posFolder = settings.recentNumber
        // On mémorise un maximum de 7 recent folders
        if (posFolder > 6)
            posFolder = 0
        folderList[posFolder] = foldername
        settings.recentList = folderList
        settings.recentNumber = posFolder + 1
    }


    /** ***********************************************************************************
     * Mémorisation du chemin dans les Settings.
     * ************************************************************************************/
    Settings {
        id: settings
        category: "recentFolders"
        property alias recentList: folderDialog.recentList
        property alias recentNumber: folderDialog.recentNumber
    }
}
