import QtQuick
import "../Vues"

// Controlleur
ZoneGeolocForm {

//    chipLat.content: mapTab.photoLatitude.toFixed(4) + " Lat "  + ((mapTab.photoLatitude>0) ? "N" : "S")
//    chipLong.content: mapTab.photoLongitude.toFixed(4) + " Long " + ((mapTab.photoLongitude>0) ? "E" : "W")
/*
    chipLat.content: tabbedPage.selectedData.latitude.toFixed(4) + " Lat "  + ((tabbedPage.selectedData.latitude>0) ? "N" : "S")
    chipLong.content: tabbedPage.selectedData.longitude.toFixed(4) + " Long " + ((tabbedPage.selectedData.longitude>0) ? "E" : "W")

    chipCity.content: tabbedPage.selectedData.city
    chipCountry.content: tabbedPage.selectedData.country
*/

    Connections{
        target: tabbedPage
        function onSelectedDataChanged()
        {
            console.log("onSelectedDataChanged");
            chipLat.visible = tabbedPage.selectedData.hasGPS;
            chipLong.visible= tabbedPage.selectedData.hasGPS;
            chipLat.content = tabbedPage.selectedData.latitude.toFixed(4) + " Lat "  + ((tabbedPage.selectedData.latitude>0) ? "N" : "S");
            chipLong.content= tabbedPage.selectedData.longitude.toFixed(4) + " Long " + ((tabbedPage.selectedData.longitude>0) ? "E" : "W");
            chipCity.content= tabbedPage.selectedData.city;
            chipCountry.content= tabbedPage.selectedData.country;
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
