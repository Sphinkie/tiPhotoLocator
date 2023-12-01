import QtQuick
import QtPositioning
import "../Vues"

ToolBarMapForm {

    property bool savedPositionExists: false

    bt_save_pos.onClicked: {
        // Après un clic sur Save Position,
        // On enregistre la position de l'image dans la Saved Position
        window.savePosition(mapTab.photoLatitude, mapTab.photoLongitude);
        savedPositionExists = true;
    }

    bt_remove_savedpos.onClicked: {
        // On efface la Saved Position
        window.clearSavedPosition();
        savedPositionExists = false;
    }

    bt_apply_savedpos.onClicked: {
        // On applique les coordonnées du marker "SavedPosition" aux photos affichées
        window.applySavedPositionToCoords();
        // On raffraichit l'affichage des tags
        tabbedPage.refreshSelectedData();
        // On recentre la carte, si la nouvelle Position est en dehors de la vue actuelle
        var pos = QtPositioning.coordinate(tabbedPage.selectedData.latitude, tabbedPage.selectedData.longitude);
        if (! mapView.visibleRegion.contains(pos))
            mapView.center = pos;
    }

    bt_revert.onClicked: {
        // On recharge les infos à partir de la photo du disque
        window.fetchSingleExifMetadata(tabbedPage.selectedData.row);
        // On raffraichit l'affichage des tags (coords et geotags)
        tabbedPage.refreshSelectedData();
    }

    bt_clear_coords.onClicked: {
        // On efface les coordonnées GPS des photos affichées
        window.setSelectedItemCoords(0,0);
        tabbedPage.refreshSelectedData();
        // On efface la copie locale QML de ces coordonnées...
        mapTab.photoLatitude = 0;
        mapTab.photoLongitude = 0;
    }

    bt_remove_savedpos.enabled: savedPositionExists;
    bt_apply_savedpos.enabled: savedPositionExists;

    // Gestion du grisage des boutons
    Connections{
        target: tabbedPage
        function onSelectedDataChanged()
        {
            console.log("onSelectedDataChanged->ToolBarMap");
            console.log(tabbedPage.selectedData.hasGPS);
            bt_clear_coords.enabled = tabbedPage.selectedData.hasGPS;
            bt_save_pos.enabled = tabbedPage.selectedData.hasGPS;
            bt_revert.enabled = tabbedPage.selectedData.toBeSaved;
            slider_radius.enabled = tabbedPage.selectedData.hasGPS;
        }
    }


}
