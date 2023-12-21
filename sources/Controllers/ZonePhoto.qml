import QtQuick
import "../Components"
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities
import "../Javascript/Chips.js" as Chips

// Controleur de la zone avec les informations sur la photo
ZonePhotoForm {

    // -----------------------------------------------------------------------------------
    // ------------------------------- DATE
    // -----------------------------------------------------------------------------------
    chipDate.editArea.onClicked:
    {
        // Gérer la saisie d'un texte de type DATE
        chipDate.chipText.inputMethodHints = Qt.ImhDate;
        chipDate.chipText.inputMask = "99/99/9999";
        Chips.enableEdition(chipDate);
    }
    chipDate.saveArea.onClicked:
    {
        var newDateTime = chipDate.chipText.text + " " + chipTime.chipText.text;
        window.setPhotoProperty(tabbedPage.selectedData.row, newDateTime , "dateTimeOriginal");
        Chips.resetChipButtons(chipDate);
    }

    chipDate.revertArea.onClicked:
    {
        Chips.revertEdition(chipDate);
    }

    // -----------------------------------------------------------------------------------
    // ------------------------------- TIME
    // -----------------------------------------------------------------------------------
    chipTime.editArea.onClicked:
    {
        // Gérer la saisie d'un texte de type TIME
        chipTime.chipText.inputMethodHints = Qt.ImhTime;
        chipTime.chipText.inputMask = "99:99";
        Chips.enableEdition(chipTime);
    }
    chipTime.saveArea.onClicked:
    {
        var newDateTime = chipDate.chipText.text + " " + chipTime.chipText.text;
        window.setPhotoProperty(tabbedPage.selectedData.row, newDateTime , "dateTimeOriginal");
        Chips.resetChipButtons(chipTime);
    }
    chipTime.revertArea.onClicked:
    {
        Chips.revertEdition(chipTime);
    }

    // -----------------------------------------------------------------------------------
    // ------------------------------- CREATOR
    // -----------------------------------------------------------------------------------
    chipCreator.editArea.onClicked:
    {
        Chips.enableEdition(chipCreator);
    }
    chipCreator.saveArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, chipCreator.chipText.text, "creator");
        Chips.resetChipButtons(chipCreator);
    }
    chipCreator.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "creator");
        Chips.resetChipButtons(chipCreator);
    }
    chipCreator.revertArea.onClicked:
    {
        Chips.revertEdition(chipCreator);
    }

    // -----------------------------------------------------------------------------------
    // ------------------------------- DESCRIPTION
    // -----------------------------------------------------------------------------------
    chipDescription.editArea.onClicked:
    {
        Chips.enableEdition(chipDescription);
    }
    chipDescription.saveArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, chipDescription.chipText.text, "description");
        Chips.resetChipButtons(chipDescription);
    }
    chipDescription.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "description");
    }
    chipDescription.revertArea.onClicked:
    {
        Chips.revertEdition(chipDescription);
    }

    // -----------------------------------------------------------------------------------
    // ------------------------------- CAPTION WRITER
    // -----------------------------------------------------------------------------------
    chipWriter.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "captionWriter");
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
            chipWriter.content = tabbedPage.selectedData.captionWriter
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
