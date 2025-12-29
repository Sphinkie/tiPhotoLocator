import QtQuick

Timer {
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
