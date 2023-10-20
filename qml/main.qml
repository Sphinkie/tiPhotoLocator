import QtQuick 2.15
import QtQml.Models 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12
import Qt.labs.settings 1.1

import "./Dialogs"
import "./Components"
import "./Models"
import "./Controllers"

Window {
    id: window
    visibility: "Maximized"
    width: 1200
    height: 800
    visible: true
    color: TiStyle.primaryBackgroundColor
    title: "tiPhotoLocator"

    // ----------------------------------------------------------------
    // Les signaux
    // ----------------------------------------------------------------
    signal append(string filename, string url)
    signal setSelectedItemCoords(double lati, double longi)
    signal savePosition(double lati, double longi)
    signal clearSavedPosition()
    signal applySavedPositionToCoords()
    signal fetchExifMetadata()
    signal saveExifMetadata()
    signal hasPos()

    // ----------------------------------------------------------------
    // Fenetre de dialogue pour selectionner le dossier
    // ----------------------------------------------------------------
    TiFolderDialog { id: folderDialog }
    // ----------------------------------------------------------------
    // Déclaration des popups  // TODO : est-ce le bon endroit ?
    // ----------------------------------------------------------------
    About { id: about }
    Credits { id: creditsPage}
    RescanWarning { id: rescanWarning}
    // ----------------------------------------------------------------
    // Modèles de données: Liste des fichiers du dossier
    // ----------------------------------------------------------------
    ModelFolderList { id: folderListModel }


    // ----------------------------------------------------------------
    // Page principale
    // ----------------------------------------------------------------
    GridLayout
    {
        anchors.fill: parent
        columns: 2
        //        rows: 6

        // --------------------------------- Ligne 0
        // Menu principal
        // ---------------------------------
        TiMenuBar {
            // anchors.fill: parent.width
            id: menuBar
            Layout.row: 0
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.fillWidth: true       // Prend toute la largeur
            Layout.alignment: Qt.AlignTop
        }

        // --------------------------------- Ligne 1
        // Barre d'outils du folder: refresh / reload / rescan / display name
        // ---------------------------------
        TiToolBar_ctrl {
            id: toolBar
            Layout.row: 1
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.fillWidth: true       // Prend toute la largeur
            Layout.margins: 16
        }

        // --------------------------------- Ligne 2
        // Filtres et Onglets
        // ---------------------------------
        Frame {
            id: filterBox
            Layout.row: 2
            Layout.column: 0
            Layout.fillWidth: false
            RowLayout{
                anchors.fill: parent
                CheckBox {
                    id: checkBox1
                    text: qsTr("sans date")
                    // TODO : hint: "Liste des photos sans date"
                }
                CheckBox {
                    id: checkBox2
                    text: qsTr("sans localisation")
                    // TODO : hint: "Liste des photos sans localisation"
                    checked: false
                    onClicked: {
                        // voir exemple https://github.com/KDAB/kdabtv/blob/master/qml-intro/sol-qmlqsortfilterproxymodel/main.qml
                        _cppFilterProxyModel.gpsFilterEnabled = checked; // todo
                    }
                }
                CheckBox {
                    id: checkBox3
                    text: qsTr("subfolders")
                    // TODO : hint: "include subfolders"
                    enabled: false
                }
            }
        }
        TabBar {
            id: bar
            Layout.row: 2
            Layout.column: 1
            Layout.fillWidth: true
            TabButton { text: qsTr("PREVIEW") }
            TabButton { text: qsTr("CARTE")   }
            TabButton { text: qsTr("EXIF/IPTC TAGS") }
        }

        // --------------------------------- Ligne 3
        // ListView des filenames des photos
        // ---------------------------------
        Frame {
            Layout.row: 3
            Layout.column: 0
            Layout.fillWidth: false
            Layout.fillHeight: true
            Layout.preferredHeight: 200
            Layout.preferredWidth: 380
            TiPhotoListview { id: photoListAndDelegate }
        }

        StackLayout {
            id: tabbedPage
            Layout.fillWidth: true
            Layout.row: 3
            Layout.column: 1
            currentIndex: bar.currentIndex
            property int selectedItem: -1   // TODO: encore utile ? Image sélectionnée dans la ListView (sert à toutes les pages de la Tab View) ... sauf PreviewTab pour le moment

            // ------------------ PREVIEW TAB --------------------------
            TiPhotoPreview { id: previewView }

            // ------------------ MAP TAB ------------------------------
            GridLayout {
                id: mapTab
                Layout.fillWidth: true
                // Les coordonnées du point sélectionné
                property double photoLatitude: 0
                property double photoLongitude: 0
                columnSpacing: 8
                rows: 4     // rangées: [toolbar] et [Carte/3 Zones]
                columns: 2  // 2 colonnes: carte et zone des tags

                // Barre d'outils pour la carte (controleur)
                TiMapButtonBar_ctrl {
                    id: mapTools
                    // TODO: comment prendre toute la largeur ?
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                }

                TiMapView {
                    id: mapView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.rowSpan: 3
                }

                // Affichage des infos supplémentaires (coords GPS, etc)
                Zone{
                    Column{
                        spacing: 8
                        Text {
                            text: "Coordonnées GPS: "
                        }
                        Chips {
                            content: mapTab.photoLatitude.toFixed(4) + " Lat "  + ((mapTab.photoLatitude>0) ? "N" : "S")
                            editable: false
                            deletable: true
                            visible: (mapTab.photoLatitude != 0)
                        }
                        Chips {
                            content: mapTab.photoLongitude.toFixed(4) + " Long " + ((mapTab.photoLongitude>0) ? "W" : "E")
                            editable: false
                            deletable: true
                            visible: (mapTab.photoLongitude != 0)
                        }
                    }
                }
                Zone{

                }
                Zone{

                }





            }

            // ------------------ IPTC/EXIF TAGS TAB ----------------------------
            TiPhotoTags {
                id: datesTab
            }
        }
        // --------------------------------- Ligne 4
        // Imagettes
        // ---------------------------------
        TiImagettes{
            Layout.row: 4
            Layout.columnSpan: 2
            Layout.fillWidth: true
        }

        // --------------------------------- Ligne 5
        // Barre de boutons en bas
        // ---------------------------------
        TiBottomToolBar {
            id: bottomToolBar
            Layout.row: 5
            Layout.columnSpan: 2
            Layout.fillWidth: true
        }
    }

    // ----------------------------------------------------------------
    // Les Settings
    // ----------------------------------------------------------------
    Settings {
        id: reglages
        category: "general"
//        property string artistName: "David de Lorenzo"
        }

}



/*##^##
Designer {
    D{i:0;formeditorColor:"#ffffff";formeditorZoom:0.75}
}
##^##*/
