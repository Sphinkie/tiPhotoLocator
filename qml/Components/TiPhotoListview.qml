import QtQuick 2.15
import QtQuick.Layouts  1.15


// https://www.youtube.com/watch?v=ZArpJDRJxcI

ListView{
    id: listView
    anchors.fill: parent
    model: _photoListModel
    delegate: listDelegate
    focus: true
    clip: true   // pour que les items restent à l'interieur de la listview

    // Une ligne en bas de la listview
    footer: Rectangle{
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "darkgrey"
    }

    // background de l'item sélectionné
    highlight: Rectangle{
        Layout.fillWidth: true
        color: TiStyle.highlightBackgroundColor
    }


    // le delegate pour afficher la ListModel dans la ListView
    Component{
        id: listDelegate
        Item {
            id: wrapper
            height: 30
            width: parent.width
            // Avec les required properties dans un delegate, on indique qu'il faut utiliser les roles du modèle
            required property string filename
            required property double latitude
            required property double longitude
            required property bool hasGPS
            required property bool insideCircle
            required property bool toBeSaved
            required property string city
            required property int index // index is a special role available in the delegate: the row of the item in the model.
            readonly property ListView __lv : ListView.view

            // icone In Circle
            Image {
                id: circleIcon
                anchors.left: parent.left
                visible: insideCircle
                source: "qrc:///Images/circle-red.png"
                height: 24; width: 24;
            }

            // icone Has GPS
            Image {
                id: gpsIcon
                anchors.left: circleIcon.right
                visible: hasGPS
                source: "qrc:///Images/mappin-red.png"
                height: 24; width: 24;
            }

            // Filename de l'image
            Text{
                id: nameText
                anchors.left: gpsIcon.right
                text: filename
                font.pixelSize: 16
                color: toBeSaved ? TiStyle.secondaryTextColor : TiStyle.primaryTextColor
            }

            // Tag City
            Pastille{
                id: cityText
                anchors.left: nameText.right
                anchors.leftMargin: 8
                content: city
                editable: false
                deletable: false
                height: 20
            }

            // Gestion du clic sur un item
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("MouseArea: "+index);
                    __lv.currentIndex = index             // Bouge le highlight dans la ListView
                    // previewImage.imageUrl = imageUrl   // A essayer : creer la propriété correspondante (+ rapide que le proxymodel? )
                    _photoListModel.selectedRow = index   // Actualise le proxymodel
                    tabbedPage.selectedItem = index       // inutile si on utilise le ProxyModel
                    // On envoie les coordonnées pour centrer la carte sur le point selectionné
                    if (hasGPS) {
                        mapTab.new_latitude = latitude
                        mapTab.new_longitude = longitude
                        mapTab.new_coords = !mapTab.new_coords
                    }
                }
            }
        }
    }
}
