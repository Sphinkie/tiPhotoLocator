import QtQuick
import QtQuick.Layouts
import "../Controllers"


/** *************************************************************************************
 * @brief Composition de la page de l'onglet "MAP".
 * [ ToolBar de Map     ]
 * |     Map     |[zone1]
 * |             |[zone2]
 * *************************************************************************************/
GridLayout {
    // Les coordonnées du point sélectionné
    // Actualisé lors d'un clic sur la listView, ou sur la carte.
    property point homeCoords
    //property double photoLatitude: settings.homeCoords.x
    //property double photoLongitude: settings.homeCoords.y
    property double photoLatitude: homeCoords.x
    property double photoLongitude: homeCoords.y
    property alias mapTools: mapTools

    columnSpacing: 8
    rows: 3 // toolbar et carte/zones
    columns: 2 // carte et zone des tags

    /// Barre d'outils pour la carte sur toute la largeur (controleur avec vue).
    ToolBarMap {
        id: mapTools
        Layout.columnSpan: 2
        Layout.fillWidth: true
    }

    /// La carte haute comme deux zones (controleur avec vue).
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
