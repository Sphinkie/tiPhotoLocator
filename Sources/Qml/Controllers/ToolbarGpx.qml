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
        // TODO - passe à la photo suivante de la track
    }

    /// Clic sur "Apply One Single Track Point": On applique les coordonnées du track point à la photo courante.
    bt_apply_point.onClicked: {
        _photoModel.applyTrackPointCoords();
    }

    /// Clic sur "Apply All Track Points": On applique les coordonnées des track points à toutes les photos de la track.
    bt_apply_all.onClicked: {
        /*
        window.setSelectedItemsCoords();
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

    bt_next.enabled: _gpxModel.matchCount > 1
    bt_apply_all.enabled: _gpxModel.matchCount > 0
    bt_apply_point.enabled: _gpxModel.matchCount > 0

    /// Gestion du grisage des boutons
    Connections {
        target: tabbedPage
        function onCurrentPhotoChanged() {
            bt_revert.enabled = tabbedPage.currentPhoto.toBeSaved;
        }
    }
}
