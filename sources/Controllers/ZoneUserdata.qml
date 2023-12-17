import QtQuick
import "../Vues"

// Controlleur pour la zone des keywords
ZoneUserdataForm {


    chipKeyword1.deleteArea.onClicked:   // (mouse) =>
    {
        console.log("chipKeyword4.deleteArea.onClicked");
        // TODO : Il faut supprimer un seul keyword dans la liste
        window.removePhotoKeyword(chipKeyword1.text, "keywords");
    }
    chipKeyword2.deleteArea.onClicked:
    {

    }
    chipKeyword3.deleteArea.onClicked:
    {

    }
    chipKeyword4.deleteArea.onClicked:
    {
    }



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
