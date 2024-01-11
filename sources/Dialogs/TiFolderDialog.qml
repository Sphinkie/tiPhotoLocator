import QtQuick
import QtCore
import Qt.labs.platform
import "../Components"

/*! *****************************************************************
 *  Fenetre de dialogue pour selectionner le dossier.
 *  Example folder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
 * ***************************************************************** */
FolderDialog {
    id: folderDialog
    currentFolder: "file:///C:"
    // URL du dossier de départ
    folder: ""
    property int recentNumber: 0
    property var recentList: []

    onAccepted: {
        // On passe par ici quand on clique sur OK, donc, même si on reselectionne le même folder
        folderListModel.folder = folder;
        // console.log("Accepted");
        // Ajout du folder dans les Settings "Recent Folders"
        addRecentFolder(folder);
        // On attend que le FolderModel soit à jour (timer 1 seconde),
        // puis on met à jour la liste du PhotoModel (fileName et fileUrl)
        folderTimer.start();
    }

    FolderLoadTimer {id: folderTimer}

    function addRecentFolder(foldername)
    {
        // On ajoute le dossier ouvert à la liste des "recents" dans les Settings.
        var folderList = settings.recentList;
        var posFolder = settings.recentNumber;
        // On mémorise un maximum de 7 recent folders
        if (posFolder>6) posFolder=0;
        folderList[posFolder] = foldername;
        settings.recentList = folderList;
        settings.recentNumber = posFolder + 1;
    }

    // --------------------------------------
    // On mémorise le chemin dans les Settings
    // --------------------------------------
    Settings {
        id: settings
        category: "recentFolders"
        property alias recentList: folderDialog.recentList
        property alias recentNumber: folderDialog.recentNumber
    }


}
