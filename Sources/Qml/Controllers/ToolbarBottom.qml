import QtQuick
import QtCore
import "../Vues"
import "../Dialogs"
import "../Javascript/Networking.js" as Netwk

/** **********************************************************************************************************
 * @brief Controlleur pour la barre de boutons du bas.
 * ***********************************************************************************************************/
ToolbarBottomForm {

    bt_dump1.onClicked: {
        _photoModel.dumpData();
    }

    bt_dump2.onClicked: {
        _suggestionModel.dumpData();
        Netwk.requestAPI();
    }

    // Check status mémorisé dans les Settings
    cb_backups.onCheckedChanged: {}

    bt_save.onClicked: {
        // On lance l'écriture des données EXIF et IPTC (envoi signal)
        window.saveMetadata();
    }

    QuitWarningDialog {
        id: quitWarning
    }

    bt_quit.onClicked: {
        if (shouldSave)
            quitWarning.open();
        else
            Qt.quit();
    }

    /** *******************************************************************
     * Connexions : Slots pour les signaux émis par PhotoModel
     * ********************************************************************/
    Connections {
        target: _photoModel

        /// Si l'enregistrement des données Exif est en cours, on enlève le highlight du bouton Enregistrer.
        function onDataSaved() {
            // console.log("onDataSaved")
            shouldSave = false;
        }
        /// Si le modèle a été vidé, on enlève le highlight du bouton Enregistrer.
        function onDataCleared() {
            // console.log("onDataCleared")
            shouldSave = false;
        }

        /** *******************************************************************
         * Dès qu'un item change, le signal dataChanged est émis par setData. on highlighte le bouton Enregistrer.
         * @param topLeft: unused
         * @param bottomRight: unused
         * @param roles: Liste des roles modifiés, exemple ["country, "toBeSaved"].
         * ********************************************************************/
        function onDataChanged(topLeft, bottomRight, roles) {
            // console.log("dataChanged", roles.length, " roles:")
            // S'il y a toBeSaved parmi les roles, et qu'il n'est pas seul on positionne le flag.
            // Si ce role est seul, on suppose que c'est pour le faire retomber à false
            // (vu qu'on n'a pas la valeur ici).
            roles.forEach(function (role) {
                // console.log("-", _photoModel.getRoleName(role))
                if ((_photoModel.getRoleName(role) === "toBeSaved") && (roles.length > 1))
                    // alors on highlighte le bouton Enregistrer.
                    shouldSave = true;
            });
        }
    }
}
