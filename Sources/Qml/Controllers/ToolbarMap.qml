import QtQuick
import QtPositioning
import "../Vues"


/** **********************************************************************************************************
 * @brief Controlleur pour la barre de boutons située au dessus de la carte.
 * ***********************************************************************************************************/
ToolbarMapForm {

    /// Clic sur "Save Position" : On enregistre la position de l'image dans la Saved Position.
    bt_save_pos.onClicked: {
        window.savePosition()
    }

    /// Clic sur "Remove Saved Pos": Efface la Saved Position.
    bt_remove_savedpos.onClicked: {
        window.clearSavedPosition()
    }

    /// Clic sur "Apply Saved Position": On applique les coordonnées du marker "SavedPosition" aux photos affichées.
    bt_apply_savedpos.onClicked: {
        window.applySavedPositionToCoords()
        // On recentre la carte, si la nouvelle Position est en dehors de la vue actuelle
        var pos = QtPositioning.coordinate(tabbedPage.currentPhoto.latitude,
                                           tabbedPage.currentPhoto.longitude)
        if (!mapView.visibleRegion.contains(pos))
            mapView.center = pos
    }

    /// Quand on relache le slider, il recherche les photos qui pourraient être dans le cercle.
    slider_radius.onPressedChanged: {
        if (!slider_radius.pressed) {
            _photoModel.findInCirclePhotos(slider_radius.value)
            _photoModel.suggestFromSelection()
        }
    }

    // Clic sur "Revert": On recharge les infos à partir de la photo du disque.
    bt_revert.onClicked: {
        window.fetchSingleExifMetadata(tabbedPage.currentPhoto.row)
    }

    bt_remove_savedpos.enabled: _photoModel.savedPositionExists
    bt_apply_savedpos.enabled: _photoModel.savedPositionExists

    /// Gestion du grisage des boutons
    Connections {
        target: tabbedPage
        function onCurrentPhotoChanged() {
            // console.debug("onSelectedDataChanged->ToolBarMap");
            // console.debug("hasGPS" + tabbedPage.currentPhoto.hasGPS);
            bt_save_pos.enabled = tabbedPage.currentPhoto.hasGPS
            bt_revert.enabled = tabbedPage.currentPhoto.toBeSaved
            slider_radius.enabled = tabbedPage.currentPhoto.hasGPS
        }
    }
}
