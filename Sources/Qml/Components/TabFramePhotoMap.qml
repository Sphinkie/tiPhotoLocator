import QtQuick
import QtQuick.Layouts
import "../Controllers"


/** *************************************************************************************
 * @brief QML: Composition de la page de l'onglet "MAP".
 * |        ToolBarMap       |
 * |     MapView | zone tags |
 * |             | zone sugg |
 * *************************************************************************************/
GridLayout {
    property alias mapTools: mapTools
    property alias mapView: mapView

    columnSpacing: 8
    rows: 3 // toolbar et carte/zones
    columns: 2 // carte et zone des tags

    /// Barre d'outils pour la carte, sur toute la largeur (controleur avec vue).
    ToolbarMap {
        id: mapTools
        Layout.columnSpan: 2
        Layout.fillWidth: true
    }

    /// La carte est haute comme deux zones (controleur avec vue).
    MapView {
        id: mapView
        Layout.rowSpan: 2
        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    /// Zone 1: Affichage des infos supplémentaires (coords GPS, etc)
    ZoneGeoloc {
        id: zoneGeolocMap
        Layout.rightMargin: 40
        Layout.fillHeight: true
    }

    /// Zone 2: Affichage du bouton "chercher geotags" et des suggestions.
    ZoneSuggestedLocations {
        id: zoneSuggestedLocations
        Layout.rightMargin: 40
        Layout.fillHeight: true
        /// Les chips de cette zone de suggestions ont pour destination le centre/bas de la ZoneGeolocMap
        getCenterForTarget: function (t) {
            return zoneGeolocMap.mapToItem(ghostLayer,
                                           zoneGeolocMap.width * 0.5,
                                           zoneGeolocMap.height * 0.75)
        }
    }
}
