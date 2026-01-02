import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"


/** **********************************************************************************************************
 * @brief Cette zone affiche les Chips de Suggestion de Tags pour cette photo.
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

        // Le Flow met les chips les unes après les autres.
        Flow {
            id: grille
            width: parent.width
            height: parent.height
            spacing: 12
            padding: 20

            SuggestionRepeater {
                id: suggestionRepeater
            }

            Button {
                id: bt_getinfo
                text: qsTr("Autres tags...")
                icon.source: "qrc:/Images/icon-suggestion.png"
            }
        }
    }
}
