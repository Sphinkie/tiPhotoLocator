import QtQuick
import "../Vues"


/*! *****************************************************************
 *  Controlleur de la zone d'affichage des données geographiques.
 * ***************************************************************** */
ZoneGeolocForm {

    chipLat.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, 0, "latitude");
    }
    chipLong.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, 0, "longitude");
    }
    chipCity.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "city");
    }
    chipCountry.deleteArea.onClicked:   // (mouse) =>
    {
        // console.log("chipCountry.deleteArea.onClicked");
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "country");
    }

    // On raffraichit la zone si SelectedData est modifiée
    Connections{
        target: tabbedPage
        function onSelectedDataChanged()
        {
            // console.debug("onSelectedDataChanged->ZoneGeoloc");
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
