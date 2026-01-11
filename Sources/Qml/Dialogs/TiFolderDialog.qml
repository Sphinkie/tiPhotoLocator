import QtQuick
import QtCore
import Qt.labs.platform
import "../Components"


/** ***************************************************************************************
 * @brief QML: Fenêtre de dialogue pour sélectionner le dossier.
 * Folder example: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
 * ****************************************************************************************/
FolderDialog {
    id: folderDialog
    currentFolder: "file:///C:"
    // URL du dossier de départ
    folder: ""
    property var recentList: []


    /** ***********************************************************************************
     * Clic sur OK: on charge la liste des fichiers du répertoire sélectionné.
     * ************************************************************************************/
    onAccepted: {
        // On passe par ici quand on clique sur OK, donc, même si on reselectionne le même folder
        folderListModel.folder = folder
        console.log("Accepted")
        // Ajout du folder dans les Settings "Recent Folders"
        addRecentFolder(folder)
        // On attend que le FolderModel soit à jour (timer 1 seconde),
        // puis on met à jour la liste du PhotoModel (fileName et fileUrl)
        folderTimer.start()
    }


    /** ***********************************************************************************
     * Ce timer attend une seconde, puis charge les infos du dossier sélectionné.
     * ************************************************************************************/
    TimerLoadFolder {
        id: folderTimer
    }


    /** ***********************************************************************************
     * Ajout du dossier ouvert à la liste des "recents" dans les Settings.
     * On insère les items par le bas de la pile, car le Instanciator.model les affiche en sens inverse.
     * ************************************************************************************/
    function addRecentFolder(foldername) {
        var folderList = settings.recentList
        // console.log("Nb recents", folderList.length)
        // Eviter les doublons.
        if (folderList.includes(foldername))
            return
        // On mémorise un maximum de 7 recent folders (0 ..6).
        if (folderList.length > 6) {
            folderList.pop()
        }
        folderList.unshift(foldername)
    }


    /** ***********************************************************************************
     * On vide la liste des "recents" dans les Settings, ainsi que la propriété partagée.
     * ************************************************************************************/
    function clearRecentFolders() {
        console.log("clearRecentFolders")
        settings.recentList = []
        folderDialog.recentList = []
    }


    /** ***********************************************************************************
     * Mémorisation dans les Settings du nombre de RecentFolders, et de leurs chemins.
     * Ils sont affichés par la TiMenuBar.
     * ************************************************************************************/
    Settings {
        id: settings
        category: "recentFolders"
        property alias recentList: folderDialog.recentList
    }
}
