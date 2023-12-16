import QtQuick
import "../Vues"

/*!
 * Controlleur pour la Zone située dans l'onglet CARTE, et contenant les suggestions géographiques du SuggestionRepeater
 * (city, country, etc) ainsi que le bouton "Chercher".
 */
ZoneSuggestionForm {


    bt_getinfo.onClicked: {
        // on envoir une request pour récupérer des infos à partir des coords GPS
        window.requestReverseGeocode(mapTab.photoLatitude, mapTab.photoLongitude);
    }



    // Gestion du grisage du bouton
    Connections{
        target: tabbedPage
        function onSelectedDataChanged()
        {
            bt_getinfo.enabled = tabbedPage.selectedData.hasGPS;
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
