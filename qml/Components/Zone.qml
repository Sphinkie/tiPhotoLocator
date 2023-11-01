import QtQuick

Rectangle {
    id: rectZone
    // Propriétés modifiables depuis les parents:
    property string iconZone
    property string txtZone

    radius: 16
    color: TiStyle.primaryBackgroundColor
    implicitHeight: 300    // Note: Mettre Layout.fillHeight dans le parent pour bien occuper tout l'espace
    implicitWidth: 380
    property bool dropable: true
    clip: true

    // icone de fond
    Image {
        id: imgZone
        height: parent.height * 0.4
        fillMode: Image.PreserveAspectFit
        source: iconZone
        anchors.centerIn: rectZone
    }

    // Texte explicatif (optionnel)
    Text{
        color: Qt.darker(parent.color, 1.3)
        text: txtZone
        font.weight: Font.Thin
        font.pointSize: 16
        fontSizeMode: Text.Fit
        minimumPixelSize: 10
        wrapMode: Text.WordWrap
        anchors.top: imgZone.bottom
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
    }

}
