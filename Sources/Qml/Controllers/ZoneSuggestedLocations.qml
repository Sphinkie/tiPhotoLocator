import QtQuick
import "../Vues"


/** **********************************************************************************************************
 * @brief Controlleur pour la Zone située dans l'onglet CARTE.
 * Cette zone contient les suggestions géographiques du SuggestionRepeater (city, country, etc)
 * ainsi que le bouton "Chercher".
 * ***********************************************************************************************************/
ZoneSuggestedLocationsForm {


    /** ******************************************************************************************************
     * Clic sur bouton "Chercher".
     * A noter que la recherche est aussi lancée automatiquement par un Timer de TiPhotoListview.
     * *******************************************************************************************************/
    bt_getinfo.onClicked: {
        // On envoie une request pour récupérer des infos à partir des coords GPS.
        window.requestReverseGeocode(mapTab.photoLatitude,
                                     mapTab.photoLongitude)
    }

    /// Le bouton est grisé si la photo n'a pas de coordonnées GPS.
    Connections {
        target: tabbedPage
        function onSelectedDataChanged() {
            bt_getinfo.enabled = tabbedPage.selectedData.hasGPS
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

