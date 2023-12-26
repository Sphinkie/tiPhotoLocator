import QtQuick
import QtQuick.Layouts

// https://www.youtube.com/watch?v=ZArpJDRJxcI

ListView{
    id: photoListAndDelegate
    anchors.fill: parent
    model: _unlocalizedProxyModel  // Activation de la checkbox "has GPS"
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

    Timer {
        id: geoTimer
        interval: 5000;   // 5 sec
        running: false;
        repeat: false;
        onTriggered: {
            // Envoie une request pour récupérer des infos à partir des coords GPS
            console.debug(">>>>> timer triggered");
            window.requestReverseGeocode(mapTab.photoLatitude, mapTab.photoLongitude);
        }
    }


    // le delegate pour afficher la ListModel dans la ListView
    Component{
        id: listDelegate
        Item {
            id: wrapper
            height: 30
            width: photoListAndDelegate.width
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
            TinyChip {
                id: cityText
                anchors.left: nameText.right
                anchors.leftMargin: 8
                content: city
                editable: false
                deletable: false
                height: 20
            }


            // Gestion du clic sur un item de la liste
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("MouseArea: clic sur " + index);
                    __lv.currentIndex = index;              // Bouge le highlight dans la ListView
                    var sourceindex = model.getSourceIndex(index);
                    _photoModel.selectedRow = sourceindex;  // Actualise le PhotoModel

                    // On mémorise dans selectedData les data de l'item selectionné du modèle.
                    // Cela permet de se passer de ProxyModel dans les onglets qui n'utilisent les data que d'un seul item.
                    tabbedPage.selectedData = _photoModel.get(sourceindex);

                    // On envoie les coordonnées pour centrer la carte sur le point selectionné
                    if (hasGPS) {
                        mapTab.photoLatitude = latitude;
                        mapTab.photoLongitude = longitude;
                    }
                    // sinon: la position de la carte reste inchangée

                    // On change le filtrage des suggestions pour filtrer uniquement sur la photo active
                    window.setSuggestionFilter(sourceindex);

                    // On remet le rayon du cercle rouge de la carte à zéro
                    // mapTools.slider_radius.value = 0;
                    // On réactualise le contenu du cercle rouge
                    _photoModel.findInCirclePhotos(mapTools.slider_radius.value);

                    // On relance une demande d'infos ReverseGeo
                    if ( (tabbedPage.currentIndex === 1) && hasGPS) {
                        // Si onglet CARTE et COORDS GPS:
                        console.debug(">>>> restart timer");
                        geoTimer.restart();
                    }
                    else
                        geoTimer.stop();

                }
            }
        }
    }
}
