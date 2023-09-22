import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12
import Qt.labs.platform 1.1

import QtQml.Models 2.15

import QtLocation 5.12
import QtPositioning 5.12

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
    // Liste des photos avec toutes leurs infos
    //    PhotoListModel{ id: photoListModel}  : implémenté en C++
    // Liste des fichiers du dossier
    FolderListModel { id: folderListModel }
    MarkerListModel { id: mappinModel } // TODO : normalement inutile si on arrive à faire fonctionner le Package et DelegateModel


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
        TextEdit {
            Layout.row: 1
            Layout.column: 0
            id: folderPath
            //readOnly: true
            enabled: false
            text: folderDialog.folder
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
                // _photoListModel.clear();                                                       // TODO implémenter le clear() en C++ (?)
                for (var i = 0; i < folderListModel.count; )  {
                    console.log(i+": "+folderListModel.get(i,"fileName"));
                    console.log(i+": "+folderListModel.get(i,"fileUrl"));
                    //                    _photoListModel.append({ "filename":folderListModel.get(i,"fileName"),        // TODO implémenter le append() en C++ (?)
                    //                                         "imageUrl":folderListModel.get(i,"fileUrl").toString(),
                    //                                         "latitude": 48.0 + Math.random(),
                    //                                         "longitude": 2.0 + Math.random()
                    //                                     });
                    _photoListModel.append(folderListModel.get(i,"fileName"),        // TODO implémenter avec 1 parametre de type dictionnaire
                                           folderListModel.get(i,"fileUrl").toString(),
                                           48.0 + Math.random(),
                                           2.0 + Math.random()
                                           )
                    i++
                }
            }
        }

        // --------------------------------- Ligne 2
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
        // LIST VIEW DES PHOTOS
        // ---------------------------------
        Frame {  // ou Rectangle
            Layout.row: 3
            Layout.column: 0
            Layout.fillWidth: false
            Layout.fillHeight: true
            Layout.preferredHeight: 200
            Layout.preferredWidth: 380

            // https://www.youtube.com/watch?v=ZArpJDRJxcI
            Component{
                // le delegate pour afficher la ListModel dans la ListView
                id: listDelegate
                Text{
                    // Avec les required properties, on indique qu'il faut utiliser les roles du modèle
                    required property int index
                    required property string filename
                    //                    required property bool isDirty
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
                            __lv.currentIndex = index
                            previewImage.imageUrl = imageUrl   // A essayer : creer la propriété correspondante
                            tabbedPage.selectedItem = index
                            model.setCurrentIndex(index)
                            // isDirty = true
                        }
                    }
                }
            }

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
                property real pLatitude: 48.85  // paris
                property real pLongitude: 2.34
                spacing: 8
                Layout.alignment: Qt.AlignHCenter
                // Layout.fillWidth: true
                // Si les coords changent (selection d'une autre photo), on recentre la carte
                onPLatitudeChanged: {
                    mapView.center = QtPositioning.coordinate(pLatitude, pLongitude)
                }
                CheckBox {
                    id: showAll_box
                    text: qsTr("Show All")
                    // TODO : afficher tous les photos du dossier
                }
                Plugin{
                    id: mapPlugin
                    name: "osm"
                    // parametres optionels
                    // PluginParameter{ name: "" ; value: ""}
                    // TODO : ajouter la KEY API
                }
                Map{
                    id: mapView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    plugin: mapPlugin
                    center: QtPositioning.coordinate(parent.pLatitude, parent.pLongitude)
                    zoomLevel: 6

                    MapItemView {
                        model: mappinModel
                        delegate: MapQuickItem {
                            // Attention: le Delegate utilise les infos du MODEL (et pas les propriétés du parent!)
                            coordinate: QtPositioning.coordinate(latitude, longitude)
                            // Point d'ancrage de l'icone
                            anchorPoint.x: markerIcon.width * 0.5
                            anchorPoint.y: markerIcon.height
                            sourceItem: Column {
                                Image { id: markerIcon; source: "qrc:///Images/mappin-red.png"; height: 48; width: 48 }
                                Text { text: name; font.bold: true }
                            }

                        }
                    }

                }
                Text{
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignRight
                    text: "Coordinates: " + mapTab.pLatitude.toString() + " [LatN} / " + mapTab.pLongitude.toString() + " [longW}"
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
