import QtQuick
import "../Components"
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities


// Controlleur de la zone avec les informations sur la photo
ZonePhotoForm {

    // ------------------------------- DATE
    chipDate.editArea.onClicked:
    {
        // Avec mask  : on peut saisir 99/99/9999 : pas de controle sur les chiffres mais les / sont imposés
        // Avec RegEx : les chiffres sont controlés, on ne peut pas saisir n'importe quoi, mais les / ne sont pas là pour aider
        // Gérer la saisie d'un texte de type DATE
        chipDate.chipText.inputMethodHints = Qt.ImhDate;
        chipDate.chipText.inputMask = "99/99/9999";
        enableEdit(chipDate);
        // FIXME On ne peut sauver que si c'est au bon format
        chipDate.canSave = true // chipDate.chipText.acceptableInput;
    }
    chipDate.saveArea.onClicked:
    {
        var newDateTime = chipDate.chipText.text + " " + chipTime.chipText.text;
        window.setPhotoProperty(tabbedPage.selectedData.row, newDateTime , "dateTimeOriginal");
        //chipDate.chipText.text = fixDate(chipDate)
        resetChipButtons(chipDate);
    }

    // ------------------------------- TIME
    chipTime.editArea.onClicked:
    {
        // Gérer la saisie d'un texte de type TIME
        chipTime.chipText.inputMethodHints = Qt.ImhTime;
        chipTime.chipText.inputMask = "99:99";
        enableEdit(chipTime);
        // TODO: On ne peut sauver que si c'est au bon format
        chipTime.canSave = true // chipTime.chipText.acceptableInput;
    }
    chipTime.saveArea.onClicked:
    {
        var newDateTime = chipDate.chipText.text + " " + chipTime.chipText.text;
        window.setPhotoProperty(tabbedPage.selectedData.row, newDateTime , "dateTimeOriginal");
        // chipTime.chipText.text = fixTime(chipTime)
        resetChipButtons(chipTime);
    }


    // ------------------------------- CREATOR
    chipCreator.editArea.onClicked:
    {
        enableEdit(chipCreator);
        // On active le bouton SAVE
        chipCreator.canSave = true;
    }
    chipCreator.saveArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, chipCreator.chipText.text, "creator");
        // tabbedPage.refreshSelectedData();
        resetChipButtons(chipCreator);
    }
    chipCreator.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "creator");
        // tabbedPage.refreshSelectedData();
        resetChipButtons(chipCreator);
    }

    // ------------------------------- DESCRIPTION
    chipDescription.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "description");
        // tabbedPage.refreshSelectedData();
    }

    chipWriter.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "descriptionWriter");
        // tabbedPage.refreshSelectedData();
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
    function enableEdit(chip)
    {
        // On désactive le bouton EDIT
        chip.editable = false;
        // On gère la saisie d'un texte
        chip.chipText.readOnly = false;
        chip.chipText.color = "white";
        chip.chipText.focus = true;
    }



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
