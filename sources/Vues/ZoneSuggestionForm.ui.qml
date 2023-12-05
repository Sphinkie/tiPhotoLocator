import QtQuick
import QtQuick.Layouts
import "../Components"

Zone{
    id: suggestionZone
    color: TiStyle.suggestionBackgroundColor
    iconZone: "qrc:/Images/icon-suggestion.png"
    txtZone: qsTr("Suggestions basées sur la position GPS de la photo, grace au service gratuit et opensource OpenStreetMap.\nLimité à 100 requètes par jour.")
    property alias bt_getinfo: bt_getinfo

    ColumnLayout {
        anchors.fill: parent

        TiButton {
            id: bt_getinfo
            text: qsTr("Chercher")
            color: "lightskyblue"
            icon.source: "qrc:/Images/icon-suggestion.png"
            enabled: tabbedPage.selectedData.hasGPS
            Layout.alignment: Qt.AlignRight
            Layout.topMargin: 10
            Layout.rightMargin: 20
        }

        SuggestionRepeater {
            id : suggestionRepeater
            model: _suggestionGeoProxyModel
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 20
        }
    }

}


