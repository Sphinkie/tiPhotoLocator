import QtQuick
import QtQuick.Layouts

ListView {
    spacing: 134

    orientation: Qt.Horizontal
    model: _onTheMapProxyModel
    focus: false

    // le delegate pour afficher l'imagette dans la ListView
    delegate:
        Item {
            required property string imageUrl

            Image {
                width: 130
                height: 100
                fillMode: Image.PreserveAspectFit
                source: imageUrl
            }

        }

}
