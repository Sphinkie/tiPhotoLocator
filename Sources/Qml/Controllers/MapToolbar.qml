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
        var pos = QtPositioning.coordinate(tabbedPage.selectedData.latitude,
                                           tabbedPage.selectedData.longitude)
        if (!mapView.visibleRegion.contains(pos))
            mapView.center = pos
    }

    /// Quand on relache le slider, il recherche les photos qui pourraient être dans le cercle.
    slider_radius.onPressedChanged: {
        if (!slider_radius.pressed)
            _photoModel.findInCirclePhotos(slider_radius.value)
    }

    // Clic sur "Revert": On recharge les infos à partir de la photo du disque.
    bt_revert.onClicked: {
        window.fetchSingleExifMetadata(tabbedPage.selectedData.row)
    }

    bt_remove_savedpos.enabled: _photoModel.savedPositionExists
    bt_apply_savedpos.enabled: _photoModel.savedPositionExists

    /// Gestion du grisage des boutons
    Connections {
        target: tabbedPage
        function onSelectedDataChanged() {
            // console.debug("onSelectedDataChanged->ToolBarMap");
            // console.debug("hasGPS" + tabbedPage.selectedData.hasGPS);
            bt_save_pos.enabled = tabbedPage.selectedData.hasGPS
            bt_revert.enabled = tabbedPage.selectedData.toBeSaved
            slider_radius.enabled = tabbedPage.selectedData.hasGPS
        }
    }
}
