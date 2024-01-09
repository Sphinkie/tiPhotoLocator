import QtQuick
import QtCore
import Qt.labs.platform


/*! *****************************************************************
 *  Fenetre de dialogue pour selectionner le dossier.
 *  Example folder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
 * ***************************************************************** */
FolderDialog {
    currentFolder: "file:///C:"
    // URL du dossier de départ
    folder: ""
    property int lastFolder: -1
    onAccepted: {
        // On passe par ici quand on clique sur OK, donc, même si on reselectionne le même folder
        folderListModel.folder = folder;
        // console.log("Accepted");
        // ajout du folder dans les Settings "Récents"
        addRecentFolder (folderListModel.folder);
        // Il faut attendre que le FolderModel soit à jour (timer 1 seconde),
        // puis on met à jour la liste du PhotoModel (fileName et fileUrl )
        folderTimer.start();
    }

    Timer {
        id: folderTimer
        interval: 1000
        running: false;
        repeat: false
        onTriggered: {
            // On met à jour le photoModel
            _photoModel.clear();
            // On ajoute les photos du dossier dans le modèle
            for (var i = 0; i < folderListModel.count; i++ ) {                
                window.append(folderListModel.get(i,"fileName"), folderListModel.get(i,"fileUrl").toString() )
            }
            // Puis on lance la récupération des données EXIF (envoi signal)
            Timer: {
                interval: 1000;   // 1 sec
                running: true;    // starts the timer
                repeat: false;
                onTriggered: window.fetchExifMetadata();
            }
        }
    }

    function addRecentFolder(string foldername)
{
   var folderList = settings.recents;
   int posFolder = settings.lastFolder + 1; 
   console.log(foldername);
   folderList[posFolder] = foldername;
   settings.recents = folderList;
   settings.lastFolder = posFolder
   // TODO : gérer un maximum de 5
}

    // --------------------------------------
    // On mémorise le chemin dans les Settings
    // --------------------------------------
    Settings {
        id: settings
        category: recentFolders
        property alias recents: ""
        property alias lastFolder: lastFolder
    }


}
