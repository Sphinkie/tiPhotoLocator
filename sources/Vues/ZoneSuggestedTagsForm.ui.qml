import QtQuick
import QtQuick.Layouts
import "../Components"

Zone {
    id: suggestedTagsZone
    color: TiStyle.suggestionBackgroundColor
    iconZone: "qrc:/Images/icon-suggestion.png"
    txtZone: qsTr("Suggestions")
    property alias bt_getinfo: bt_getinfo

    GridLayout {
        id: grille
        anchors.fill: parent
        rows: 5
        columns: 4
        flow: GridLayout.TopToBottom

        TiButton {
            id: bt_getinfo
            text: qsTr("Analyser")
            color: "lightskyblue"
            icon.source: "qrc:/Images/icon-suggestion.png"
            // Layout.alignment: Qt.AlignRight
            Layout.topMargin: 10
            Layout.leftMargin: 20
        }

        SuggestionListView {
            id: slv
            filterString: "photo"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
        }
    }
}
