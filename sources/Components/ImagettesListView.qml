import QtQuick

ListView {
    height: 120
    anchors{
        fill: parent
        leftMargin: listViewFrame.width
        topMargin: 10
    }
    orientation: Qt.Horizontal
    model: _onTheMapProxyModel
    delegate: imgDelegate
    focus: false

    // le delegate pour afficher l'imagette dans la ListView
    Component{
        id: imgDelegate
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

}
