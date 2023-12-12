import QtQuick
import "../Components"
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities


// Controlleur de la zone avec les informations sur la photo
ZonePhotoForm {

    // ------------------------------- DATE
    chipDate.editArea.onClicked:
    {
        // Gérer la saisie d'un texte de type DATE
        chipDate.chipText.inputMethodHints = Qt.ImhDate;
        chipDate.chipText.inputMask = "99/99/9999";
        enableEdition(chipDate);
        chipDate.canSave = true;
    }
    chipDate.saveArea.onClicked:
    {
        var newDateTime = chipDate.chipText.text + " " + chipTime.chipText.text;
        window.setPhotoProperty(tabbedPage.selectedData.row, newDateTime , "dateTimeOriginal");
        resetChipButtons(chipDate);
    }

    chipDate.revertArea.onClicked:
    {
        chipDate.chipText.text = chipDate.content;
        resetChipButtons(chipDate);
    }

    // ------------------------------- TIME
    chipTime.editArea.onClicked:
    {
        // Gérer la saisie d'un texte de type TIME
        chipTime.chipText.inputMethodHints = Qt.ImhTime;
        chipTime.chipText.inputMask = "99:99";
        enableEdition(chipTime);
        chipTime.canSave = true;
    }
    chipTime.saveArea.onClicked:
    {
        var newDateTime = chipDate.chipText.text + " " + chipTime.chipText.text;
        window.setPhotoProperty(tabbedPage.selectedData.row, newDateTime , "dateTimeOriginal");
        resetChipButtons(chipTime);
    }
    chipTime.revertArea.onClicked:
    {
        chipTime.chipText.text = chipTime.content;
        resetChipButtons(chipTime);
    }


    // ------------------------------- CREATOR
    chipCreator.editArea.onClicked:
    {
        enableEdition(chipCreator);
        // On active le bouton SAVE
        chipCreator.canSave = true;
    }
    chipCreator.saveArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, chipCreator.chipText.text, "creator");
        resetChipButtons(chipCreator);
    }
    chipCreator.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "creator");
        resetChipButtons(chipCreator);
    }
    chipCreator.revertArea.onClicked:
    {
        chipCreator.chipText.text = chipCreator.content;
        resetChipButtons(chipCreator);
    }


    // ------------------------------- DESCRIPTION
    chipDescription.editArea.onClicked:
    {
        enableEdition(chipDescription);
        chipDescription.canSave = true;
    }
    chipDescription.saveArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, chipDescription.chipText.text, "description");
        resetChipButtons(chipDescription);
    }
    chipDescription.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "description");
    }
    chipDescription.revertArea.onClicked:
    {
        chipDescription.chipText.text = chipDescription.content;
        resetChipButtons(chipDescription);
    }

    // ------------------------------- DESCRIPTION WRITER
    chipWriter.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "descriptionWriter");
    }

    // -----------------------------------------------------------------------------------
    // Connexions
    // -----------------------------------------------------------------------------------
    // On raffraichit la zone si SelectedData est modifiée
    Connections{
        target: tabbedPage
        function onSelectedDataChanged()
        {
            // console.debug("onSelectedDataChanged->ZonePhoto");
            chipDate.content = Utilities.toReadableDate(tabbedPage.selectedData.dateTimeOriginal)
            chipTime.content = Utilities.toReadableTime(tabbedPage.selectedData.dateTimeOriginal)
            chipCreator.content = tabbedPage.selectedData.creator
            chipDescription.content = tabbedPage.selectedData.description
            chipWriter.content = tabbedPage.selectedData.descriptionWriter
        }
    }

    // -----------------------------------------------------------------------------------
    // Fonctions
    // -----------------------------------------------------------------------------------
    /*!
     * Réactive le bouton Edit (en cas d'édition interrompue par un SUPPR).
     */
    function resetChipButtons(chip)
    {
        // On résactive le bouton EDIT
        chip.editable = true;
        // On désactive le bouton SAVE
        chip.canSave = false;
        // Terminer la saisie du texte
        chip.chipText.readOnly = true;
        chip.chipText.color = TiStyle.chipTextColor;
        chip.chipText.focus = false;
    }

    /*!
     * Active l'édition d'un chip
     */
    function enableEdition(chip)
    {
        // On désactive le bouton EDIT
        chip.editable = false;
        // On gère la saisie d'un texte
        chip.chipText.readOnly = false;
        chip.chipText.color = "white";
        chip.chipText.focus = true;
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
