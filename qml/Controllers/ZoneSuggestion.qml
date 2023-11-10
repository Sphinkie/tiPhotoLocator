import QtQuick
import "../Vues"

// Controlleur
ZoneSuggestionForm {


    bt_actualiser.onClicked: {
        // on recupere des infos à partir des coords GPS
        window.requestReverseGeocode(mapTab.photoLatitude, mapTab.photoLongitude);
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
