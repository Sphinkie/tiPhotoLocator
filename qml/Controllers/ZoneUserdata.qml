import QtQuick 2.4
import "../Vues"

// Controlleur
ZoneUserdataForm {

    // On determine le contenu des champs ici, mais ça marche aussi si on le fait dans la vue.

    chipArtist.content:      "tabbedPage.selectedData.artist"
    chipDescription.content: "tabbedPage.selectedData.description"
    chipWriter.content:      "tabbedPage.selectedData.descriptionWriter"

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
