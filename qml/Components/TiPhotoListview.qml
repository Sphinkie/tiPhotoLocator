import QtQuick
import QtQuick.Layouts



// https://www.youtube.com/watch?v=ZArpJDRJxcI

ListView{
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
            required property string city
            required property double latitude
            required property double longitude
            required property bool hasGPS
            required property bool insideCircle
            required property bool toBeSaved
            required property bool isMarker
            required property int index // index is a special role available in the delegate: the row of the item in the model.
            readonly property ListView __lv : ListView.view

            visible: !isMarker    // On n'affiche pas la "Saved Position"

            // icone "In Circle"
            Image {
                id: circleIcon
                anchors.left: parent.left
                visible: insideCircle
                source: "qrc:///Images/circle-red.png"
                height: 24; width: 24;
            }

            // icone "Has GPS"
            Image {
                id: gpsIcon
                anchors.left: circleIcon.right
                visible: hasGPS
                source: "qrc:///Images/mappin-red.png"
                height: 24; width: 24;
            }

            // Filename de l'image
            Text {
                id: nameText
                anchors.left: gpsIcon.right
                text: filename
                font.pixelSize: 16
                color: toBeSaved ? TiStyle.accentTextColor : TiStyle.primaryTextColor
            }

            // Tag City
            SimpleChip {
                id: cityText
                anchors.left: nameText.right
                anchors.leftMargin: 8
                content: city
                editable: false
                deletable: false
                height: 20
            }

            // Gestion du clic sur un item
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("MouseArea: clic sur " + index);
                    __lv.currentIndex = index             // Bouge le highlight dans la ListView
                    _photoListModel.selectedRow = index   // Actualise le proxymodel

                    // Envoie au parent les data de l'item selectionné du modèle.
                    // Cela permet de se passer de ProxyModel dans les onglets qui n'utilisent les data que d'un seul item.
                    tabbedPage.selectedItem = index
                    tabbedPage.selectedData = _photoListModel.get(index)

                    // On envoie les coordonnées pour centrer la carte sur le point selectionné
                    mapTab.photoLatitude = hasGPS? latitude : 0
                    mapTab.photoLongitude = hasGPS? longitude : 0

                    // On change le filtrage des suggestions
                    window.setFilterRegularExpression("^"+index)
                    window.setPhotoFilter(index)

                    // On active (ou pas) le bouton "Save position"
                    mapTools.bt_save_pos.enabled = hasGPS;
                    mapTools.bt_clear_coords.enabled = hasGPS;
                    mapTools.slider_radius.enabled = hasGPS;
                }
            }
        }
    }
}
