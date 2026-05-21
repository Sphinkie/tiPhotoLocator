import QtQuick


/** ***************************************************************************************
 * @brief QML: Lecture d'un dossier de photos.
 * On attend 1 seconde, puis on met à jour la liste des photos dans PhotoModel.
 * ****************************************************************************************/
Timer {
    interval: 1000 ///< Durée du timer = 1 seconde.
    running: false ///< Etat initial : stopped.
    repeat: false ///< Déclenchement unique

    /// A l'expiration du timer
    onTriggered: {
        // ----------------------------------------------------
        // On vide les PhotoModel et SuggestionModel.
        // ----------------------------------------------------
        _photoModel.clear()
        _suggestionModel.clear()
        console.log("TimerLoadFolder: folder =",
                    folderListModel.folder.toString())
        console.log("TimerLoadFolder: count =", folderListModel.count)

        // ----------------------------------------------------
        // On ajoute quelques suggestions globales.
        // ----------------------------------------------------
        // On extrait date/lieu/commentaires depuis le nom du dossier
        _suggestionModel.setDefaultDateFromFolder(
                    folderListModel.folder.toString())

        // ----------------------------------------------------
        // On ajoute les photos du dossier dans le modèle
        // ----------------------------------------------------
        // On distingue le cas des chemins locaux (D:\...) et des chemins UNC (\\nas\...)
        // L'astuce est que FolderListModel ne supporte pas les chemins UNC et count() renvoie alors zéro...
        var photoCount = 0
        if (folderListModel.count > 0) {
            // Chemin local : FolderListModel fonctionne normalement
            for (var i = 0; i < folderListModel.count; i++) {
                // On ajoute les photos du dossier dans le modèle
                window.append(folderListModel.get(i, "fileName"),
                              folderListModel.get(i, "fileUrl").toString())
            }
            photoCount = folderListModel.count
        } else {
            // Fallback pour les chemins UNC réseau (FolderListModel ne les supporte pas)
            // On appelle une méthode dédiée: scanFolder()
            photoCount = _photoModel.scanFolder(
                        folderListModel.folder.toString())
        }
        // ----------------------------------------------------
        // On reinitialise le cercle
        // ----------------------------------------------------
        mapTab.mapTools.slider_radius.value = 0

        // ----------------------------------------------------
        // On lance la récupération des données EXIF (delay 1 sec))
        // ----------------------------------------------------
        /// Timer utilisé pour les Exifs
        Timer: {
            interval: 1000 ///< Durée du timer = 1 seconde.
            running: true ///< Démarrage dès la création
            repeat: false ///< Déclenchement unique
            /// A l'expiration du timer
            onTriggered: {
                if (photoCount > 0)
                    window.fetchExifMetadata()
            }
        }
    }
}
