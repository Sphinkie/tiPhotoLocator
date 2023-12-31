import QtQuick
import "../Vues"
import "../Javascript/Networking.js" as Netwk

/*! *****************************************************************
 *  Controlleur pour la barre de boutons du bas.
 * ***************************************************************** */
ToolBarBottomForm {

    bt_dump1.onClicked: {
        _photoModel.dumpData();
      //  _cameraSet.append("TZ80")         // Ajouté pour les tests d'API de Lisa
    }

    bt_dump2.onClicked: {
        _suggestionModel.dumpData();
        Netwk.requestAPI();
    }

    cb_backups.onCheckedChanged:  {
        // Statut mémorisé dans les Settings
    }

    bt_save.onClicked: {
        // On lance l'écriture des données EXIF et IPTC (envoi signal)
        window.saveMetadata();
        shouldSave = false;
    }

    bt_quit.onClicked: {
        Qt.quit();
    }

}
