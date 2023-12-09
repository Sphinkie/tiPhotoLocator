import QtQuick
import "../Components"

ListView {
    spacing: 4

    orientation: Qt.Horizontal
    model: _onTheMapProxyModel
    focus: false

    // le delegate pour afficher l'imagette dans la ListView
    delegate: Rectangle {
        required property string imageUrl
        required property bool isSelected
        width: 134
        height: 104
        color: isSelected? TiStyle.primaryColor : TiStyle.surfaceContainerColor

        Image {
            width: 130
            height: 100
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            source: imageUrl
        }

    }

}
