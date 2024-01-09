import QtQuick
import "../Vues"
import "../Javascript/Chips.js" as Chips

// Controleur pour la zone des keywords
ZoneUserdataForm {

    // -----------------------------------------------------------------------------------
    // EDIT BUTTON
    // -----------------------------------------------------------------------------------
    chipKeyword0.editArea.onClicked: Chips.enableEdition(chipKeyword0);
    chipKeyword1.editArea.onClicked: Chips.enableEdition(chipKeyword1);
    chipKeyword2.editArea.onClicked: Chips.enableEdition(chipKeyword2);
    chipKeyword3.editArea.onClicked: Chips.enableEdition(chipKeyword3);
    chipKeyword4.editArea.onClicked: Chips.enableEdition(chipKeyword4);
    chipKeyword5.editArea.onClicked: Chips.enableEdition(chipKeyword5);
    chipKeyword6.editArea.onClicked: Chips.enableEdition(chipKeyword6);
    chipKeyword7.editArea.onClicked: Chips.enableEdition(chipKeyword7);

    // -----------------------------------------------------------------------------------
    // SAVE BUTTON
    // -----------------------------------------------------------------------------------
    chipKeyword0.saveArea.onClicked:
    {
        _photoModel.updatePhotoKeyword(chipKeyword0.chipText.text, 0);
        Chips.resetChipButtons(chipKeyword0);
    }
    chipKeyword1.saveArea.onClicked:
    {
        _photoModel.updatePhotoKeyword(chipKeyword1.chipText.text, 1);
        Chips.resetChipButtons(chipKeyword1);
    }
    chipKeyword2.saveArea.onClicked:
    {
        _photoModel.updatePhotoKeyword(chipKeyword2.chipText.text, 2);
        Chips.resetChipButtons(chipKeyword2);
    }
    chipKeyword3.saveArea.onClicked:
    {
        _photoModel.updatePhotoKeyword(chipKeyword3.chipText.text, 3);
        Chips.resetChipButtons(chipKeyword3);
    }
    chipKeyword4.saveArea.onClicked:
    {
        _photoModel.updatePhotoKeyword(chipKeyword4.chipText.text, 4);
        Chips.resetChipButtons(chipKeyword4);
    }
    chipKeyword5.saveArea.onClicked:
    {
        _photoModel.updatePhotoKeyword(chipKeyword5.chipText.text, 5);
        Chips.resetChipButtons(chipKeyword5);
    }
    chipKeyword6.saveArea.onClicked:
    {
        _photoModel.updatePhotoKeyword(chipKeyword6.chipText.text, 6);
        Chips.resetChipButtons(chipKeyword6);
    }
    chipKeyword7.saveArea.onClicked:
    {
        _photoModel.updatePhotoKeyword(chipKeyword7.chipText.text, 7);
        Chips.resetChipButtons(chipKeyword7);
    }

    // -----------------------------------------------------------------------------------
    // REVERT BUTTON
    // -----------------------------------------------------------------------------------
    chipKeyword0.revertArea.onClicked:  Chips.revertEdition(chipKeyword0);
    chipKeyword1.revertArea.onClicked:  Chips.revertEdition(chipKeyword1);
    chipKeyword2.revertArea.onClicked:  Chips.revertEdition(chipKeyword2);
    chipKeyword3.revertArea.onClicked:  Chips.revertEdition(chipKeyword3);
    chipKeyword4.revertArea.onClicked:  Chips.revertEdition(chipKeyword4);
    chipKeyword5.revertArea.onClicked:  Chips.revertEdition(chipKeyword5);
    chipKeyword6.revertArea.onClicked:  Chips.revertEdition(chipKeyword6);
    chipKeyword7.revertArea.onClicked:  Chips.revertEdition(chipKeyword7);

    // -----------------------------------------------------------------------------------
    // DELETE BUTTON
    // -----------------------------------------------------------------------------------

    chipKeyword0.deleteArea.onClicked:   // (mouse) =>
    {
        // console.log("chipKeyword0.deleteArea.onClicked");
        // On supprime un seul keyword dans la liste
        _photoModel.removePhotoKeyword(chipKeyword0.content);
    }
    chipKeyword1.deleteArea.onClicked: _photoModel.removePhotoKeyword(chipKeyword1.content);
    chipKeyword2.deleteArea.onClicked: _photoModel.removePhotoKeyword(chipKeyword2.content);
    chipKeyword3.deleteArea.onClicked: _photoModel.removePhotoKeyword(chipKeyword3.content);
    chipKeyword4.deleteArea.onClicked: _photoModel.removePhotoKeyword(chipKeyword4.content);
    chipKeyword5.deleteArea.onClicked: _photoModel.removePhotoKeyword(chipKeyword5.content);
    chipKeyword6.deleteArea.onClicked: _photoModel.removePhotoKeyword(chipKeyword6.content);
    chipKeyword7.deleteArea.onClicked: _photoModel.removePhotoKeyword(chipKeyword7.content);

    // -----------------------------------------------------------------------------------
    // Connexions
    // -----------------------------------------------------------------------------------
    // On raffraichit la zone si SelectedData est modifiée
    Connections{
        target: tabbedPage
        function onSelectedDataChanged()
        {
            // console.debug("onSelectedDataChanged->ZoneUserData");

            // On détermine le contenu des chips ici
            var photoKeywords = tabbedPage.selectedData.keywords;

            // console.debug("photoKeywords[0]:" + photoKeywords[0]);
            chipKeyword0.content= photoKeywords[0]? photoKeywords[0] : ""
            chipKeyword1.content= photoKeywords[1]? photoKeywords[1] : ""
            chipKeyword2.content= photoKeywords[2]? photoKeywords[2] : ""
            chipKeyword3.content= photoKeywords[3]? photoKeywords[3] : ""
            chipKeyword4.content= photoKeywords[4]? photoKeywords[4] : ""
            chipKeyword5.content= photoKeywords[5]? photoKeywords[5] : ""
            chipKeyword6.content= photoKeywords[6]? photoKeywords[6] : ""
            chipKeyword7.content= photoKeywords[7]? photoKeywords[7] : ""
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
