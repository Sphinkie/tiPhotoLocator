import QtQuick
import "../Vues"

// Controlleur pour la zone des keywords
ZoneUserdataForm {


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

            // console.debug("photoKeywords[0]" + photoKeywords[0]);
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
