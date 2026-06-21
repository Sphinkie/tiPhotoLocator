import QtQuick
import QtQuick.Layouts
import QtLocation
import ".."
import "../Vues"
import "../Controllers"

/** *************************************************************************************
 * @brief QML: Composition de la page de l'onglet "GPS LOGGER".
 * |        ToolBarGpx       |
 * |     MapView | zone GPX  |
 * *************************************************************************************/
GridLayout {
    property alias mapTools: gpxTools
    property alias mapView: mapView

    columnSpacing: 8
    rows: 2 // toolbar et carte/zones
    columns: 2 // carte et zone des tags

    /// Barre d'outils pour la carte, sur toute la largeur (controleur avec vue).
    ToolbarGpx {
        id: gpxTools
        Layout.columnSpan: 2
        Layout.fillWidth: true
    }

    /// La carte (controleur avec vue).
    MapView {
        id: mapView
        Layout.fillWidth: true
        Layout.fillHeight: true

        /// Tracé du fichier GPX sélectionné.
        MapPolyline {
            id: gpxPolyline
            visible: _gpxModel.currentTrackPoints.length > 0
            line.width: 3
            line.color: Style.chipDirtyColor // accentColor // chipDirtyColor // chipGeoColor
            path: _gpxModel.currentTrackPoints
        }

        /// Recentre la carte sur le premier point du tracé dès qu'il change.
        Connections {
            target: _gpxModel
            function onCurrentTrackPointsChanged() {
                const pts = _gpxModel.currentTrackPoints;
                if (pts.length > 0)
                    mapView.center = pts[0];
            }
        }
    }

    /// Zone : Gestion des tracks GPX
    ZoneGpx {
        id: zoneGpx
        Layout.rightMargin: 40
        Layout.fillHeight: true
    }
}
