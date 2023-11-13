import QtQuick
import "../Vues"

// Controlleur
ZoneGeolocForm {

    chipLat.deleteArea.onClicked:
    {
        console.log("chipLat.deleteArea.onClicked");
        chipLat.visible = false;
        // TODO : modifier le modele
        tabbedPage.refreshSelectedData();
    }
    chipLong.deleteArea.onClicked:
    {
        console.log("chipLong.deleteArea.onClicked");
        chipLong.visible = false;
        // TODO : modifier le modele
        tabbedPage.refreshSelectedData();
    }
    chipCity.deleteArea.onClicked:
    {
        console.log("chipCity.deleteArea.onClicked");
        chipCity.visible = false;
        // TODO : modifier le modele
        tabbedPage.refreshSelectedData();
    }
    chipCountry.deleteArea.onClicked:   // (mouse) =>
    {
        console.log("chipCountry.deleteArea.onClicked");
        chipCountry.visible = false;
        // TODO : modifier le modele
        tabbedPage.refreshSelectedData();
    }

    // On raffraichit la zone si SelectedData est modifiée
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
