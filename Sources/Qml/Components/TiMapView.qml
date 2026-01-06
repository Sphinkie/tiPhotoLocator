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
    property alias mapCircle: mapCircle
    zoomLevel: 6
    plugin: mapPlugin
    center: _photoModel.selectedCoords

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
        console.log("onMapItemsChanged")
        // console.log(": re-center the map on selectedCoords", _photoModel.selectedCoords)
        // On repositionne la carte sur les coords de la photo sélectionée
        mapView.center = _photoModel.selectedCoords
        // On repositionne le cercle
        mapCircle.center = _photoModel.selectedCoords
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
            console.log("onFirstCoordsReady: ", _photoModel.selectedCoords)
            // On repositionne la carte sur ces coords
            mapView.center = _photoModel.selectedCoords
            // On repositionne le cercle
            mapCircle.center = _photoModel.selectedCoords
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


    /* supportedMapTypes
        0 Street Map        (Street map view in daylight mode)
        1 Cycle Map         (Cycle map view in daylight mode)
        2 Transit Map       (Public transit map view in daylight mode)
        3 Night Transit Map (Public transit map view in night mode)
        4 Terrain Map       (Terrain map view)
        5 Hiking Map        (Hiking map view)
        6 Custom URL Map    (Custom url map view set via urlprefix parameter)
    */
    activeMapType: supportedMapTypes[0] // ou 4

    Plugin {
        id: mapPlugin
        name: "osm"
        property string apikey

        locales: ["fr_FR", "en_US"]

        // parametres optionels : PluginParameter{ name: "" ; value: ""}
        // PluginParameter { name: "osm.mapping.providersrepository.address"; value: "http://www.mywebsite.com/osm_repository" }
        // PluginParameter { name: "osm.mapping.providersrepository.address"; value: "https://tile.thunderforest.com/transport-dark/{z}/{x}/{y}.png?apikey="+apikey}
        // PluginParameter { name: "osm.mapping.custom.host"; value: "http://a.tile.thunderforest.com/cycle/%z/%x/%y.png?apikey="+apikey}
        // PluginParameter { name: "osm.mapping.custom.host"; value: "https://tile.thunderforest.com/cycle/%z/%x/%y.png?apikey="+apikey}
        // PluginParameter { name: "osm.mapping.custom.host"; value: "http://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey="+apikey}
        PluginParameter {
            name: "osm.mapping.custom.host"
            readonly property url thunderurl: "https://tile.thunderforest.com/cycle/%z/%x/%y.png"
            readonly property string thunderkey: (mapPlugin.apikey ? "?apikey="
                                                                     + mapPlugin.apikey : "")
            value: thunderurl // + thunderkey;
        }

        PluginParameter {
            // obsolete ?
            name: "osm.mapping.providersrepository.address"
            readonly property url thunderurl: "https://tile.thunderforest.com/cycle/%z/%x/%y.png"
            readonly property string thunderkey: (mapPlugin.apikey ? "?apikey="
                                                                     + mapPlugin.apikey : "")
            value: thunderurl // + thunderkey;
        }

        //PluginParameter { name: "osm.mapping.highdpi_tiles"; value: "false" }
        //PluginParameter { name: "osm.mapping.providersrepository.disabled"; value: "false" }


        /* Matthas Rauter (nov-2023) Qt Company - Fixed in Qt 6.7

        https://bugreports.qt.io/browse/QTBUG-115742

            So the only way I see to add this APIKEY parameter is to make it only work with Thunderforest
            (by adding "apikey=" and whatever key the user entered to the URL) or to do some find-and-replace magic on the URL (by adding "apikey=%APIKEY" to the stored Thunderforest URL,
            replacing %APIKEY with the respective key and removing everything after "?" entirely when no key is provided).
            In my opinion both are worse than the current solution of providing a custom URL that includes the apikey.
            Anyway, I agree that it is not documented properly, so I will add it to the documentation.

        osm.mapping.custom.host
            The url string of a custom tile server. This parameter should be set to a valid server url offering the correct OSM API.
            The postfix "%z/%x/%y.png" will be added to the url. Since 6.5 the postfix will not be added if the url ends with ".png".
            If the server requires an apikey, it has to be added to the url string.
            To use this server, the Map::activeMapType parameter of the Map should be set to the supported map type whose type is \l{mapType::style}{MapType.CustomMap}.
            This map type is only be available if this plugin parameter is set, in which case it is always {Map::supportedMapTypes}[supportedMapTypes.length - 1].
            \note Setting the mapping.custom.host parameter to a new server renders the map tile cache useless for the old custommap style.
        */
    }

    // ----------------------------------------------------------------
    // Lecture des Settings
    // ----------------------------------------------------------------
    Settings {
        id: settings
        property alias mapApikey: mapPlugin.apikey
    }
}
