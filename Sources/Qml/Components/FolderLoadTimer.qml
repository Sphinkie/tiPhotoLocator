import QtQuick


/** ***************************************************************************************
 * @brief QML: Lecture d'un dossier de photos.
 * On attend 1 seconde, puis on met à jour le PhotoModel.
 * ****************************************************************************************/
Timer {
    interval: 1000
    running: false
    repeat: false
    onTriggered: {
        // On vide le photoModel
        _photoModel.clear()
        // On ajoute les photos du dossier dans le modèle
        for (var i = 0; i < folderListModel.count; i++) {
            window.append(folderListModel.get(i, "fileName"),
                          folderListModel.get(i, "fileUrl").toString())
        }
        // Puis on lance la récupération des données EXIF (envoi signal)
        Timer: {
            interval: 1000 // 1 sec
            running: true // starts the timer
            repeat: false
            onTriggered: window.fetchExifMetadata()
        }
        // On reinitialise le cercle
        mapTab.mapTools.slider_radius.value = 0
    }
}
