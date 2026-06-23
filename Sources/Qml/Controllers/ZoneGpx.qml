import QtQuick
import "../Vues"

/** **********************************************************************************************************
 * @brief Cette zone affiche les fichiers GPX associés au dossier de photos (onglet GPS LOGGER).
 * ***********************************************************************************************************/
ZoneGpxForm {

    /// Retourne l'heure caméra théorique en appliquant le décalage horaire au temps GPX.
    function cameraTime(gpxTime, offsetH) {
        if (!gpxTime)
            return "--:--:--";
        var parts = gpxTime.split(":");
        var h = ((parseInt(parts[0]) + offsetH) % 24 + 24) % 24;
        var m = parts[1];
        var s = parts[2];
        return (h < 10 ? "0" + h : "" + h) + ":" + m + ":" + s;
    }

    /// Bouton pour raffraichir la ListView
    bt_refresh_gpx.onClicked: _gpxModel.refresh(window.currentFolderUrl)

    /// Bouton vider la sélection : déselectionne la track (et donc toutes les photos).
    bt_clear_gpx.onClicked: list_gpxfiles.currentIndex = -1

    /// Heure caméra théorique
    lb_camera_time.text: cameraTime(list_gpxfiles.currentStartTime, offsetSpinBox.value)

    /// Décalage caméra p/r GPS (-12h .. +12h)
    offsetSpinBox {
        textFromValue: function (value, locale) {
            return (value >= 0 ? "+" : "") + value + " h";
        }
        valueFromText: function (text, locale) {
            return parseInt(text);
        }
        onValueChanged: {
            mapTab.mapTools.slider_radius.value = 0;
            _gpxModel.matchPhotos(_photoModel, offsetSpinBox.value);
            _photoModel.selectOnTrack();
        }
    }

    /// Re-match automatique quand une nouvelle track est chargée.
    Connections {
        target: _gpxModel
        function onCurrentTrackPointsChanged() {
            mapTab.mapTools.slider_radius.value = 0;
            _gpxModel.matchPhotos(_photoModel, offsetSpinBox.value);
            _photoModel.selectOnTrack();
        }
    }

    /// Si la photo cliquée n'est pas sur la track, on désélectionne le fichier GPX.
    /// Cela déclenche selectTrack(-1) → resetOnTrack + selectOnTrack → tout se remet à zéro.
    Connections {
        target: _photoModel
        function onTrackDeactivated() {
            list_gpxfiles.currentIndex = -1;
        }
    }
}
