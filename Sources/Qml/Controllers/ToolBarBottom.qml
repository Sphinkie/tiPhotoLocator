import QtQuick
import "../Vues"
import "../Javascript/Networking.js" as Netwk


/** **********************************************************************************************************
 * @brief Controlleur pour la barre de boutons du bas.
 * *********************************************************************************************************** */
ToolBarBottomForm {

    bt_dump1.onClicked: {
        _photoModel.dumpData()
    }

    bt_dump2.onClicked: {
        _suggestionModel.dumpData()
        Netwk.requestAPI()
    }

    // Check status mémorisé dans les Settings
    cb_backups.onCheckedChanged: {

    }

    bt_save.onClicked: {
        // On lance l'écriture des données EXIF et IPTC (envoi signal)
        window.saveMetadata()
        shouldSave = false
    }

    bt_quit.onClicked: {
        Qt.quit()
    }
}
