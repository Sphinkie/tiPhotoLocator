import QtQuick
import QtQuick.Layouts

            GridLayout {
                // Les coordonnées du point sélectionné
                // Actualisé lors d'un clic sur la listView, ou sur la carte.
                property point homeCoords
                //property double photoLatitude: settings.homeCoords.x
                //property double photoLongitude: settings.homeCoords.y
                property double photoLatitude: homeCoords.x
                property double photoLongitude: homeCoords.y
                columnSpacing: 8
                rows: 3 // toolbar et carte/zones
                columns: 2 // carte et zone des tags
                // T T
                // M Z1
                // M Z2

                // Barre d'outils pour la carte (controleur)
                ToolBarMap {
                    id: mapTools
                    Layout.columnSpan: 2 // Toute la largeur
                    Layout.fillWidth: true
                }

                TiMapView {
                    id: mapView
                    Layout.rowSpan: 2 // Haute comme 2 zones
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                // Affichage des infos supplémentaires (coords GPS, etc)
                ZoneGeoloc {
                    Layout.rightMargin: 40
                    Layout.fillHeight: true
                }
                ZoneSuggestion {
                    id: zoneSuggestionGeo
                    Layout.rightMargin: 40
                    Layout.fillHeight: true
                }
            }