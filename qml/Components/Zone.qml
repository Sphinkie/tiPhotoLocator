import QtQuick 2.0

Rectangle {
    id: rectZone
    // Propriétés modifiables depuis les parents:
    property string icon : ""

    radius: 16
    color: TiStyle.primaryForegroundColor
    implicitHeight: 600
    implicitWidth: 400
    property bool dropable: true
    // icone de fond
    // gridlayout

    Image {
//        width: 120
        height: 200
        fillMode: Image.PreserveAspectFit
        source: icon
        anchors.centerIn: rectZone
    }

}
