import QtQuick
import Qt.labs.platform


/*! *****************************************************************
 *  Fenetre de dialogue pour selectionner le dossier.
 *  Example folder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
 * ***************************************************************** */
FolderDialog {
    currentFolder: "file:///C:"
    // URL du dossier de départ
    folder: ""
    onAccepted: {
        // On passe par ici quand on clique sur OK, donc, même si on reselectionne le même folder
        folderListModel.folder = folder;
        console.log("Accepted");
        console.log(folderListModel.folder);
        // Il faut attendre que le FolderModel soit à jour (timer 1 seconde),
        // puis on met à jour la PhotoListModel (fileName et fileUrl )
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
}
