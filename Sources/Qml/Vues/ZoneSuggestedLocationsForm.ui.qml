import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"
import ".."


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

        Button {
            id: bt_getinfo
            text: qsTr("Chercher")
            icon.source: "qrc:/Images/icon-suggestion.png"
            enabled: tabbedPage.selectedData.hasGPS
            Layout.topMargin: 16
            Layout.leftMargin: 20
            ToolTip.text: qsTr(
                              "Recherche de données géographiques sur Internet")
            ToolTip.visible: hovered
            ToolTip.delay: 500
        }

        // Le Flow met les chips les unes après les autres.
        Flow {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            topPadding: 10
            leftPadding: 20

            SuggestionRepeater {
                id: suggestionRepeater
            }
        }
    }
}
