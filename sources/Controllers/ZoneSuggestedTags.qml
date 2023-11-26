import QtQuick
import "../Vues"

// Controlleur
ZoneSuggestedTagsForm {


    bt_getinfo.onClicked: {
        // on recupere des infos à partir des IA
    }



    // Gestion du grisage du bouton
    Connections{
        target: tabbedPage
        function onSelectedDataChanged()
        {
            bt_getinfo.enabled = tabbedPage.selectedData.hasGPS;
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
