import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.12
import QtPositioning 5.12

// ----------------------------------------------------------------
// Affichage d'une carte OpenStreetMap
// - Map: Donner un id
// - MapItemView: Associer un modele (_selectedPhotoModel). Ce modèle contient les MapItems à afficher sur carte.
//
// Fonctions implémentées:
// - Affiche un marker rouge à l'emplacememnt de la photo(s) présente dans le modèle
// - Recentre la carte chaque fois que l'on selectionne une nouvelle photo
// - Un clic sur la carte change les coords gps de la photo (le curseur est repositionné)
// ----------------------------------------------------------------

Map {
    plugin: mapPlugin
    center: QtPositioning.coordinate(parent.new_latitude, parent.new_longitude)
    zoomLevel: 6
    onMapItemsChanged: {
        // Called every time the maker changes on the map: cad un clic dans la listView
        console.log("onMapItemsChanged: re-center the map");
        center= QtPositioning.coordinate(parent.new_latitude, parent.new_longitude)
    }

    // The MapItemView is used to populate Map with MapItems from a model.
    // The MapItemView type only makes sense when contained in a Map, meaning that it has no standalone presentation.
    MapItemView {
        id: mapitemView
        model: _selectedPhotoModel
        delegate: mapDelegate

        // ------------------------------------------
        // Click sur la carte
        // ------------------------------------------
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Click on the map.");
                var lati = (mapView.toCoordinate(Qt.point(mouse.x,mouse.y)).latitude);
                var longi = (mapView.toCoordinate(Qt.point(mouse.x,mouse.y)).longitude);
                // console.log('latitude  = ' + lati );
                // console.log('longitude = ' + longi);
                // On mémorise les coords du point cliqué dans les properties du parent
                mapTab.new_latitude = lati;
                mapTab.new_longitude= longi;
                // On change les coordonnées dans l'item du modele
                window.setSelectedItemCoords(lati, longi);
            }
        }
    }


    // ------------------------------------------
    // Le delegate pour afficher le Marker dans la MapView
    // ------------------------------------------
    Component{
        id: mapDelegate
        // Affichage d'une icone avec sous-titre
        MapQuickItem{
            // Avec les required properties dans un delegate, on indique qu'il faut utiliser les roles du modèle
            required property string filename
            required property double latitude
            required property double longitude
            required property bool hasGPS
            required property bool isMarker
            // Position du maker
            coordinate: QtPositioning.coordinate(latitude, longitude)
            // Point d'ancrage de l'icone
            anchorPoint.x: markerIcon.width * 0.5
            anchorPoint.y: markerIcon.height + markerText.height
            // On dessine le marker et le texte (si la photo possede des coordonnées GPS)
            sourceItem: Column {
                visible: hasGPS
                Text { id: markerText; text: isMarker? " " : filename; font.bold: true } // pas vide, sinon hauteur_texte=0
                Image {
                    id: markerIcon;
                    source: isMarker ? "qrc:///Images/mappin-yellow.png" : "qrc:///Images/mappin-red.png";
                    height: 48; width: 48
                }
            }
        }
    }

    Plugin{
        id: mapPlugin
        name: "osm"
        // parametres optionels
        // PluginParameter{ name: "" ; value: ""}
        // TODO : ajouter la KEY API
    }

}
