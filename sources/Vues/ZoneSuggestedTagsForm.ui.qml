import QtQuick
import QtQuick.Layouts
import "../Components"

Zone {
    id: suggestedTagsZone
    color: TiStyle.suggestionBackgroundColor
    iconZone: "qrc:/Images/icon-suggestion.png"
    txtZone: qsTr("Suggestions")
    property alias bt_getinfo: bt_getinfo

    Flickable {
        contentWidth: parent.width
        contentHeight: parent.height
        //        contentHeight: grille.implicitHeight
        Flow {
            id: grille
            width: parent.width
            height: parent.height
            padding: 10
            spacing: 10

            SuggestionRepeater {
                id: suggestionRepeater
                model: _suggestionTagProxyModel
            }

            TiButton {
                id: bt_getinfo
                text: qsTr("Autres tags...")
                color: "lightskyblue"
                icon.source: "qrc:/Images/icon-suggestion.png"
            }
        }
    }
}
