import QtQuick
import QtCore
import QtLocation
import QtPositioning


/** **********************************************************************************************************
 * @brief Affichage d'une carte OpenStreetMap
 * - Map: Donner un id
 * - MapItemView: Associer un modèle (_selectedPhotoModel) qui contient les MapItems à afficher sur carte.
 *
 * Fonctions implémentées:
 * - Lors d'un clic sur la carte
 *   - MapItemView.MouseArea affecte la position à la photo sélectionnée
 *   - MapItemView.MouseArea repositionne le cercle
 * - Lors du rechargement du dossier
 *   - onMapItemsChanged (non systématique)
 * - Lors du readExif (GPS coords) d'un nouveau dossier
 *   - onFirstCoordsReady
 * - Lors de la sélection d'une photo dans la liste
 *   - le delegate markerDelegate affiche un marker rouge à l'emplacement de la photo
 *   - le delegate affiche un marker jaune à l'emplacement de la SavedPos
 *   - le delegate affiche un marker gris à l'emplacement de chaque photo incluse dans le cercle
 * ***********************************************************************************************************/
Map {
    // Position initiale de la carte
    center: QtPositioning.coordinate(homeCoords.x,
                                     homeCoords.y) // _photoModel.selectedCoords
    zoomLevel: 6
    plugin: mapPlugin


    /* supportedMapTypes
        0 Street Map        (Street map view)
        1 Cycle Map         (Cycle map view)
        2 Transit Map       (Public transit map view in daylight mode)
        3 Night Transit Map (Public transit map view in night mode)
        4 Terrain Map       (Terrain map view)
        5 Hiking Map        (Hiking map view)
        6 Custom URL Map    (Thunderforest)
    */
    activeMapType: supportedMapTypes[6] // 0 ou 4

    property alias mapCircle: mapCircle
    property point homeCoords

    DragHandler {
        id: drag
        target: null
        onTranslationChanged: delta => parent.pan(-delta.x, -delta.y)
    }
    WheelHandler {
        id: wheel
        acceptedDevices: PointerDevice.Mouse
        rotationScale: 1 / 60
        property: "zoomLevel"
    }
    MapCircle {
        id: mapCircle
        radius: mapTools.slider_radius.value // en mètres
        border.color: "red"
        border.width: 3
    }


    /** ******************************************************************************************************
     * The MapItemView is used to populate the Map with MapItems (markers) from the OnTheMapProxyModel content.
     * *******************************************************************************************************/
    MapItemView {
        id: mapItemView
        model: _onTheMapProxyModel // Ce modèle ne contient que les photos devant apparaitre sur la carte
        delegate: markerDelegate


        /** **************************************************************************************************
         * Click sur la carte
         * ***************************************************************************************************/
        MouseArea {
            anchors.fill: parent
            onClicked: mouse => {
                           console.log("Click on the map.")
                           var mousePos = Qt.point(mouse.x, mouse.y)
                           var mouseCoords = mapView.toCoordinate(mousePos)
                           // console.log(mousePos, mouseCoords)
                           // On change les coordonnées de la photo dans le modele
                           _photoModel.selectedCoords = mouseCoords
                           // On repositionne le cercle
                           mapCircle.center = mouseCoords
                           // Debug : Affiche la liste des cartes supportées
                           console.log(mapView.supportedMapTypes)
                       }
        }
    }


    /** ******************************************************************************************************
     * Appelé en cas de changement de la liste des MapItems. Cad:
     * - lors d'un clic dans la listView,
     * - parfois sur un changement des données du modèle, cad une nouvelle liste de photos. (pas toujours)
     *   mais de toutes façon, c'est trop tôt, on a pas encore lu les Exif.
     * *******************************************************************************************************/
    onMapItemsChanged: {
        // console.log("onMapItemsChanged")
        if (_photoModel.selectedItemHasGPS) {
            // console.log(": re-center the map on selectedCoords", _photoModel.selectedCoords)
            // On repositionne la carte sur les coords de la photo sélectionée
            mapView.center = _photoModel.selectedCoords
            // On repositionne le cercle
            mapCircle.center = _photoModel.selectedCoords
        }
        // on lit homeCoords dans les settings
        homeCoords = settings.value("homeCoords")
    }


    /** ******************************************************************************************************
     * Slots.
     * *******************************************************************************************************/
    Connections {
        target: _photoModel


        /** ******************************************************************************************************
         * Appelé après avoir lu les Exif de la première photo de la liste.
         * *******************************************************************************************************/
        function onFirstCoordsReady() {
            if (_photoModel.selectedItemHasGPS) {
                // console.log("onFirstCoordsReady: ", _photoModel.selectedCoords)
                // On repositionne la carte sur ces coords
                mapView.center = _photoModel.selectedCoords
                // On repositionne le cercle
                mapCircle.center = _photoModel.selectedCoords
            } // Si pas de coordonnées pour la première photo, on remet la carte en position "home"
            else {
                mapView.center = QtPositioning.coordinate(homeCoords.x,
                                                          homeCoords.y)
            }
        }
    }


    /** ******************************************************************************************************
     * Le delegate pour afficher un MapItem (le Marker) dans la MapView.
     * *******************************************************************************************************/
    Component {
        id: markerDelegate
        // Affichage d'une icone avec sous-titre
        MapQuickItem {
            // Avec les required properties dans un delegate, on indique qu'il faut utiliser les roles du modèle
            required property string filename
            required property double latitude
            required property double longitude
            required property bool hasGPS
            required property bool isMarker
            required property bool isSelected
            // Position du MapQuickItem (marker) = lat et long de la photo
            coordinate: QtPositioning.coordinate(latitude, longitude)
            // Point d'ancrage de l'icone p/r aux coordinates
            anchorPoint.x: markerIcon.width * 0.5
            anchorPoint.y: markerIcon.height + markerText.height
            // On dessine le marker et le texte (si la photo possede des coordonnées GPS)
            sourceItem: Column {
                visible: hasGPS
                Text {
                    id: markerText
                    text: isMarker ? " " : filename
                    font.bold: true
                } // pas vide, sinon hauteur_texte=0
                Image {
                    id: markerIcon
                    height: isMarker ? 40 // Le marker "saved position" est plus petit que les autres
                                     : isSelected ? 48 // La photo sélectionnée est plus grosse pour être toujours visible
                                                  : 44 // Les autres sont légèrement plus petites
                    width: height
                    source: isMarker ? "qrc:///Images/mappin-yellow.png" // le marker est jaune
                                     : isSelected ? "qrc:///Images/mappin-red.png" // la photo sélectionée est rouge
                                                  : "qrc:///Images/mappin-black.png" // les autres sont en gris
                }
            }
        }
    }


    /** ******************************************************************************************************
     * @brief Plugin OSM pour la carte OpenStreetMap (ou thunderforest).
     * On a 5 types de cartes potables:
     * - 0 : openstreetmap classique
     * - 4 : openstreetmap terrain
     * - 6 + outdoors : thunderforest outdoors
     * - 6 + landscape : thunderforest landscape
     * - 6 + cycle : thunderforest cycle

     * @note On définit les paramètres ainsi : PluginParameter{ name: "" ; value: ""}
     * *******************************************************************************************************/
    Plugin {
        id: mapPlugin
        name: "osm"
        locales: ["fr_FR", "en_US"]
        readonly property string thunder_url: "https://tile.thunderforest.com/"
        readonly property string thunder_type: "landscape"


        /** *******************************************************************************************************
         * @brief Ce paramètre permet de définir un serveur de *map tiles* autre que OpenStreetMap (ici /b thunderforest).
         * Le serveur doit offrir une API compatible avec OSM.
         *
         * @note A postfix "%z/%x/%y.png" will be added to the url, except if the url ends with ".png".
         * If the server requires an apikey, it has to be added to the url string.
         * Exemple: `https://tile.thunderforest.com/landscape/11/940/584.png?apikey=0000000000000000000000000000000`

         * @note To use this custom tile server, the `Map::activeMapType` parameter of the *Map* should be set to **MapType.CustomMap**.
         * (This map type is only be available if this plugin parameter is set).
         * The value is always: *Map::supportedMapTypes[supportedMapTypes.length - 1]*.
         * Exemple: `map.activeMapType: supportedMapTypes[6]`
         *
         * @note: Setting the `osm.mapping.custom.host` parameter to a **new server** renders the map tile cache useless for the old custommap style.
         * *******************************************************************************************************/
        PluginParameter {
            name: "osm.mapping.custom.host"
            readonly property string apikey: settings.value("mapApikey")
            readonly property string thunder_key: (apikey ? "?apikey=" + apikey : "")
            value: mapPlugin.thunder_url + mapPlugin.thunder_type + "/%z/%x/%y.png" + thunder_key
        }

        /// Affichage d'un copyright en bas de la carte
        PluginParameter {
            name: "osm.mapping.custom.mapcopyright"
            value: mapPlugin.thunder_url + mapPlugin.thunder_type
        }

        /// Identification de l'application dans les requetes à Thunderbird
        PluginParameter {
            name: "osm.useragent"
            value: "TiPhotoLocator"
        }


        /* Autres paramètres possibles :
          PluginParameter { name: "osm.mapping.highdpi_tiles";                value: "false" }
          PluginParameter { name: "osm.mapping.providersrepository.disabled"; value: "false" }
          PluginParameter { name: "osm.mapping.providersrepository.address";  value: "?????" }
        */
    }


    /** *******************************************************************************************************
     * Disponibilité des Settings en lecture
     * ********************************************************************************************************/
    Settings {
        id: settings
    }
}
