import QtQuick
import QtPositioning
import "../Vues"


/** **********************************************************************************************************
 * @brief Controlleur pour la barre de boutons au dessus de la carte.
 * *********************************************************************************************************** */
ToolBarMapForm {

    property bool savedPositionExists: false

    /// Clic sur "Save Position" : On enregistre la position de l'image dans la Saved Position.
    bt_save_pos.onClicked: {
        window.savePosition(mapTab.photoLatitude, mapTab.photoLongitude)
        savedPositionExists = true
    }

    /// Clic sur "Remove Saved Pos": Efface la Saved Position.
    bt_remove_savedpos.onClicked: {
        window.clearSavedPosition()
        savedPositionExists = false
    }

    bt_apply_savedpos.onClicked: {
        // On applique les coordonnées du marker "SavedPosition" aux photos affichées
        window.applySavedPositionToCoords()
        // On recentre la carte, si la nouvelle Position est en dehors de la vue actuelle
        var pos = QtPositioning.coordinate(tabbedPage.selectedData.latitude,
                                           tabbedPage.selectedData.longitude)
        if (!mapView.visibleRegion.contains(pos))
            mapView.center = pos
    }

    /// Quand on relache le slider,
    // FIXME il recherche les photos qui pourraient être dans le cercle.
    slider_radius.onPressedChanged: {
        if (!slider_radius.pressed)
            _photoModel.findInCirclePhotos(slider_radius.value)
    }

    bt_revert.onClicked: {
        // On recharge les infos à partir de la photo du disque
        window.fetchSingleExifMetadata(tabbedPage.selectedData.row)
    }

    bt_clear_coords.onClicked: {
        // On efface les coordonnées GPS des photos affichées
        window.setSelectedPhotoCoords(0, 0)
        // On efface la copie locale QML de ces coordonnées...
        mapTab.photoLatitude = 0
        mapTab.photoLongitude = 0
    }

    bt_remove_savedpos.enabled: savedPositionExists
    bt_apply_savedpos.enabled: savedPositionExists

    /// Gestion du grisage des boutons
    Connections {
        target: tabbedPage
        function onSelectedDataChanged() {
            // console.debug("onSelectedDataChanged->ToolBarMap");
            // console.debug("hasGPS" + tabbedPage.selectedData.hasGPS);
            bt_clear_coords.enabled = tabbedPage.selectedData.hasGPS
            bt_save_pos.enabled = tabbedPage.selectedData.hasGPS
            bt_revert.enabled = tabbedPage.selectedData.toBeSaved
            slider_radius.enabled = tabbedPage.selectedData.hasGPS
        }
    }
}
