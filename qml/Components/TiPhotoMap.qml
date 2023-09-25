import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.12
import QtPositioning 5.12

// ----------------------------------------------------------------
// Affichage d'une carte OpenStreet Map
// - Donner un id
// - Associer un modele au MapItemView (_selectedPhotoModel). Ce modèle contient les MapItems à afficher sur carte.
//   A priori, on en met un seul
//
// Fonctions implémentées:
// - Affiche un marker rouge à l'emplacememnt de la photo(s) présente dans le modèle
// - Recentre la carte chaque fois que l'on selectionne une nouvelle photo
// - Un clic sur la carte change la position de la photo (le curseur est repositionné)
// ----------------------------------------------------------------

Map{
    // id: mapView
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
        signal qmlSignal(double latit)

        // ---------------------------
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Click on the map.");
                var lati = (mapView.toCoordinate(Qt.point(mouse.x,mouse.y)).latitude);
                var longi = (mapView.toCoordinate(Qt.point(mouse.x,mouse.y)).longitude);
                console.log('latitude  = ' + lati );
                console.log('longitude = ' + longi);
                // On mémorise les coords du point dans les properties du parent
                mapTab.new_latitude = lati;
                mapTab.new_longitude= longi;
                // On demande un recentrage de la carte
                // mapTab.new_coords = !mapTab.new_coords;
                // On écrit les coordonnées dans l'item du modele
                _selectedPhotoModel.setCoords(lati, longi);
                // parent.qmlSignal(lati) // marche pas
            }
        }
        // ---------------------------
    }


    Component{
        // Le delegate pour afficher le Marker dans la MapView
        id: mapDelegate
        // Affichage d'un marker avec sous-titre
        MapQuickItem{
            // Avec les required properties dans une delegate, on indique qu'il faut utiliser les roles du modèle
            required property string filename
            required property double latitude
            required property double longitude
            // Position du maker
            coordinate: QtPositioning.coordinate(latitude, longitude)
            // Point d'ancrage de l'icone
            anchorPoint.x: markerIcon.width * 0.5
            anchorPoint.y: markerIcon.height
            // On dessine le marker et le texte
            sourceItem: Column {
                Image { id: markerIcon; source: "qrc:///Images/mappin-red.png"; height: 48; width: 48 }
                Text { text: filename; font.bold: true }
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
