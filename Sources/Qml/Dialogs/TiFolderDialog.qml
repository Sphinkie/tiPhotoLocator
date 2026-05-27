import QtQuick
import QtCore
import Qt.labs.platform
import "../Components"
import "../Javascript/TiUtilities.js" as Utilities


/** ***************************************************************************************
 * @brief QML: Fenêtre de dialogue pour sélectionner le dossier.
 * Folder example: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
 * - Lecture des la RecentList des Settings (depuis QSettings → mémoire) :
 *   une seule fois, à la création du composant, c'est-à-dire au démarrage de l'application.
 *   Ainsi, la liste des dossiers récents est correcte à chaque relance.
 * - Écriture dans les Settings: (depuis mémoire → QSettings) :
 *   à chaque changement de la propriété aliasée, cad avec `folderDialog.recentList = folderList`
 *   QSettings est mis à jour immédiatement sur le disque.
 * ****************************************************************************************/
FolderDialog {
    id: folderDialog
    // currentFolder : dossier affiché à l'ouverture du dialogue (point de départ de la navigation).
    // folder        : dossier effectivement sélectionné après clic OK (résultat).
    currentFolder: "file:///C:"
    folder: ""
    property var recentList: []


    /** ***********************************************************************************
     * Clic sur OK: on charge la liste des fichiers du répertoire sélectionné.
     * ************************************************************************************/
    onAccepted: {
        // On passe par ici quand on clique sur OK, donc, même si on reselectionne le même folder
        // Normalisation pour les chemins UNC (file://serveur/... → file:////serveur/...)
        let normalizedFolder = Utilities.normalizeUrl(folder.toString())
        folderListModel.folder = normalizedFolder
        window.currentFolderUrl = normalizedFolder
        console.log("Accepted folder URL:", folder.toString())
        console.log("Normalized folder URL:", normalizedFolder)
        // Ajout du folder dans les Settings "Recent Folders"
        addRecentFolder(normalizedFolder)
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
        // .slice() crée une copie (nouvelle référence/ shallow copy)) : indispensable pour que QML
        // détecte le changement lors du write-back et déclenche le signal de mise à jour.
        // Note, sans argument, le contenu de la liste returné par slice est identique.
        var folderList = folderDialog.recentList ? folderDialog.recentList.slice() : []
        // Eviter les doublons.
        if (folderList.includes(foldername))
            return
        // On mémorise un maximum de 7 recent folders (0 ..6).
        if (folderList.length > 6)
            folderList.pop()
        folderList.unshift(foldername)
        // Write-back obligatoire : en QML, la lecture d'une property var retourne une copie.
        folderDialog.recentList = folderList
    }


    /** ***********************************************************************************
     * Ouvre le dialogue en positionnant d'abord sur le dossier parent du dossier courant.
     * Si aucun dossier n'est ouvert, on revient sur la racine C:.
     * ************************************************************************************/
    function openInParentFolder() {
        var s = window.currentFolderUrl.toString()
        if (s !== "" && s !== "file:") {
            if (s.endsWith("/")) s = s.slice(0, -1)          // supprimer le slash final
            var idx = s.lastIndexOf("/")
            currentFolder = idx > 0 ? s.substring(0, idx) : "file:///C:"
        } else {
            currentFolder = "file:///C:"
        }
        open()
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
     * Mémorisation dans les Settings des chemins des RecentFolders.
     * Ils sont affichés par la MenuBar.
     * ************************************************************************************/
    Settings {
        id: settings
        category: "recentFolders"
        property alias recentList: folderDialog.recentList
    }
}
