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
    title: "tiPhotoLocator"
    visible: true
    visibility: "Maximized"
    // dimensions si on démaximise
    width: 1920
    height: 1080
    // dimensions minimales
    minimumHeight: 640
    minimumWidth: 1200
    color: TiStyle.primaryBackgroundColor

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

    // Ligne 0 --------------------------------------------------------
    // Menu principal (Prend toute la largeur)
    // ----------------------------------------------------------------
    TiMenuBar {
        id: menuBar
        anchors {top: parent.top; left: parent.left; right: parent.right;}
    }

    // Ligne 1 --------------------------------------------------------
    // Barre d'outils du folder: refresh / reload / rescan / foldername
    // ----------------------------------------------------------------
    TiToolBar_ctrl {
        id: toolBar
        width: parent.width
        anchors {top: menuBar.bottom; left: parent.left}
    }

    // Ligne 2 --------------------------------------------------------
    // Filtres et Onglets
    // ----------------------------------------------------------------
    Rectangle {
        id:filtersAndTabsBar
        anchors.top: toolBar.bottom
        color: TiStyle.surfaceContainerColor
        width: parent.width
        height: filtersAndTabslayout.height

        RowLayout{
            id: filtersAndTabslayout
            anchors {left: parent.left; right: parent.right;}
            CheckBox {
                Layout.leftMargin: 20
                id: checkBox1
                text: qsTr("sans date")
                // TODO : hint: "Liste des photos sans date"
            }
            CheckBox {
                Layout.leftMargin: 20
                id: checkBox2
                text: qsTr("sans localisation")
                // TODO : hint: "Liste des photos sans localisation"
                checked: false
                onClicked: {
                    // voir exemple https://github.com/KDAB/kdabtv/blob/master/qml-intro/sol-qmlqsortfilterproxymodel/main.qml
                    _cppFilterProxyModel.gpsFilterEnabled = checked; // todo
                }
            }

            TabBar {
                id: bar
                Layout.leftMargin: 120
                Layout.fillWidth: true
                Layout.rightMargin: 40
                TabButton { text: qsTr("PREVIEW") }
                TabButton { text: qsTr("CARTE")   }
                TabButton { text: qsTr("EXIF/IPTC TAGS") }
            }
        }
    }

    // Ligne 3 --------------------------------------------------------
    // ListView des filenames des photos + page de contenu de l'onglet
    // ----------------------------------------------------------------
    RowLayout{
        anchors {top: filtersAndTabsBar.bottom; bottom: imagettes.top; left: parent.left; right: parent.right;}

        Frame {
            id: listViewFrame
            Layout.fillWidth: false
            Layout.fillHeight: true
            Layout.preferredHeight: 200
            Layout.preferredWidth: 380
            TiPhotoListview { id: photoListAndDelegate }
        }

        StackLayout {
            id: tabbedPage
            Layout.fillWidth: true
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
                rows: 4     // toolbar et carte/zones
                columns: 2  // carte et zone des tags
                // T T
                // M Z1
                // M Z2
                // M Z3
                // Barre d'outils pour la carte (controleur)
                TiMapButtonBar_ctrl {
                    id: mapTools
                    Layout.columnSpan: 2  // Toute la largeur
                    Layout.fillWidth: true
                }

                TiMapView {
                    id: mapView
                    Layout.rowSpan: 3         // Haute comme 3 zones
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                // Affichage des infos supplémentaires (coords GPS, etc)
                Zone{
                    Layout.rightMargin: 40
                    Layout.fillHeight: true
                    icon: "qrc:/Images/world.png"

                    ColumnLayout{
                        spacing: 8
                        Text {
                            Layout.topMargin: 20
                            Layout.leftMargin: 10
                            text: "Coordonnées GPS: "
                        }
                        Chips {
                            content: mapTab.photoLatitude.toFixed(4) + " Lat "  + ((mapTab.photoLatitude>0) ? "N" : "S")
                            Layout.leftMargin: 20
                            editable: false
                            deletable: true
                            visible: (mapTab.photoLatitude != 0)
                        }
                        Chips {
                            content: mapTab.photoLongitude.toFixed(4) + " Long " + ((mapTab.photoLongitude>0) ? "W" : "E")
                            Layout.leftMargin: 20
                            editable: false
                            deletable: true
                            visible: (mapTab.photoLongitude != 0)
                        }
                    }
                }
                Zone{
                    Layout.rightMargin: 40
                    Layout.fillHeight: true
                    color: "lightblue"
                    icon: "qrc:/Images/suggestion.png"
                }
                Zone{
                    Layout.rightMargin: 40
                    Layout.fillHeight: true
                    color: "lightgrey"
                    icon: "qrc:/Images/trashcan.png"
                }
            }

            // ------------------ IPTC/EXIF TAGS TAB ----------------------------
            TiPhotoTags {
                id: datesTab
            }
        }
    }

    // --------------------------------- Ligne 4
    // Imagettes
    // ----------------------------------------------------------------
    TiImagettes{
        id: imagettes
        //            Layout.row: 4
        //          Layout.columnSpan: 2
        //        Layout.fillWidth: true
        height: 120
        anchors {bottom: bottomToolBar.top; left: parent.left; right: parent.right; }
    }

    // --------------------------------- Ligne 5
    // Barre de boutons en bas
    // ----------------------------------------------------------------
    TiBottomToolBar {
        id: bottomToolBar
        //      Layout.row: 5
        //    Layout.columnSpan: 2
        //  Layout.fillWidth: true
        anchors.bottom: parent.bottom
        width: parent.width
    }
    //    }

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
