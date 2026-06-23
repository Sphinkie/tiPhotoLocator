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
 *   - le delegate markerDelegate affiche un marker rouge à l'emplacement de la photo courante.
 *   - le delegate affiche un marker jaune à l'emplacement de la SavedPos.
 *   - le delegate affiche un marker gris à l'emplacement de chaque photo sélectionnée.
 * ***********************************************************************************************************/
Map {
    // Position initiale de la carte
    center: homeCoords
    zoomLevel: 6
    plugin: mapPlugin

    /** ******************************************************************************************************
     * Les différentes cartes supportées par le plugin OSM:
       - 0 Street Map        (Street map view)
       - 1 Cycle Map         (Cycle map view)
       - 2 Transit Map       (Public transit map view in daylight mode)
       - 3 Night Transit Map (Public transit map view in night mode)
       - 4 Terrain Map       (Terrain map view)
       - 5 Hiking Map        (Hiking map view)
       - 6 Custom URL Map    (Thunderforest)
    * ********************************************************************************************************/
    readonly property var mapProviderIndices: [0, 4, 6]
    activeMapType: supportedMapTypes[mapProviderIndices[settings.value("mapProvider", 2)]]

    property alias mapCircle: mapCircle
    /// Position d'accueil de la carte, lue depuis les Settings (Paris par défaut).
    /// Nota: settings est déclaré plus bas, mais accessible ici car les bindings QML sont évalués après la création de tous les objets du composant.
    property var homeCoords: QtPositioning.coordinate(settings.value("homeLatitude", 48.8529), settings.value("homeLongitude", 2.35005))

    DragHandler {
        id: drag
        target: null
        onTranslationChanged: delta => parent.pan(-delta.x, -delta.y)
    }
    // true : zoom centré sur le curseur / false : zoom centré sur la carte
    readonly property bool zoomTowardsCursor: true

    WheelHandler {
        id: wheel
        acceptedDevices: PointerDevice.Mouse
        rotationScale: 1 / 60
        property: parent.zoomTowardsCursor ? "" : "zoomLevel"
        onWheel: event => {
            if (!parent.zoomTowardsCursor)
                return;
            var zoomDelta = event.angleDelta.y / 480; // ~0.25 par cran de molette
            var mousePos = Qt.point(event.x, event.y);
            var mouseCoord = parent.toCoordinate(mousePos);
            parent.zoomLevel = Math.max(parent.minimumZoomLevel, Math.min(parent.maximumZoomLevel, parent.zoomLevel + zoomDelta));
            var newPos = parent.fromCoordinate(mouseCoord, false);
            parent.pan(newPos.x - mousePos.x, newPos.y - mousePos.y);
        }
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
                console.log("Click on the map.");
                var mousePos = Qt.point(mouse.x, mouse.y);
                var mouseCoords = mapView.toCoordinate(mousePos);
                // console.log(mousePos, mouseCoords);
                // On change les coordonnées de la photo dans le modele
                _photoModel.setSelectedItemsCoords(mouseCoords);
                // On repositionne le cercle
                mapCircle.center = mouseCoords;
                // Debug : Affiche la liste des cartes supportées
                console.log(mapView.supportedMapTypes);
            }
        }
    }

    /** ******************************************************************************************************
     * Croix rouge fixe au centre de la carte (repère visuel).
     * *******************************************************************************************************/
    Item {
        anchors.centerIn: parent
        width: 20
        height: 20
        Rectangle {
            anchors.centerIn: parent
            width: 20
            height: 2
            color: "red"
        }
        Rectangle {
            anchors.centerIn: parent
            width: 2
            height: 20
            color: "red"
        }
    }

    /** ******************************************************************************************************
     * @brief Appelé quand des markers apparaissent ou disparaissent de la carte
     * (chargement d'un nouveau dossier, modification de coordonnées GPS, sélection d'une photo avec coords GPS,
     * selection d'une photo sans coords GPS ce qui efface le marker...).
     * Le recentrage est géré par onFirstCoordsReady =>
     * ici on se contente de rafraîchir homeCoords (default values = Paris).
     * *******************************************************************************************************/
    onMapItemsChanged: {
        // console.log("-> Signal onMapItemsChanged received")
        homeCoords = QtPositioning.coordinate(settings.value("homeLatitude", 48.8529), settings.value("homeLongitude", 2.35005));
    }

    /* *******************************************************************************************************
     * Slots pour PhotoModel.
     * *******************************************************************************************************/
    Connections {
        target: _photoModel

        /// @brief Recentre la carte après avoir lu les Exif de la première photo de la liste.
        function onFirstCoordsReady() {
            if (_photoModel.currentItemHasGPS) {
                // console.log("onFirstCoordsReady: ", _photoModel.currentItemCoords)
                // On repositionne la carte sur ces coords
                mapView.center = _photoModel.currentItemCoords;
                // On repositionne le cercle
                mapCircle.center = _photoModel.currentItemCoords;
            } // Si pas de coordonnées pour la première photo, on remet la carte en position "home"
            else {
                mapView.center = homeCoords;
            }
        }
    }

    /* *******************************************************************************************************
     * Slots pour Suggestion Model.
     * *******************************************************************************************************/
    Connections {
        target: _geocodeWrapper

        /// @brief Recentre la carte sur les coordonnées fournies.
        function onCenterMap(coord) {
            console.log("onCenterMap: ", coord);
            mapView.center = coord;
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
            required property bool isCurrent
            required property bool isOnTrack
            required property double onTrackLatitude
            required property double onTrackLongitude
            // Position : coordonnées GPS interpolées si on-track, coordonnées réelles sinon
            coordinate: isOnTrack ? QtPositioning.coordinate(onTrackLatitude, onTrackLongitude) : QtPositioning.coordinate(latitude, longitude)
            // Point d'ancrage de l'icone p/r aux coordinates
            anchorPoint.x: markerIcon.width * 0.5
            anchorPoint.y: markerIcon.height + markerText.height
            // On dessine le marker et le texte (si la photo possede des coordonnées GPS)
            sourceItem: Column {
                visible: hasGPS || isOnTrack
                Text {
                    id: markerText
                    text: isMarker ? " " : filename
                    font.bold: true
                } // pas vide, sinon hauteur_texte=0
                Image {
                    id: markerIcon
                    height: isMarker ? 40 // Le marker "saved position" est plus petit que les autres
                    : isCurrent ? 48 // La photo sélectionnée est plus grosse pour être toujours visible
                    : 44             // Les autres sont légèrement plus petites
                    width: height
                    source: isMarker ? "qrc:///Images/mappin-yellow.png" // le marker est jaune
                    : (isCurrent && hasGPS) ? "qrc:///Images/mappin-red.png"         // Photo courante classique
                    : (isCurrent && !hasGPS) ? "qrc:///Images/pin-red.png"           // Photo courante de la track (avant apply)
                    : (isOnTrack && hasGPS) ? "qrc:///Images/mappin-green.png"       // Photo selectionnée de la track (après apply)
                    : (isOnTrack && !hasGPS) ? "qrc:///Images/pin-green.png"         // Photo selectionnée de la track (avant apply)
                    : "qrc:///Images/mappin-black.png"                               // Photo selectionnée (hors track et non current)
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
     *
     * @note On définit les paramètres ainsi : PluginParameter{ name: "" ; value: ""}
     *
     * @note: Thunderforest fournit des tuiles raster — des images PNG pré-rendues côté serveur.
     * Les noms de villes sont gravés dans l'image au moment du rendu, en utilisant le champ OSM name (langue locale).
     * Il n'existe pas de paramètre d'URL pour choisir la langue.
     * Le locales: ["fr_FR", "en_US"] dans Plugin n'affecte que les appels de géocodage, pas les tuiles.
     *
     * Pour controler la langue des labels plus précisement, il faudrait passer à un fournisseur de tuiles vectorielles (Mapbox, MapTiler, etc.)
     * qui permet de choisir la langue du rendu (name:fr).
     * Mais c'est un refactoring important — Qt Location supporte les tuiles vectorielles depuis Qt 6.5 via le plugin maplibre.
     * *******************************************************************************************************/
    Plugin {
        id: mapPlugin
        name: "osm"
        locales: ["fr_FR", "en_US"]
        readonly property string thunder_url: "https://tile.thunderforest.com/"
        readonly property string thunder_type: settings.value("mapTheme", "outdoors")

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
