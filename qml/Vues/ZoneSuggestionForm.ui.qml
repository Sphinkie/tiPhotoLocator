import QtQuick
import QtQuick.Layouts
import "../Components"

Zone{
    id: suggestionZone
    color: TiStyle.suggestionBackgroundColor
    iconZone: "qrc:/Images/suggestion.png"
    txtZone: qsTr("Suggestions basées sur la position GPS de la photo, grace au service gratuit et opensource OpenStreetMap.\nLimité à 100 requètes par jour.")
    Layout.fillHeight: true

    ListView{
        id: suggestionListView
        anchors.fill: parent
        model: _suggestionProxyModel
        delegate: suggestionDelegate
        focus: true
        clip: true   // pour que les items restent à l'interieur de la listview
    }

    ColumnLayout {

        //ListView{
        //    id: suggestionListView
        //    anchors.fill: parent
        //    model: _suggestionProxyModel
        //    delegate: suggestionDelegate
        //    focus: true
        //    clip: true   // pour que les items restent à l'interieur de la listview

        // le delegate pour afficher un item dans la ListView
        Component{
            id: suggestionDelegate

            //        Item {
            //            width: parent.width
            //            height: 40
            //            required property string text
            //            required property string target
            Chips {
                // Avec les required properties dans un delegate, on indique qu'il faut utiliser les roles du modèle
                required property string text
                required property string target
                content: text + " (" + target + ")"
                editable: false
                deletable: true
            }
            //                }
            /*
                // Gestion du clic sur un item
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("MouseArea: "+index);
                        __lv.currentIndex = index             // Bouge le highlight dans la ListView
                        _photoListModel.selectedRow = index   // Actualise le proxymodel

                        // Envoie au parent les data de l'item selectionné du modèle.
                        // Cela permet de se passer de ProxyModel dans les onglets qui n'utilisent les data que d'un seul item.
                        tabbedPage.selectedItem = index
                        tabbedPage.selectedData = _photoListModel.get(index)

                        // On envoie les coordonnées pour centrer la carte sur le point selectionné
                        mapTab.photoLatitude = hasGPS? latitude : 0
                        mapTab.photoLongitude = hasGPS? longitude : 0
                    }
                } */
        }
    }
}

