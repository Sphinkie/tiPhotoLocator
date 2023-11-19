import QtQuick
import "../Vues"

// Controlleur
ZoneSuggestionForm {


    bt_getinfo.onClicked: {
        // on recupere des infos à partir des coords GPS
        window.requestReverseGeocode(mapTab.photoLatitude, mapTab.photoLongitude);
    }



    // Gestion du grisage des boutons
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
