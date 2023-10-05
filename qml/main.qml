import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12
import Qt.labs.platform 1.1
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
    color: "#f7f7f7"
    title: "tiPhotoLocator"
    // Les signaux
    signal qmlSignal(double latit)
    signal scanFile(string str)
    signal append(string filename, string url)
    signal fetchExifMetadata()

    // ----------------------------------------------------------------
    // Fenetre de dialogue pour selectionner le dossier
    // ----------------------------------------------------------------
    TiFolderDialog { id: folderDialog }
    // ----------------------------------------------------------------
    // "About..." window
    // ----------------------------------------------------------------
    AboutPopup { id: about }
    // ----------------------------------------------------------------
    // Modèles de données: Liste des fichiers du dossier
    // ----------------------------------------------------------------
    FolderListModel { id: folderListModel }

    // ----------------------------------------------------------------
    // Page principale
    // ----------------------------------------------------------------
    GridLayout
    {
        anchors.fill: parent
        //        rows: 6
        columns: 2

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
            Layout.margins: 8
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
            TabButton {
                text: qsTr("PREVIEW")
            }
            TabButton {
                text: qsTr("CARTE")
            }
            TabButton {
                text: qsTr("TAG DATES")
            }
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
            //            ColumnLayout {
            //                id: previewTab
            //            anchors.fill: parent

            // TODO : ce tab charge les images même quand il n'est pas visible, ce qui ralenti la GUI
            GridView{
                id: previewView
                model: _selectedPhotoModel      // Ce modèle ne contient que la photo sélectionnée dans la ListView
                delegate: previewDelegate
                clip: true                      // pour que les items restent à l'interieur de la View
                // Layout.fillWidth: true
            }

            Component {
                id: previewDelegate
                Column{
                    Image {
                        id: previewImage
                        //property int clickedItem: -1
                        //                            property url imageURl: "qrc:///Images/kodak.png"
                        Layout.alignment: Qt.AlignCenter
                        Layout.preferredWidth: 600
                        Layout.preferredHeight: 600
                        // On limite la taille de l'image affichée à la taille du fichier (pas de upscale)
                        Layout.maximumHeight: sourceSize.height
                        Layout.maximumWidth: sourceSize.width
                        fillMode: Image.PreserveAspectFit
                        source: model.imageUrl
                        /*                            onClickedItemChanged: {
                                // TODO: comment recupérer les données du modèle quand on est dans une fonction et pas dans un delegate?
                                //      il faut utiliser une méthode...
                                //      ou utiliser des delegate, ce qui semble être la méthode recommandée
                                //
                                // console.log("onClickedItemChanged:"+clickedItem);
                                // console.log(listModel.get(clickedItem).name);
                                // console.log(listModel.get(clickedItem).imageUrl);
                                // imageURl = Qt.resolvedUrl(_photoListModel.get(clickedItem).imageUrl);
                                imageURl = Qt.resolvedUrl(_photoListModel.getUrl(clickedItem));
                                console.log("data returns: ");
                                console.log(_photoListModel.data(_photoListModel.index(clickedItem,_photoListModel.ImageUrlRole), _photoListModel.ImageUrlRole));
                            }*/
                    }
                    Text{
                        text: "Dimensions: " + previewImage.sourceSize.height + "x" + previewImage.sourceSize.height
                        Layout.alignment: Qt.AlignCenter
                    }
                }
            }

            // ------------------ MAP TAB ------------------------------
            ColumnLayout {
                id: mapTab
                anchors.fill: parent
                // Les coordonnées du point sélectionné
                property double new_latitude
                property double new_longitude
                property bool   new_coords: false
                spacing: 8
                Layout.alignment: Qt.AlignHCenter
                // Layout.fillWidth: true
                onNew_coordsChanged: {
                    // Centrage de la carte sur les nouvelles coordonnées
                    console.log("NewCoords: re-center the map");
                    // mapView.center = QtPositioning.coordinate(new_latitude, new_longitude)  TODO verifier si inutile
                }

                CheckBox {
                    id: showAll_box
                    text: qsTr("Show All")
                    // TODO : afficher toutes les photos du dossier
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


        // ------------------ DATES TAB ----------------------------
        ColumnLayout {
            id: datesTab
            anchors.fill: parent
            spacing: 8
            Text{
                Layout.alignment: Qt.AlignLeft
                text: "Tags:"
            }
            Rectangle{
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "navajowhite"
            }
            Text{
                Layout.alignment: Qt.AlignLeft
                text: "Trashcan:"
            }
            Rectangle{
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "navajowhite"
            }
        }
    }

    // --------------------------------- Ligne 4
    // Imagettes
    // ---------------------------------
    Frame {
        Layout.row: 4
        Layout.columnSpan: 2
        Layout.fillWidth: true
        Layout.preferredHeight: 120

        ListView {
            height: 120
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            orientation: Qt.Horizontal
            delegate:
                Image {
                width: 130
                height: 100
                fillMode: Image.PreserveAspectFit
                source: modelData
            }
        }
    }

    // --------------------------------- Ligne 5
    // Barre de boutons en bas
    // ---------------------------------
    RowLayout {
        Layout.row: 5
        Layout.columnSpan: 2
        //Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignRight  // on cale les boutons à droite
        spacing: 20
        CheckBox {
            id: checkBox
            text: qsTr("Générer backups")
        }
        Button {
            id: button1
            text: qsTr("Enregistrer")
            // TODO : save the modified pictures
            onClicked:
                _photoListModel.dumpData()  // Pour les tests
        }
        Button {
            id: button
            text: qsTr("Quitter")
            onClicked: Qt.quit()
        }
    }
}

}



/*##^##
Designer {
    D{i:0;formeditorColor:"#ffffff";formeditorZoom:0.75}
}
##^##*/
