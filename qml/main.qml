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
    signal qmlSignal(double latit)
    signal scanFolder(string str)

    // ----------------------------------------------------------------
    // Fenetre de dialogue pour selectionner le dossier
    // ----------------------------------------------------------------
    TiFolderDialog { id: folderDialog }
    // ----------------------------------------------------------------
    // "About..." window
    // ----------------------------------------------------------------
    AboutPopup { id: about }

    // ----------------------------------------------------------------
    // Modèles de données
    // ----------------------------------------------------------------
    // Liste des fichiers du dossier
    FolderListModel { id: folderListModel }

    // ----------------------------------------------------------------
    // Page principale
    // ----------------------------------------------------------------
    GridLayout
    {
        anchors.fill: parent
        anchors.margins: 8
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
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
        }

        // --------------------------------- Ligne 1
        // Rappel du nom du folder
        // ---------------------------------
        TextEdit {
            Layout.row: 1
            Layout.column: 0
            id: folderPath
            //readOnly: true
            enabled: false
            text: folderDialog.folder
            font.pixelSize: 16
        }
        Button {
            // TODO: le bouton pourra être supprimé quand on aura mis le timer
            Layout.row: 1
            Layout.column: 1
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignRight
            id: refreshList
            text: qsTr("Refresh")
            onClicked: {
                // On met à jour la listModel
                console.log("Manual Refresh");
                window.scanFolder("text")
                // _photoListModel.clear();                                                       // TODO implémenter le clear() en C++ (?)
                for (var i = 0; i < folderListModel.count; )  {
                    console.log(i+": "+folderListModel.get(i,"fileName"));
                    console.log(i+": "+folderListModel.get(i,"fileUrl"));
                    //                    _photoListModel.append({ "filename":folderListModel.get(i,"fileName"),
                    //                                         "imageUrl":folderListModel.get(i,"fileUrl").toString(),
                    //                                         "latitude": 48.0 + Math.random(),
                    //                                         "longitude": 2.0 + Math.random()
                    //                                     });
                    _photoListModel.append(folderListModel.get(i,"fileName"),        // TODO: implémenter avec 1 parametre de type dictionnaire
                                           folderListModel.get(i,"fileUrl").toString(),
                                           48.0 + Math.random(),
                                           2.0 + Math.random()
                                           )
                    i++
                }
            }
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
        // ListView des photos (filenames)
        // ---------------------------------
        Frame {
            Layout.row: 3
            Layout.column: 0
            Layout.fillWidth: false
            Layout.fillHeight: true
            Layout.preferredHeight: 200
            Layout.preferredWidth: 380

            // https://www.youtube.com/watch?v=ZArpJDRJxcI
            ListView{
                id: listView
                anchors.fill: parent
                model: _photoListModel                                                 // implémenté en C++
                delegate: listDelegate
                focus: true
                clip: true   // pour que les items restent à l'interieur de la listview
                footer: Rectangle{
                    anchors.left: parent.left
                    anchors.right: parent.right
                    // Layout.fillWidth: true
                    height: 1
                    color: "darkgrey"
                }
                highlight: Rectangle{
                    Layout.fillWidth: true
                    //         anchors.left: parent.left
                    //         anchors.right: parent.right
                    color: "lightgrey"
                }
            }

            Component{
                // le delegate pour afficher la ListModel dans la ListView
                id: listDelegate
                Text{
                    // Avec les required properties dans une delegate, on indique qu'il faut utiliser les roles du modèle
                    required property string filename
                    required property double latitude
                    required property double longitude
                    // index is a special role available in the delegate: the index of the item in the model.
                    // Note this index is set to -1 if the item is removed from the model...
                    required property int index
                    readonly property ListView __lv : ListView.view
                    width: parent.width
                    text: filename;
                    font.pixelSize: 16
                    //visible: isDirty ? false : true
                    //color: isDirty===true ? "red" : "blue"
                    // Gestion du clic sur un item
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            console.log("MouseArea: "+index);
                            __lv.currentIndex = index             // Bouge le highlight dans la ListView
                            // previewImage.imageUrl = imageUrl   // A essayer : creer la propriété correspondante (+ rapide que le proxymodel ?)
                            _photoListModel.selectedRow = index   // Actualise le proxymodel
                            tabbedPage.selectedItem = index       // inutile si on utilise le ProxyModel
                            // On envoie les coordonnées pour centrer la carte sur le point selectionné
                            mapTab.new_latitude = latitude
                            mapTab.new_longitude = longitude
                            mapTab.new_coords = !mapTab.new_coords

                        }
                    }
                }
            }

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
            //            }

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
                    // TODO : afficher tous les photos du dossier
                }

                // Affichage de la carte
                TiPhotoMap{
                    id: mapView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

/**
                Map{
                    id: mapView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    plugin: mapPlugin
                    center: QtPositioning.coordinate(parent.new_latitude, parent.new_longitude)
                    zoomLevel: 6
                    onMapItemsChanged: {
                        // Called every time the maker changes on the map: cad un clic dans la listView
                        console.log("onMapItemsChanged: re-center the map");
                        center= QtPositioning.coordinate(parent.new_latitude, parent.new_longitude)
                    }

                    // The MapItemView is used to populate Map with MapItems from a model.
                    // The MapItemView type only makes sense when contained in a Map, meaning that it has no standalone presentation.
                    MapItemView {
                        id: mapitemView
                        model: _selectedPhotoModel
                        delegate: mapDelegate

                        // ---------------------------
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("Click on the map.");
                                var lati = (mapView.toCoordinate(Qt.point(mouse.x,mouse.y)).latitude);
                                var longi = (mapView.toCoordinate(Qt.point(mouse.x,mouse.y)).longitude);
                                console.log('latitude  = ' + lati );
                                console.log('longitude = ' + longi);
                                // On mémorise les coords du point dans les properties du parent
                                mapTab.new_latitude = lati;
                                mapTab.new_longitude= longi;
                                // On demande un recentrage de la carte
                                // mapTab.new_coords = !mapTab.new_coords;
                                // On écrit les coordonnées dans l'item du modele
                                _selectedPhotoModel.setCoords(lati, longi);
                                // parent.qmlSignal(lati) // marche pas
                            }
                        }
                        // ---------------------------
                    }


                    Component{
                        // Le delegate pour afficher le Marker dans la MapView
                        id: mapDelegate
                        // Affichage d'un marker avec sous-titre
                        MapQuickItem{
                            // Avec les required properties dans une delegate, on indique qu'il faut utiliser les roles du modèle
                            required property string filename
                            required property double latitude
                            required property double longitude
                            // Position du maker
                            coordinate: QtPositioning.coordinate(latitude, longitude)
                            // Point d'ancrage de l'icone
                            anchorPoint.x: markerIcon.width * 0.5
                            anchorPoint.y: markerIcon.height
                            // On dessine le marker et le texte
                            sourceItem: Column {
                                Image { id: markerIcon; source: "qrc:///Images/mappin-red.png"; height: 48; width: 48 }
                                Text { text: filename; font.bold: true }
                            }
                        }
                    }

                    Plugin{
                        id: mapPlugin
                        name: "osm"
                        // parametres optionels
                        // PluginParameter{ name: "" ; value: ""}
                        // TODO : ajouter la KEY API
                    }

                }
**/
                ListView{
                    id: coordsTextView
                    model: _selectedPhotoModel
                    delegate: coordsTextDelegate
                }

                Component{
                    id: coordsTextDelegate
                    Text {
                        required property string latitude
                        required property string longitude
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignBottom
                        text: "Coordinates: " + latitude + " [LatN] / " + longitude + " [longW]"   // TODO : formater à 5 digits
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
        }
        Button {
            id: button
            text: qsTr("Quitter")
            onPressed: Qt.quit()
        }
    }
}

}



/*##^##
Designer {
    D{i:0;formeditorColor:"#ffffff";formeditorZoom:0.75}
}
##^##*/
