import QtQuick
import "../Vues"

// Controlleur pour la barre de boutons du bas
ToolBarBottomForm {

    // true en mode DEBUG
    bt_dump.visible: true


    bt_dump.onClicked: {
        _photoListModel.dumpData()
    }

    cb_backups.onCheckedChanged:  {
        // Statut mémorisé dans les Settings
    }

    bt_save.onClicked: {
        // On lance l'écriture des données EXIF et IPTC (envoi signal)
        window.saveMetadata()
    }

    bt_quit.onClicked: {
        Qt.quit()
    }

}
