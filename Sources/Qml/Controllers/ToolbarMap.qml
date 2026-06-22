import QtQuick
import QtCore
import QtPositioning
import "../Vues"

/** **********************************************************************************************************
 * @brief Controlleur pour la barre de boutons située au dessus de la carte (onglet MAP).
 * ***********************************************************************************************************/
ToolbarMapForm {

    Settings {
        id: aiSettings
        property string vlmApiKey: ""
    }

    /// Clic sur "Find" : on demande les coords GPS du site mentionné dans le TextField.
    bt_find.onClicked: {
        window.requestCoords(txt_find.text, false);
    }
    /// Clic sur "Enter" : on demande les coords GPS du site mentionné dans le TextField.
    txt_find.onAccepted: {
        window.requestCoords(txt_find.text, false);
    }

    /// Clic sur "Next" : on demande les coords GPS suivantes.
    bt_next.onClicked: {
        window.showNextCoords();
    }

    /// Clic sur "Ask AI" : interroge Llama-3.2-Vision (Groq) pour identifier le lieu sur la photo.
    bt_ask_ai.onClicked: {
        bt_ask_ai.enabled = false;
        var photoUrl = _photoModel.getUrl(tabbedPage.currentPhoto.row);
        _landmarkWrapper.identify(photoUrl.toString(), aiSettings.vlmApiKey);
    }

    /// Réponses de LandmarkWrapper
    Connections {
        target: _landmarkWrapper

        function onLandmarkFound(name, lat, lon) {
            // On ajoute une suggestion de type Location
            _suggestionModel.append(name, "location", "geo", -2);
            // On stocke les coordonnées GPS trouvées par l'IA dans SavedPosition
            _photoModel.setSavedPositionCoords(lat, lon);
            // On recentre la carte
            mapView.center = QtPositioning.coordinate(lat, lon);
            bt_ask_ai.enabled = true;
        }

        function onLocationUnknown() {
            _suggestionModel.append(qsTr("Unidentified"), "location", "geo", -2);
            bt_ask_ai.enabled = true;
        }

        function onNetworkError(message) {
            console.error("LandmarkWrapper: " + message);
            bt_ask_ai.enabled = true;
        }
    }

    /// Clic sur "Save Position" : On enregistre la position de l'image dans la Saved Position.
    bt_save_pos.onClicked: {
        window.savePosition();
    }

    /// Clic sur "Remove Saved Pos": Efface la Saved Position.
    bt_remove_savedpos.onClicked: {
        window.clearSavedPosition();
    }

    /// Clic sur "Apply Saved Position": On applique les coordonnées du marker "SavedPosition" aux photos affichées.
    bt_apply_savedpos.onClicked: {
        window.applySavedPositionToCoords();
        // On recentre la carte, si la nouvelle Position est en dehors de la vue actuelle
        var pos = QtPositioning.coordinate(tabbedPage.currentPhoto.latitude, tabbedPage.currentPhoto.longitude);
        if (!mapView.visibleRegion.contains(pos))
            mapView.center = pos;
    }

    /// Quand on relache le slider, il recherche les photos qui pourraient être dans le cercle.
    slider_radius.onPressedChanged: {
        if (!slider_radius.pressed) {
            _photoModel.findInCirclePhotos(slider_radius.value);
            _photoModel.suggestFromSelection();
        }
    }

    // Clic sur "Revert": On recharge les infos à partir de la photo du disque.
    bt_revert.onClicked: {
        window.fetchSingleExifMetadata(tabbedPage.currentPhoto.row);
    }

    bt_remove_savedpos.enabled: _photoModel.savedPositionExists
    bt_apply_savedpos.enabled: _photoModel.savedPositionExists

    /// Gestion du grisage des boutons
    Connections {
        target: tabbedPage
        function onCurrentPhotoChanged() {
            bt_save_pos.enabled = tabbedPage.currentPhoto.hasGPS;
            bt_revert.enabled = tabbedPage.currentPhoto.toBeSaved;
            slider_radius.enabled = tabbedPage.currentPhoto.hasGPS;
            bt_ask_ai.enabled = (tabbedPage.currentPhoto.row >= 0) && (aiSettings.vlmApikey !== "");
            if (!tabbedPage.currentPhoto.hasGPS) {
                if (tabbedPage.currentPhoto.city)
                    txt_find.text = tabbedPage.currentPhoto.city;
                else if (_suggestionModel.folderLocation)
                    txt_find.text = _suggestionModel.folderLocation;
            }
        }
    }
}
