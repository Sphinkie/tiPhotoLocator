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
        // On vide les PhotoModel et SuggestionModel.
        _photoModel.clear()
        _suggestionModel.clear()
        // On ajoute les photos du dossier dans le modèle
        for (var i = 0; i < folderListModel.count; i++) {
            window.append(folderListModel.get(i, "fileName"),
                          folderListModel.get(i, "fileUrl").toString())
        }
        // On reinitialise le cercle
        mapTab.mapTools.slider_radius.value = 0
        // Puis on lance la récupération des données EXIF (delay 1 sec))

        /// Timer utilisé pour les Exifs
        Timer: {
            interval: 1000 ///< Durée du timer = 1 seconde.
            running: true ///< Démarrage dès la création
            repeat: false ///< Déclenchement unique
            /// A l'expiration du timer
            onTriggered: {
                if (folderListModel.count > 0)
                    window.fetchExifMetadata()
            }
        }
    }
}
