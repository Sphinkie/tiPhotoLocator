import QtQuick
import QtQuick.Layouts
import "../Controllers"


/** *************************************************************************************
 * @brief QML: Composition de la page de l'onglet "MAP".
 * [ ToolBar de Map     ]
 * |     Map     |[zone1]
 * |             |[zone2]
 * *************************************************************************************/
GridLayout {
    // Les coordonnées du point sélectionné
    // Actualisé lors d'un clic sur la listView par activatePhoto(), ou sur la carte.
    // homeCoords est mémorisé dans les settings : POUR ???
    property point homeCoords
    property alias mapTools: mapTools
    property alias mapView: mapView

    columnSpacing: 8
    rows: 3 // toolbar et carte/zones
    columns: 2 // carte et zone des tags

    /// Barre d'outils pour la carte sur toute la largeur (controleur avec vue).
    ToolBarMap {
        id: mapTools
        Layout.columnSpan: 2
        Layout.fillWidth: true
    }

    /// La carte est haute comme deux zones (controleur avec vue).
    TiMapView {
        id: mapView
        Layout.rowSpan: 2
        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    /// Zone 1: Affichage des infos supplémentaires (coords GPS, etc)
    ZoneGeoloc {
        Layout.rightMargin: 40
        Layout.fillHeight: true
    }

    /// Zone 2: Affichage du bouton "chercher" et des suggestions.
    ZoneSuggestedLocations {
        id: zoneSuggestedLocations
        Layout.rightMargin: 40
        Layout.fillHeight: true
    }
}
