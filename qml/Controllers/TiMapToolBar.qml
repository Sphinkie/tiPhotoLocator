import QtQuick 2.0
import "../Vues"

TiMapToolBarForm {

    bt_save_pos.onClicked: {
        // Après un clic sur Save Position,
        // On enregistre la position de l'image dans la Saved Position
        window.savePosition(mapTab.photoLatitude, mapTab.photoLongitude);
        bt_apply_pos.enabled = true;
        bt_remove_pos.enabled = true;
    }

    bt_remove_pos.onClicked: {
        // On efface la Saved Position
        window.clearSavedPosition();
        bt_apply_pos.enabled = false;   // on ne peut plus l'appliquer
        bt_remove_pos.enabled = false;  // on ne peut plus la re-effacer
    }

    bt_apply_pos.onClicked: {
        // On applique les coordonnées du marker "SavedPosition" aux photos affichées
        window.applySavedPositionToCoords();
        // bt_apply_pos.enabled = false;    // on ne peut plus la re-appliquer une deuxième fois
        bt_clear_coords.enabled = true;
        slider_radius.enabled = true;
    }

    bt_get_info.onClicked: {
        // DEV: on recupere des infos à partir des coords GPS
        window.requestReverseGeocode(mapTab.photoLatitude, mapTab.photoLongitude);
    }

    bt_clear_coords.onClicked: {
        // On efface les coordonnées GPS des photos affichées
        window.setSelectedItemCoords(0,0);
        // On grise certains boutons
        bt_save_pos.enabled = false;
        bt_clear_coords.enabled = false;
        slider_radius.enabled = false;
        slider_radius.value = 0;
        // On efface la copie locale QML de ces coordonnées...
        mapTab.photoLatitude = 0;
        mapTab.photoLongitude = 0;
    }


}
