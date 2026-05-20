import QtQuick
import "../Vues"


/** **********************************************************************************************************
 * @brief Controlleur de la zone d'affichage des données géographiques. Gère les boutons des Chips.
 * ***********************************************************************************************************/
ZoneGeolocForm {


    /** **********************************************************************************
     * On efface les coordonnées GPS de la photo sélectionnée.
     * ***********************************************************************************/
    bt_clear_coords.onClicked: {
        _photoModel.currentItemCoords = QtPositioning.coordinate(0, 0)
    }

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
        window.setPhotoProperty(-4, chipCity.chipText.text, "city")
        Chips.resetChipButtons(chipCity)
    }
    chipCountry.saveArea.onClicked: {
        window.setPhotoProperty(-4, chipCountry.chipText.text, "country")
        Chips.resetChipButtons(chipCountry)
    }
    chipLocation.saveArea.onClicked: {
        window.setPhotoProperty(-4, chipLocation.chipText.text, "location")
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
        window.setPhotoProperty(tabbedPage.currentPhoto.row, 0, "latitude")
    }
    chipLong.deleteArea.onClicked: {
        window.setPhotoProperty(tabbedPage.currentPhoto.row, 0, "longitude")
    }
    chipCity.deleteArea.onClicked: {
        window.setPhotoProperty(tabbedPage.currentPhoto.row, "", "city")
    }
    chipCountry.deleteArea.onClicked: {
        window.setPhotoProperty(tabbedPage.currentPhoto.row, "", "country")
    }
    chipLocation.deleteArea.onClicked: // (mouse) =>
    {
        console.log("chipLocation.deleteArea.onClicked")
        window.setPhotoProperty(tabbedPage.currentPhoto.row, "", "location")
    }

    // -----------------------------------------------------------------------------------
    // Connexions
    // -----------------------------------------------------------------------------------
    // On raffraichit la zone si SelectedData est modifiée
    Connections {
        target: tabbedPage
        function onCurrentPhotoChanged() {
            // console.debug("onSelectedDataChanged->ZoneGeoloc");
            bt_clear_coords.enabled = tabbedPage.currentPhoto.hasGPS
            chipLat.visible = tabbedPage.currentPhoto.hasGPS
            chipLong.visible = tabbedPage.currentPhoto.hasGPS
            chipLat.content = tabbedPage.currentPhoto.latitude.toFixed(
                        4) + " Lat " + ((tabbedPage.currentPhoto.latitude > 0) ? "N" : "S")
            chipLong.content = tabbedPage.currentPhoto.longitude.toFixed(
                        4) + " Long " + ((tabbedPage.currentPhoto.longitude > 0) ? "E" : "W")
            chipCity.content = tabbedPage.currentPhoto.city
            chipCountry.content = tabbedPage.currentPhoto.country
            chipLocation.content = tabbedPage.currentPhoto.location
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

