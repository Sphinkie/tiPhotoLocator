import QtQuick
import "../Vues"
import "../Javascript/Chips.js" as Chips


/** **********************************************************************************************************
 * @brief Controleur pour la zone des keywords.
 * ***********************************************************************************************************/
ZoneUserdataForm {

    // -----------------------------------------------------------------------------------
    // EDIT BUTTONS
    // -----------------------------------------------------------------------------------
    chipKeyword0.editArea.onClicked: Chips.enableEdition(chipKeyword0)
    chipKeyword1.editArea.onClicked: Chips.enableEdition(chipKeyword1)
    chipKeyword2.editArea.onClicked: Chips.enableEdition(chipKeyword2)
    chipKeyword3.editArea.onClicked: Chips.enableEdition(chipKeyword3)
    chipKeyword4.editArea.onClicked: Chips.enableEdition(chipKeyword4)
    chipKeyword5.editArea.onClicked: Chips.enableEdition(chipKeyword5)
    chipKeyword6.editArea.onClicked: Chips.enableEdition(chipKeyword6)
    chipKeyword7.editArea.onClicked: Chips.enableEdition(chipKeyword7)

    // -----------------------------------------------------------------------------------
    // SAVE BUTTONS
    // -----------------------------------------------------------------------------------
    chipKeyword0.saveArea.onClicked: {
        _photoModel.replaceKeywordForSelection(chipKeyword0.content, chipKeyword0.chipText.text)
        Chips.resetChipButtons(chipKeyword0)
    }
    chipKeyword1.saveArea.onClicked: {
        _photoModel.replaceKeywordForSelection(chipKeyword1.content, chipKeyword1.chipText.text)
        Chips.resetChipButtons(chipKeyword1)
    }
    chipKeyword2.saveArea.onClicked: {
        _photoModel.replaceKeywordForSelection(chipKeyword2.content, chipKeyword2.chipText.text)
        Chips.resetChipButtons(chipKeyword2)
    }
    chipKeyword3.saveArea.onClicked: {
        _photoModel.replaceKeywordForSelection(chipKeyword3.content, chipKeyword3.chipText.text)
        Chips.resetChipButtons(chipKeyword3)
    }
    chipKeyword4.saveArea.onClicked: {
        _photoModel.replaceKeywordForSelection(chipKeyword4.content, chipKeyword4.chipText.text)
        Chips.resetChipButtons(chipKeyword4)
    }
    chipKeyword5.saveArea.onClicked: {
        _photoModel.replaceKeywordForSelection(chipKeyword5.content, chipKeyword5.chipText.text)
        Chips.resetChipButtons(chipKeyword5)
    }
    chipKeyword6.saveArea.onClicked: {
        _photoModel.replaceKeywordForSelection(chipKeyword6.content, chipKeyword6.chipText.text)
        Chips.resetChipButtons(chipKeyword6)
    }
    chipKeyword7.saveArea.onClicked: {
        _photoModel.replaceKeywordForSelection(chipKeyword7.content, chipKeyword7.chipText.text)
        Chips.resetChipButtons(chipKeyword7)
    }

    // -----------------------------------------------------------------------------------
    // REVERT BUTTONS
    // -----------------------------------------------------------------------------------
    chipKeyword0.revertArea.onClicked: Chips.revertEdition(chipKeyword0)
    chipKeyword1.revertArea.onClicked: Chips.revertEdition(chipKeyword1)
    chipKeyword2.revertArea.onClicked: Chips.revertEdition(chipKeyword2)
    chipKeyword3.revertArea.onClicked: Chips.revertEdition(chipKeyword3)
    chipKeyword4.revertArea.onClicked: Chips.revertEdition(chipKeyword4)
    chipKeyword5.revertArea.onClicked: Chips.revertEdition(chipKeyword5)
    chipKeyword6.revertArea.onClicked: Chips.revertEdition(chipKeyword6)
    chipKeyword7.revertArea.onClicked: Chips.revertEdition(chipKeyword7)

    // -----------------------------------------------------------------------------------
    // DELETE BUTTONS : On supprime un seul keyword dans la liste
    // -----------------------------------------------------------------------------------
    chipKeyword0.onDeleteClicked: _photoModel.removePhotoKeyword(chipKeyword0.content)
    chipKeyword1.onDeleteClicked: _photoModel.removePhotoKeyword(chipKeyword1.content)
    chipKeyword2.onDeleteClicked: _photoModel.removePhotoKeyword(chipKeyword2.content)
    chipKeyword3.onDeleteClicked: _photoModel.removePhotoKeyword(chipKeyword3.content)
    chipKeyword4.onDeleteClicked: _photoModel.removePhotoKeyword(chipKeyword4.content)
    chipKeyword5.onDeleteClicked: _photoModel.removePhotoKeyword(chipKeyword5.content)
    chipKeyword6.onDeleteClicked: _photoModel.removePhotoKeyword(chipKeyword6.content)
    chipKeyword7.onDeleteClicked: _photoModel.removePhotoKeyword(chipKeyword7.content)


    /** **********************************************************************************
     * @brief Connexions: On raffraichit la Zone si CurrentPhoto est modifié.
     * ***********************************************************************************/
    Connections {
        target: tabbedPage
        function onCurrentPhotoChanged() {
            // console.debug("onSelectedDataChanged->ZoneUserData");

            // On détermine le contenu des chips ici
            var photoKeywords = tabbedPage.currentPhoto.keywords

            // console.debug("photoKeywords[0]:" + photoKeywords[0]);
            chipKeyword0.content = photoKeywords[0] ? photoKeywords[0] : ""
            chipKeyword1.content = photoKeywords[1] ? photoKeywords[1] : ""
            chipKeyword2.content = photoKeywords[2] ? photoKeywords[2] : ""
            chipKeyword3.content = photoKeywords[3] ? photoKeywords[3] : ""
            chipKeyword4.content = photoKeywords[4] ? photoKeywords[4] : ""
            chipKeyword5.content = photoKeywords[5] ? photoKeywords[5] : ""
            chipKeyword6.content = photoKeywords[6] ? photoKeywords[6] : ""
            chipKeyword7.content = photoKeywords[7] ? photoKeywords[7] : ""
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

