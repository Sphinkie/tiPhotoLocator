import QtQuick


/** **********************************************************************************************************
 * @brief Cette zone est une barre de titre
 * ***********************************************************************************************************/
Zone {
    id: zoneTitle
    property string titleText
    implicitHeight: 60

    // DDL color: TiStyle.suggestionBackgroundColor
    Text {
        width: parent.width
        text: parent.titleText
        font.pointSize: 10
        wrapMode: Text.WordWrap
        anchors.centerIn: zoneTitle // A mettre si on veut positionner le texte à mi-hauteur.
        horizontalAlignment: Text.AlignHCenter
        textFormat: Text.StyledText
    }
}
