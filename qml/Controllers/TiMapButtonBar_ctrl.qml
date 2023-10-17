import QtQuick 2.0
import "../Vues"

TiMapButtonBar {

    bt_save_pos.onClicked: {
        // On enregistre la position de l'image dans la Saved Position
        window.savePosition(mapTab.photoLatitude, mapTab.photoLongitude);
        bt_apply_pos.visible = true;
        bt_remove_pos.visible = true;

    }

    bt_remove_pos.onClicked: {
        // On efface la Saved Position
        window.clearSavedPosition();
        bt_apply_pos.visible = false;
        bt_remove_pos.visible = false;
    }

    bt_apply_pos.onClicked: {
        // On applique les coordonnées du marker "SavedPosition" aux photos affichées
        window.applySavedPositionToCoords();
        bt_apply_pos.visible = false;
        bt_clear_coords.visible = true;
    }

    bt_clear_coords.onClicked: {
        // On efface les coordonnées GPS des photos affichées
        window.setSelectedItemCoords(0,0);
        bt_save_pos.visible = false;
        bt_clear_coords.visible = false;
    }

}
