import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12
import Qt.labs.folderlistmodel 2.15
import Qt.labs.platform 1.1

import QtLocation 5.12
import QtPositioning 5.12

import "./Dialogs"
import "./Components"

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
    // Modèles de donnees
    // Ce modele contient la liste des fichiers du dossier
    // ----------------------------------------------------------------
    FolderListModel {
        id: folderListModel
        sortCaseSensitive: false
        showDirs: false
        nameFilters: ["*.jpg"]
        folder: ""
        onFolderChanged: {
            console.log("folder changed");}
        onCountChanged: {
            // En cas de changement, on met à jour la listModel
            console.log("FolderListModel count changed:"+count);
            listModel.clear();
            // TODO : mettre un timer
            for (var i = 0; i < count; )  {
                console.log(i+": "+get(i,"fileName"));
                listModel.append({   "name": get(i,"fileName"),
                                     "imageUrl": get(i,"fileUrl").toString()
                                 });
                i++
            }
        }
    }
    // ----------------------------------------------------------------
    // Modèles de donnees
    // Ce modele contient la liste des éléments de la listView
    // ----------------------------------------------------------------
    ListModel {
        id: listModel
        // Initialisation des roles
        ListElement {
            name: qsTr("Select your photo folder")
            imageUrl: "qrc:///Images/ibiza.png"
            latitude: 38.980
            longitude: 1.433
        }
    }
    // ----------------------------------------------------------------
    // Modèles de donnees
    // Ce modele contient la liste des éléments à afficher sur la map
    // ----------------------------------------------------------------
    ListModel {
        id: mappinModel
        // Initialisation des roles
        ListElement {
            name: ""
            latitude: 0.0
            longitude: 0.0
            color: "red"
        }
    }

    // ----------------------------------------------------------------
    // Page principale
    // ----------------------------------------------------------------
    GridLayout
    {
        anchors.fill: parent
        anchors.margins: 8
        rows: 6
        columns: 2

        // --------------------------------- Ligne 0
        // Menu principal
        TiMenuBar {
            // anchors.fill: parent.width
            id: menuBar
            Layout.row: 0
            Layout.column: 0
            Layout.columnSpan: 2
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
                listModel.clear();
                for (var i = 0; i < folderListModel.count; )  {
                    console.log(i+": "+folderListModel.get(i,"fileName"));
                    console.log(i+": "+folderListModel.get(i,"fileUrl"));
                    listModel.append({ "name":folderListModel.get(i,"fileName"),
                                         "imageUrl":folderListModel.get(i,"fileUrl").toString(),
                                         "latitude": 48.0 + Math.random(),
                                         "longitude": 2.0 + Math.random()
                                     });
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
                    readonly property ListView __lv : ListView.view
                    width: parent.width
                    text: name;
                    font.pixelSize: 16
                    // Gestion du clic sur un item
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            __lv.currentIndex = model.index
                            previewImage.clickedItem = model.index
                            tabbedPage.selectedItem = model.index
                        }
                    }
                }
            }

            ListView{
                id: listView
                anchors.fill: parent
                model: listModel
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
            //Layout.fillWidth: true
            currentIndex: bar.currentIndex
            property int selectedItem: -1   // Image sélectionnée dans la ListView
            onSelectedItemChanged: {
                mapTab.pLatitude = listModel.get(selectedItem).latitude
                mapTab.pLongitude = listModel.get(selectedItem).longitude
                // On ajoute l'image sélectionnée aux pins à afficher sur la carte
                mappinModel.append({"name": listModel.get(selectedItem).name,
                                       "latitude": mapTab.pLatitude,
                                       "longitude": mapTab.pLongitude})
            }
            // ------------------ PREVIEW TAB --------------------------
            ColumnLayout {
                id: previewTab
                //anchors.fill: parent
                //Layout.fillWidth: true
                //Layout.fillHeight: true
                //Layout.alignment: Qt.AlignHCenter

                Image {
                    id: previewImage
                    Layout.alignment: Qt.AlignHCenter
                    property int clickedItem: -1
                    property url imageURl: "qrc:///Images/kodak.png"
                    Layout.preferredWidth: 600
                    Layout.preferredHeight: 600
                    // TODO: limiter la taille de l'image affichée à la taille du fichier (pas de upscale)
                    fillMode: Image.PreserveAspectFit
                    source: imageURl
                    onClickedItemChanged: {
                        console.log("onClickedItemChanged:"+clickedItem);
                        console.log(listModel.get(clickedItem).name);
                        console.log(listModel.get(clickedItem).imageUrl);
                        imageURl = Qt.resolvedUrl(listModel.get(clickedItem).imageUrl);
                    }
                }
                Text{
                    text: "Dimensions: " + previewImage.sourceSize.height + "x" + previewImage.sourceSize.height
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                }
            }

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
                    //PluginParameter{ name: "" ; value: ""}
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
