import QtQuick
import "../Vues"

// Controlleur pour la zone des keywords
ZoneUserdataForm {

    // On détermine le contenu des chips ici

    chipKeyword1.content: ""
    chipKeyword2.content: ""
    chipKeyword3.content: ""
    chipKeyword4.content: "Etonnant"


    chipKeyword1.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "keywords");
    }
    chipKeyword2.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "keywords");
    }
    chipKeyword3.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "keywords");
    }
    chipKeyword4.deleteArea.onClicked:   // (mouse) =>
    {
        console.log("chipKeyword4.deleteArea.onClicked");
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "keywords");
    }



}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
