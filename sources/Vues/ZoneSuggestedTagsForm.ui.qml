import QtQuick
import QtQuick.Layouts
import "../Components"

Zone {
    id: suggestedTagsZone
    color: TiStyle.suggestionBackgroundColor
    iconZone: "qrc:/Images/icon-suggestion.png"
    txtZone: qsTr("Suggestions")
    property alias bt_getinfo: bt_getinfo

    ColumnLayout {
        anchors.fill: parent

        TiButton {
            id: bt_getinfo
            text: qsTr("Chercher")
            color: "lightskyblue"
            icon.source: "qrc:/Images/icon-suggestion.png"
            Layout.alignment: Qt.AlignRight
            Layout.topMargin: 10
            Layout.rightMargin: 20
        }

        SuggestionListView {
            id: slv
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 20
            filterString: "photo"
        }
    }
}
