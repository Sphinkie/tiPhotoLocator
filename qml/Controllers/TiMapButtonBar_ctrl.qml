import QtQuick 2.0
import QtQuick.Window 2.15
// import "../Components"

//Window{
    TiMapButtonBar {

        bt_save_pos.onClicked: {
            if (buttonOn){
                window.savePosition(mapTab.new_latitude, mapTab.new_longitude);
                buttonOn = false
            }
            else {
                // TODO Attention au cas où on a vidé le modèle: il faut remettre ce bouton à ON
                window.clearSavedPosition();
                buttonOn = true
            }
        }

        bt_apply_pos.onClicked: {
            // On applique les coordonnées du marker "SavedPosition" aux photos affichées
            window.applySavedPositionToCoords();
        }

        bt_clear_pos.onClicked: {
            // TODO
        }
    }
//}
