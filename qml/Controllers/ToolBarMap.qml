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
        // on recentre la carte
        // TODO A faire si la Saved Position est en dehors de la vue actuelle
        mapView.center = QtPositioning.coordinate(tabbedPage.selectedData.latitude, tabbedPage.selectedData.longitude)
        // Dégrisage des boutons
        // bt_revert.enabled = true;
        // slider_radius.enabled = true;
        //bt_clear_coords.enabled = true;
        // zoneSuggestionGeo.bt_getinfo.enabled = true;
    }


    bt_revert.onClicked: {
        // On recharge les infos à partir de la photo du disque
        window.fetchSingleExifMetadata(tabbedPage.selectedData.row)
        // On raffraichit l'affichage des tags (coords et geotags)
        tabbedPage.refreshSelectedData();
    }

    bt_clear_coords.onClicked: {
        // On efface les coordonnées GPS des photos affichées
        window.setSelectedItemCoords(0,0);
        tabbedPage.refreshSelectedData();
        // On grise certains boutons
        // bt_save_pos.enabled = false;
        // bt_clear_coords.enabled = false;
        // slider_radius.enabled = false;
        // slider_radius.value = 0;
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
            console.log("ToolBarMap -> onSelectedDataChanged");
            console.log(tabbedPage.selectedData.hasGPS);
            bt_clear_coords.enabled = tabbedPage.selectedData.hasGPS;
            bt_save_pos.enabled = tabbedPage.selectedData.hasGPS;
            bt_revert.enabled = tabbedPage.selectedData.toBeSaved;
            slider_radius.enabled = tabbedPage.selectedData.hasGPS;
        }
    }


}
