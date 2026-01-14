import QtQuick
import "../Vues"


/** **********************************************************************************************************
 * @brief Controlleur pour la Zone située dans l'onglet CARTE.
 * Cette zone contient les suggestions géographiques du SuggestionRepeater (city, country, etc)
 * ainsi que le bouton "Chercher".
 * ***********************************************************************************************************/
ZoneSuggestedLocationsForm {


    /** ******************************************************************************************************
     * Clic sur bouton "Chercher" envoie une request pour récupérer des infos à partir des coords GPS.
     * A noter que la recherche est aussi lancée automatiquement par un Timer de PhotoListview.
     * *******************************************************************************************************/
    bt_getinfo.onClicked: {
        window.requestReverseGeocode(_photoModel.currentItemCoords.latitude,
                                     _photoModel.currentItemCoords.longitude)
    }


    /** ******************************************************************************************************
     * Le bouton est grisé si la photo n'a pas de coordonnées GPS.
     * *******************************************************************************************************/
    Connections {
        target: tabbedPage
        function onCurrentPhotoChanged() {
            bt_getinfo.enabled = tabbedPage.currentPhoto.hasGPS
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

