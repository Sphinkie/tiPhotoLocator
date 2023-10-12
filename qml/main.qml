import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12
//import Qt.labs.platform 1.1
import QtQml.Models 2.15

import "./Dialogs"
import "./Components"
import "./Models"

Window {
    id: window
    visibility: "Maximized"
    width: 1200
    height: 800
    visible: true
    color: TiStyle.primaryBackgroundColor
    title: "tiPhotoLocator"
    // Les signaux
    signal qmlSignal(double lati, double longi)
    signal savePosition(double lati, double longi)
    signal append(string filename, string url)
    signal fetchExifMetadata()
    signal saveExifMetadata()

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
        TiToolBar {
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
            Layout.row: 3
            Layout.column: 1
            currentIndex: bar.currentIndex
            property int selectedItem: -1   // Image sélectionnée dans la ListView (sert à toutes les pages de la Tab View) ... sauf PreviewTab pour le moment
            onSelectedItemChanged: {
                /*
                // mapTab.pLatitude = _photoListModel.get(selectedItem).latitude
                mapTab.pLatitude = _photoListModel.data(selectedItem,"latitude")
                mapTab.pLongitude = _photoListModel.data(selectedItem,"longitude")
                // On ajoute l'image sélectionnée aux pins à afficher sur la carte
                mappinModel.append({"name": _photoListModel.data(selectedItem,"filename"),
                                       "latitude": mapTab.pLatitude,
                                       "longitude": mapTab.pLongitude})
                */
            }

            // ------------------ PREVIEW TAB --------------------------
            TiPhotoPreview { id: previewView }

            // ------------------ MAP TAB ------------------------------
            ColumnLayout {
                id: mapTab
                anchors.fill: parent
                // TODO : Nettoyer
                // Les coordonnées du point sélectionné
                property double new_latitude
                property double new_longitude
                property bool   new_coords: false
                spacing: 8
                Layout.alignment: Qt.AlignHCenter
                // Layout.fillWidth: true
                onNew_coordsChanged: {
                    // Centrage de la carte sur les nouvelles coordonnées
                    // console.log("NewCoords: re-center the map");
                    // mapView.center = QtPositioning.coordinate(new_latitude, new_longitude)  TODO A enlever si inutile
                }

                // Barre d'outils pour la carte
                TiToolMap{
                    id: mapTools
                    Layout.fillWidth: true
                }

                // Affichage de la carte
                TiPhotoMap{
                    id: mapView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                ListView{
                    id: coordsTextView
                    model: _selectedPhotoModel
                    delegate: coordsTextDelegate
                }

                Component{
                    id: coordsTextDelegate
                    Text {
                        required property double latitude
                        required property double longitude
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignBottom
                        text: "Coordinates: " + latitude.toFixed(4) + " [LatN] / " + longitude.toFixed(4) + " [longW]"
                        font.pixelSize: 16
                    }
                }
            }


            // ------------------ TAGS TAB ----------------------------
            TiPhotoTags {
                id: datesTab
                anchors.fill: parent
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
            Layout.row: 5
            Layout.columnSpan: 2
            Layout.fillWidth: true
        }
    }
}



/*##^##
Designer {
    D{i:0;formeditorColor:"#ffffff";formeditorZoom:0.75}
}
##^##*/
