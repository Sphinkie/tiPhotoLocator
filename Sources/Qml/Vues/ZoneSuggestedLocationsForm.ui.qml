import QtQuick
import QtQuick.Controls.Material
import "../Components"

/** **********************************************************************************************************
 * @brief Cette zone affiche les Chips de Suggestion géographiques.
 * ***********************************************************************************************************/
Zone {
    id: suggestedLocationsZone
    property alias bt_getinfo: bt_getinfo
    property alias bt_clear_geo_suggs: bt_clear_geo_suggs
    property alias getCenterForTarget: geoSuggestionRepeater.getCenterForTarget

    color: Style.suggestionBackgroundColor
    iconZone: "qrc:/Images/icon-suggestion.png"
    txtZone: qsTr("These suggestions are based on the photo GPS metadata, thanks to the free OpenStreetMap service.\nLimited to 100 requests per day.")

    /// Bouton fixe en haut — fait appel à l'API Nominatim pour obtenir des suggestions de noms de lieux.
    Button {
        id: bt_getinfo
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.leftMargin: 20
        text: qsTr("Search")
        icon.source: "qrc:/Images/icon-suggestion.png"
        enabled: tabbedPage.currentPhoto.hasGPS
        ToolTip.text: qsTr("Search geodata on Internet")
        ToolTip.visible: hovered
        ToolTip.delay: 500
    }

    /// Bouton fixe en haut — Nettoie la liste des suggestions Nominatim.
    Button {
        id: bt_clear_geo_suggs
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.left: bt_getinfo.right
        anchors.leftMargin: 20
        text: qsTr("Clear")
        icon.source: "qrc:/Images/bt-clean-all.png"
        enabled: geoSuggestionRepeater.count > 0
        ToolTip.text: qsTr("Clear all suggestions")
        ToolTip.visible: hovered
        ToolTip.delay: 500
    }

    /// Le Flickable permet de scroller s'il y a trop de suggestions.
    Flickable {
        anchors.top: bt_getinfo.bottom
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        contentWidth: width
        contentHeight: suggestionFlow.height
        clip: true
        flickableDirection: Flickable.VerticalFlick
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }

        /// Le Flow positionne les Chips les unes après les autres.
        Flow {
            id: suggestionFlow
            width: parent.width
            spacing: 12
            topPadding: 10
            leftPadding: 20

            /// Le repeater affiche chacune des Suggestions (de catégorie "geo") du Model.
            SuggestionRepeater {
                id: geoSuggestionRepeater
            }
        }
    }
}
