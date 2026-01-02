import QtQuick
import "../Vues"


/** **********************************************************************************************************
 * @brief Controlleur de la zone d'affichage des données géographiques. Gère les boutons des Chips.
 * ***********************************************************************************************************/
ZoneGeolocForm {

    // -----------------------------------------------------------------------------------
    // EDIT BUTTON
    // -----------------------------------------------------------------------------------
    chipCity.editArea.onClicked: Chips.enableEdition(chipCity)
    chipCountry.editArea.onClicked: Chips.enableEdition(chipCountry)
    chipLocation.editArea.onClicked: Chips.enableEdition(chipLocation)

    // -----------------------------------------------------------------------------------
    // SAVE BUTTON
    // -----------------------------------------------------------------------------------
    chipCity.saveArea.onClicked: {
        window.setPhotoProperty(tabbedPage.selectedData.row,
                                chipCity.chipText.text, "city")
        Chips.resetChipButtons(chipCity)
    }
    chipCountry.saveArea.onClicked: {
        window.setPhotoProperty(tabbedPage.selectedData.row,
                                chipCountry.chipText.text, "country")
        Chips.resetChipButtons(chipCountry)
    }
    chipLocation.saveArea.onClicked: {
        window.setPhotoProperty(tabbedPage.selectedData.row,
                                chipLocation.chipText.text, "location")
        Chips.resetChipButtons(chipLocation)
    }

    // -----------------------------------------------------------------------------------
    // REVERT BUTTON
    // -----------------------------------------------------------------------------------
    chipCity.revertArea.onClicked: Chips.revertEdition(chipCity)
    chipCountry.revertArea.onClicked: Chips.revertEdition(chipCountry)
    chipLocation.revertArea.onClicked: Chips.revertEdition(chipLocation)

    // -----------------------------------------------------------------------------------
    // DELETE BUTTON
    // -----------------------------------------------------------------------------------
    chipLat.deleteArea.onClicked: {
        window.setPhotoProperty(tabbedPage.selectedData.row, 0, "latitude")
    }
    chipLong.deleteArea.onClicked: {
        window.setPhotoProperty(tabbedPage.selectedData.row, 0, "longitude")
    }
    chipCity.deleteArea.onClicked: {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "city")
    }
    chipCountry.deleteArea.onClicked: {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "country")
    }
    chipLocation.deleteArea.onClicked: // (mouse) =>
    {
        console.log("chipLocation.deleteArea.onClicked")
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "location")
    }

    // -----------------------------------------------------------------------------------
    // Connexions
    // -----------------------------------------------------------------------------------
    // On raffraichit la zone si SelectedData est modifiée
    Connections {
        target: tabbedPage
        function onSelectedDataChanged() {
            // console.debug("onSelectedDataChanged->ZoneGeoloc");
            chipLat.visible = tabbedPage.selectedData.hasGPS
            chipLong.visible = tabbedPage.selectedData.hasGPS
            chipLat.content = tabbedPage.selectedData.latitude.toFixed(
                        4) + " Lat " + ((tabbedPage.selectedData.latitude > 0) ? "N" : "S")
            chipLong.content = tabbedPage.selectedData.longitude.toFixed(
                        4) + " Long " + ((tabbedPage.selectedData.longitude > 0) ? "E" : "W")
            chipCity.content = tabbedPage.selectedData.city
            chipCountry.content = tabbedPage.selectedData.country
            chipLocation.content = tabbedPage.selectedData.location
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

