import QtQuick 2.0

Rectangle {
    id: rectZone
    // Propriétés modifiables depuis les parents:
    property string icon : ""

    radius: 16
    color: TiStyle.primaryForegroundColor
    implicitHeight: 300    // Note: Mettre Layout.fillHeight dans le parent pour bien occuper tout l'espace
    implicitWidth: 380
    property bool dropable: true

    // icone de fond
    Image {
        height: 200
        fillMode: Image.PreserveAspectFit
        source: icon
        anchors.centerIn: rectZone
    }

}
