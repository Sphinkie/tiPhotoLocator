import QtQuick
import QtCore
import QtPositioning
import "../Vues"

/** **********************************************************************************************************
 * @brief Controlleur pour la barre de boutons située au dessus de la carte (onglet GPS LOGGER).
 * ***********************************************************************************************************/
ToolbarGpxForm {

    /// Clic sur "Next" : passe à la photo suivante de la track
    bt_next.onClicked: {
        // TODO
    }

    /// Clic sur "Apply Track Point": On applique les coordonnées des track points àtoutes les photos de la track.
    bt_apply_point.onClicked: {
        // TODO
    }

    /// Clic sur "Apply All Track Points": On applique les coordonnées des track points à toutes les photos de la track.
    bt_apply_all.onClicked: {
        /*
        window.applySavedPositionToCoords();
        // On recentre la carte, si la nouvelle Position est en dehors de la vue actuelle
        var pos = QtPositioning.coordinate(tabbedPage.currentPhoto.latitude, tabbedPage.currentPhoto.longitude);
        if (!mapView.visibleRegion.contains(pos))
            mapView.center = pos;
            */
    }

    // Clic sur "Revert": On recharge les infos à partir de la photo du disque.
    bt_revert.onClicked: {
        window.fetchSingleExifMetadata(tabbedPage.currentPhoto.row);
    }

    bt_apply_point.enabled: true  // TODO
    bt_apply_all.enabled: true // TODO

    /// Gestion du grisage des boutons
    Connections {
        target: tabbedPage
        function onCurrentPhotoChanged() {
            bt_revert.enabled = tabbedPage.currentPhoto.toBeSaved;
        }
    }
}
