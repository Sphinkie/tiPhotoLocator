import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"


/** **********************************************************************************************************
 * @brief Cette zone affiche les Chips de Suggestion géographiques.
 * ***********************************************************************************************************/
Zone {
    id: suggestedLocationsZone
    property alias bt_getinfo: bt_getinfo

    color: Style.suggestionBackgroundColor
    iconZone: "qrc:/Images/icon-suggestion.png"
    txtZone: qsTr("Suggestions basées sur la position GPS de la photo, grace au service gratuit et opensource OpenStreetMap.\nLimité à 100 requètes par jour.")

    ColumnLayout {

        /// En première position, ce bouton fait appel à une API pour obténier des suggestions de noms de lieux.
        Button {
            id: bt_getinfo
            text: qsTr("Search")
            icon.source: "qrc:/Images/icon-suggestion.png"
            enabled: tabbedPage.currentPhoto.hasGPS
            Layout.topMargin: 16
            Layout.leftMargin: 20
            ToolTip.text: qsTr(
                              "Recherche de données géographiques sur Internet")
            ToolTip.visible: hovered
            ToolTip.delay: 500
        }

        /// Le Flow positionne les Chips les unes après les autres.
        Flow {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            topPadding: 10
            leftPadding: 20

            /// Le repeter affiche chacune des Suggestions (de catégorie "geo") du Model.
            SuggestionRepeater {
                id: suggestionRepeater
            }
        }
    }
}
