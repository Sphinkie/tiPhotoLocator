import QtQuick
import "../Components"
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities
import "../Javascript/Chips.js" as Chips


/** **********************************************************************************************************
 * @brief Controleur de la zone avec les informations sur la photo
 * ***********************************************************************************************************/
ZonePhotoForm {

    // -----------------------------------------------------------------------------------
    // ------------------------------- DATE
    // -----------------------------------------------------------------------------------
    chipDate.editArea.onClicked: {
        // Gérer la saisie d'un texte de type DATE
        chipDate.chipText.inputMethodHints = Qt.ImhDate
        chipDate.chipText.inputMask = "99/99/9999"
        Chips.enableEdition(chipDate)
    }
    chipDate.saveArea.onClicked: {
        var newDateTime = chipDate.chipText.text + " " + chipTime.chipText.text
        window.setPhotoProperty(-4, newDateTime, "dateTimeOriginal")
        Chips.resetChipButtons(chipDate)
    }

    chipDate.revertArea.onClicked: {
        Chips.revertEdition(chipDate)
    }

    // -----------------------------------------------------------------------------------
    // ------------------------------- TIME
    // -----------------------------------------------------------------------------------
    chipTime.editArea.onClicked: {
        // Gérer la saisie d'un texte de type TIME
        chipTime.chipText.inputMethodHints = Qt.ImhTime
        chipTime.chipText.inputMask = "99:99"
        Chips.enableEdition(chipTime)
    }
    chipTime.saveArea.onClicked: {
        var newDateTime = chipDate.chipText.text + " " + chipTime.chipText.text
        window.setPhotoProperty(-4, newDateTime, "dateTimeOriginal")
        Chips.resetChipButtons(chipTime)
    }
    chipTime.revertArea.onClicked: {
        Chips.revertEdition(chipTime)
    }

    // -----------------------------------------------------------------------------------
    // ------------------------------- CREATOR
    // -----------------------------------------------------------------------------------
    chipCreator.editArea.onClicked: {
        Chips.enableEdition(chipCreator)
    }
    chipCreator.saveArea.onClicked: {
        window.setPhotoProperty(-4, chipCreator.chipText.text, "creator")
        Chips.resetChipButtons(chipCreator)
    }
    chipCreator.onDeleteClicked: {
        window.setPhotoProperty(tabbedPage.currentPhoto.row, "", "creator")
        Chips.resetChipButtons(chipCreator)
    }
    chipCreator.revertArea.onClicked: {
        Chips.revertEdition(chipCreator)
    }

    // -----------------------------------------------------------------------------------
    // ------------------------------- DESCRIPTION
    // -----------------------------------------------------------------------------------
    chipDescription.editArea.onClicked: {
        Chips.enableEdition(chipDescription)
    }
    chipDescription.saveArea.onClicked: {
        window.setPhotoProperty(-4, chipDescription.chipText.text, "description")
        Chips.resetChipButtons(chipDescription)
    }
    chipDescription.onDeleteClicked: {
        window.setPhotoProperty(tabbedPage.currentPhoto.row, "", "description")
    }
    chipDescription.revertArea.onClicked: {
        Chips.revertEdition(chipDescription)
    }

    // -----------------------------------------------------------------------------------
    // ------------------------------- CAPTION WRITER
    // -----------------------------------------------------------------------------------
    chipWriter.onDeleteClicked: {
        window.setPhotoProperty(tabbedPage.currentPhoto.row, "", "captionWriter")
    }

    // -----------------------------------------------------------------------------------
    // Connexions
    // -----------------------------------------------------------------------------------
    // On raffraichit la zone si SelectedData est modifiée
    Connections {
        target: tabbedPage
        function onCurrentPhotoChanged() {
            // console.debug("onSelectedDataChanged->ZonePhoto");
            chipDate.content = Utilities.toReadableDate(
                        tabbedPage.currentPhoto.dateTimeOriginal)
            chipTime.content = Utilities.toReadableTime(
                        tabbedPage.currentPhoto.dateTimeOriginal)
            chipCreator.content = tabbedPage.currentPhoto.creator
            chipDescription.content = tabbedPage.currentPhoto.description
            chipWriter.content = tabbedPage.currentPhoto.captionWriter
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

