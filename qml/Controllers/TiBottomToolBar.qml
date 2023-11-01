import QtQuick
import "../Vues"

// Controlleur pour la barre de boutons du bas
TiBottomToolBarForm {

    // true en mode DEBUG
    // bt_dump.visible: reglages2.value("debugModeEnabled", false)
    bt_dump.visible: true


    bt_dump.onClicked: {
        _photoListModel.dumpData()
    }

    cb_backups.onCheckedChanged:  {
        // On stocke l'état de la checkbox dans la propriété generateBackup de exifWrapper
        _exifWrapper.generateBackup = cb_backups.checked
    }

    bt_save.onClicked: {
        // On lance l'écriture des données EXIF (envoi signal)
        window.saveExifMetadata()
    }

    bt_quit.onClicked: {
        Qt.quit()
    }

}
