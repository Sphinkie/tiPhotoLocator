import QtQuick 2.4
import "../Vues"

// Controlleur
ZoneGeolocForm {

    chipLat.content: mapTab.photoLatitude.toFixed(4) + " Lat "  + ((mapTab.photoLatitude>0) ? "N" : "S")
    chipLong.content: mapTab.photoLongitude.toFixed(4) + " Long " + ((mapTab.photoLongitude>0) ? "E" : "W")

    chipCity.content: tabbedPage.selectedData.city
    chipCountry.content: tabbedPage.selectedData.country

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
