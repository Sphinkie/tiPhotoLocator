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
    //GridLayout
    //Column
    //{
        //anchors.fill: parent
        // columns: 2
        // rows: 6

        // ------------------------------------------------------ Ligne 0
        // Menu principal (Prend toute la largeur)
        // ------------------------------------------------------
        TiMenuBar {
            id: menuBar
            //Layout.row: 0
            //Layout.column: 0
            //Layout.columnSpan: 2
            //Layout.fillWidth: true
            //Layout.alignment: Qt.AlignTop
            anchors {top: parent.top; left: parent.left; right: parent.right;}
        }

        // ------------------------------------------------------ Ligne 1
        // Barre d'outils du folder: refresh / reload / rescan / display name
        // ------------------------------------------------------
        TiToolBar_ctrl {
            id: toolBar
            //Layout.row: 1
            //Layout.column: 0
            //Layout.columnSpan: 2
            //Layout.fillWidth: true       // Prend toute la largeur
            //Layout.margins: 16
            width: parent.width
            anchors {top: menuBar.bottom; left: parent.left}
        }

        // --------------------------------- Ligne 2
        // Filtres et Onglets
        // ---------------------------------
        Rectangle {
            id:filtersAndTabsBar
            anchors.top: toolBar.bottom
            color: TiStyle.surfaceContainerColor
            width: parent.width
            height: filtersAndTabslayout.height

            RowLayout{
                id: filtersAndTabslayout
                anchors {left: parent.left; right: parent.right;}
                //anchors.fill: parent.width
                //Layout.row: 2
                //Layout.column: 0
                //Layout.fillWidth: false
                //Layout.fillWidth: true
                //  width:                 listViewFrame.width
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
                    //Layout.row: 2
                    //Layout.column: 1
                    Layout.leftMargin: 120
                    Layout.fillWidth: true
                    Layout.rightMargin: 40
                    TabButton { text: qsTr("PREVIEW") }
                    TabButton { text: qsTr("CARTE")   }
                    TabButton { text: qsTr("EXIF/IPTC TAGS") }
                }
            }
        }

        // --------------------------------- Ligne 3
        // ListView des filenames des photos
        // ---------------------------------
        RowLayout{
            anchors {top: filtersAndTabsBar.bottom; bottom: imagettes.top; left: parent.left; right: parent.right;}

            Frame {
               id: listViewFrame
                //Layout.row: 3
                //Layout.column: 0
                Layout.fillWidth: false
                Layout.fillHeight: true
                Layout.preferredHeight: 200
                Layout.preferredWidth: 380
                TiPhotoListview { id: photoListAndDelegate }
            }

            StackLayout {
                id: tabbedPage
                Layout.fillWidth: true
                //Layout.row: 3
                //Layout.column: 1
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
                    rows: 2     // toolbart et carte
                    columns: 2  // carte et zone des tags

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
                    }

                    // Affichage des infos supplémentaires (coords GPS, etc)
                    Zone{
                        Layout.rightMargin: 40
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
                }

                // ------------------ IPTC/EXIF TAGS TAB ----------------------------
                TiPhotoTags {
                    id: datesTab
                }
            }
        }

        // --------------------------------- Ligne 4
        // Imagettes
        // ---------------------------------
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
        // ---------------------------------
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
