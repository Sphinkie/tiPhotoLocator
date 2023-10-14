import QtQuick 2.0
import "../Components"

TiMapButtonBar {

    bt_save_pos.onClicked: {
        // On enregistre la position de l'image
        window.savePosition(mapTab.new_latitude, mapTab.new_longitude);
    }

    bt_remove_pos.onClicked: {
        // On efface la Saved Position
        window.clearSavedPosition();
    }

    bt_apply_pos.onClicked: {
        // On applique les coordonnées du marker "SavedPosition" aux photos affichées
        window.applySavedPositionToCoords();
    }

    bt_clear_pos.onClicked: {
        // On efface les coordonnées GPS des photos affichées
        window.setSelectedItemCoords(0,0);
    }

}
