import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material


/** **********************************************************************************************************
 * @brief QML. Ce Repeater contient les Keywords fournies par le modèle photoKeywords.
 * Le Repeater doit être encapsulé dans un positionneur de type Flow, ColumnLayout ou Column.
 * ***********************************************************************************************************/
Repeater {
    model: photoKeywords
    RowLayout {
        spacing: 24
        Chips {
            targetName: "keywords:"
            content: modelData ? modelData : ""
        }
        Button {
            text: qsTr("Apply to all")
            enabled: appliedKeywords.indexOf(modelData) === -1
            onClicked: applyKeyword(modelData)
        }
    }
}
