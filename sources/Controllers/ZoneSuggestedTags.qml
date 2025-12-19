import QtQuick
import "../Vues"


/** **********************************************************************************************************
 * @brief Controlleur pour la zone des suggestions de l'onglet TAGS.
 * Les Chips suggestions sont affichées par SuggestionRepeater dans un Flow.
 * ***********************************************************************************************************/
ZoneSuggestedTagsForm {

    bt_getinfo.onClicked: {

        // on recupere des infos à partir des IA
    }


    /*
    // Gestion du grisage du bouton
    Connections{
        target: tabbedPage
        function onSelectedDataChanged()
        {
            bt_getinfo.enabled = true
        }
    }
*/
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

