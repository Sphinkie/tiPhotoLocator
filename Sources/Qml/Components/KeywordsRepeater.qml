import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material


/** **********************************************************************************************************
 * @brief QML. Ce Repeater contient les Keywords fournies par le modèle photoKeywords (qui est rempli par la ZoneGlobalTags).
 * @note Le Repeater doit être encapsulé dans un positionneur de type Flow, ColumnLayout ou Column.
 * ***********************************************************************************************************/
Repeater {
    model: photoKeywords
    RowLayout {
        spacing: 24
        /// Affichage d'un tag de l'image courante
        Chips {
            targetName: "keywords:"
            chipCategory: "keyword"
            content: modelData ? modelData : ""
        }
        /// Bouton pour appliquer ce tag à toutes les images.
        Button {
            text: qsTr("Apply to all")
            enabled: appliedKeywords.indexOf(modelData) === -1
            onClicked: applyKeyword(modelData)
        }
        /// Bouton pour appliquer ce tag aux images sélectionnées.
        Button {
            text: qsTr("Apply to selection")
            enabled: selectionCount > 1 && appliedKeywords.indexOf(
                         modelData) === -1
            onClicked: applyKeywordToSelection(modelData)
        }
    }
}
