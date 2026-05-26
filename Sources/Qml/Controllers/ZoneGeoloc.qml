import QtQuick
import "../Vues"


/** **********************************************************************************************************
 * @brief Controlleur de la zone d'affichage des données géographiques. Gère les boutons des Chips.
 * ***********************************************************************************************************/
ZoneGeolocForm {


    /** **********************************************************************************
     * On efface les coordonnées GPS de la photo sélectionnée.
     * Changer le State va déclencher l'animation de disparition.
     * ***********************************************************************************/
    bt_clear_coords.onClicked: {
        chipLat.state = "deleting"
        chipLong.state = "deleting"
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
    // SWAP BUTTON (city ↔ location)
    // -----------------------------------------------------------------------------------
    chipCity.swapArea.onClicked: {
        var val = chipCity.chipText.text
        window.setPhotoProperty(-4, val, "location")
        window.setPhotoProperty(-4, "", "city")
        chipLocation.content = val
        chipCity.content = ""
    }
    chipLocation.swapArea.onClicked: {
        var val = chipLocation.chipText.text
        window.setPhotoProperty(-4, val, "city")
        window.setPhotoProperty(-4, "", "location")
        chipCity.content = val
        chipLocation.content = ""
    }

    // -----------------------------------------------------------------------------------
    // REVERT BUTTON
    // -----------------------------------------------------------------------------------
    chipCity.revertArea.onClicked: Chips.revertEdition(chipCity)
    chipCountry.revertArea.onClicked: Chips.revertEdition(chipCountry)
    chipLocation.revertArea.onClicked: Chips.revertEdition(chipLocation)

    // -----------------------------------------------------------------------------------
    // DELETE BUTTON : Gestion de l'effet de dispartion
    // Lat et Long sont liés : supprimer l'un déclenche l'animation sur les deux.
    // -----------------------------------------------------------------------------------
    Connections {
        target: chipLat.deleteArea
        /// Cliquer sur Delete LAT, change aussi le state de LONG.
        function onClicked() { chipLong.state = "deleting" }
    }
    Connections {
        target: chipLong.deleteArea
        /// Cliquer sur Delete LONG, change aussi le state de LAT.
        function onClicked() { chipLat.state = "deleting" }
    }
    chipLat.onDeleteClicked: {
        window.setPhotoProperty(tabbedPage.currentPhoto.row, 0, "latitude")
        window.setPhotoProperty(tabbedPage.currentPhoto.row, 0, "longitude")
    }
    chipLong.onDeleteClicked: {
        window.setPhotoProperty(tabbedPage.currentPhoto.row, 0, "latitude")
        window.setPhotoProperty(tabbedPage.currentPhoto.row, 0, "longitude")
    }
    chipCity.onDeleteClicked: {
        window.setPhotoProperty(tabbedPage.currentPhoto.row, "", "city")
    }
    chipCountry.onDeleteClicked: {
        window.setPhotoProperty(tabbedPage.currentPhoto.row, "", "country")
    }
    chipLocation.onDeleteClicked: {
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

