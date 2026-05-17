import QtQuick
import QtQuick.Controls.Material
import "../Components"
import ".."


/** **********************************************************************************************************
 * @brief Cette Zone "Suggestions" affiche les Chips de Suggestion de Tags pour cette photo.
 * ***********************************************************************************************************/
Zone {
    id: suggestedTagsZone
    property alias bt_getinfo: bt_getinfo

    color: Style.suggestionBackgroundColor
    iconZone: "qrc:/Images/icon-suggestion.png"
    txtZone: qsTr("Suggestions")

    // Le Flickable permet de scroller s'il y a trop de suggestions.
    Flickable {
        contentWidth: parent.width
        contentHeight: parent.height

        /// Le Flow positionne les Chips les unes après les autres.
        Flow {
            id: grille
            width: parent.width
            height: parent.height
            spacing: 12
            padding: 20

            /// Le repeater affiche chacune des Suggestions (de catégorie "tag") du Model.
            SuggestionRepeater {
                id: suggestionRepeater
            }

            /// En dernière position, on prévoit un bouton qui pourrait faire appel à une IA.
            Button {
                id: bt_getinfo
                text: qsTr("More tags...")
                icon.source: "qrc:/Images/icon-suggestion.png"
                visible: false
            }
        }
    }
}
