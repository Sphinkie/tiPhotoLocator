import QtQuick
import QtQuick.Layouts
import "../Controllers"

/** *************************************************************************************
 * @brief QML: Composition de la page de l'onglet "GPX".
 * |        ToolBarMap       |
 * |     MapView | zone GPX  |
 * *************************************************************************************/
GridLayout {
    property alias mapTools: mapTools
    property alias mapView: mapView

    columnSpacing: 8
    rows: 2 // toolbar et carte/zones
    columns: 2 // carte et zone des tags

    /// Barre d'outils pour la carte, sur toute la largeur (controleur avec vue).
    ToolbarMap {
        id: mapTools
        Layout.columnSpan: 2
        Layout.fillWidth: true
    }

    /// La carte (controleur avec vue).
    MapView {
        id: mapView
        //Layout.rowSpan: 2
        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    /// Zone : Gestion des tracks GPX
    ZoneGpx {
        id: zoneGpx
        Layout.rightMargin: 40
        Layout.fillHeight: true
    }
}
