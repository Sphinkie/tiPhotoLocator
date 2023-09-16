import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12
import Qt.labs.folderlistmodel 2.15
import Qt.labs.platform 1.1

import QtLocation 5.12
import QtPositioning 5.12


Window {
    id: window
    width: 1200
    height: 800
    visible: true
    color: "#f7f7f7"
    title: "tiPhotoLocator"

    // ----------------------------------------------------------------
    // Menu principal
    // ----------------------------------------------------------------
    MenuBar{
        id: menuBar
        Menu {
            id: fileMenu
            title: qsTr("Dossiers")
            MenuItem  { text: qsTr("Ouvrir..."); onTriggered: folderDialog.open() }
            MenuItem  { text: qsTr("Recents..."); enabled: false}
            MenuSeparator {}
            MenuItem  { text: qsTr("Quitter"); onTriggered: Qt.quit()}
        }
        Menu {
            id: settingsMenu
            title: qsTr("Réglages")
            MenuItem  { text: qsTr("Configuration") }
        }
        Menu {
            id:helpMenu
            title: qsTr("Aide")
            MenuItem  { text: qsTr("A propos"); onTriggered: about.open() }
        }
    }
    // ----------------------------------------------------------------
    // Fenetre de dialogue pour slectionner le dossier
    // ----------------------------------------------------------------
    FolderDialog {
        id: folderDialog
        currentFolder: "file:///C:"
        // URL du dossier de départ
        //folder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
        folder: ""
        onFolderChanged: {
            //folderModel.folder = folder;
        }
        onAccepted: {
            // On passe par ici, même si on reselectionne le même folder
            folderModel.folder = folder;
            console.log("Accepted");
            console.log(folderModel.folder);
            console.log(folderModel.count);
        }
    }
    // ----------------------------------------------------------------
    FolderListModel {
        // Ce modele est la liste des fichiers du dossier
        id: folderModel
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
            for (var i = 0; i < count; )  {
                console.log(i+": "+get(i,"fileName"));
                listModel.append({   "name":get(i,"fileName"),
                                      "url":get(i,"fileUrl")
                                    });
                i++
            }
        }
    }
    ListModel {
        // Ce modele est la liste des éléments de la listView
        id: listModel
        // Initialisation des roles
        ListElement {
            name: "Select your photo folder"
            fileurl: "file:///C:/Users/ddelorenzo/Pictures/Photos/IMG_20230709_145111.jpg"
            latitude: 0.0
            longitude: 0.0
        }
    }
    // ----------------------------------------------------------------
    GridLayout
    {
        anchors.fill: parent
        anchors.margins: 8
        rows: 5
        columns: 2

        // ------------------------------- Ligne 0
        TextEdit {
            Layout.row: 0
            Layout.column: 0
            id: folderPath
            readOnly: true
            //enabled: false
            text: folderDialog.folder
        }
        Button{
            Layout.row: 0
            Layout.column: 1
            id: refreshList
            text: "Refresh"
            onClicked: {
                // On met à jour la listModel
                console.log("Manual Refresh");
                listModel.clear();
                for (var i = 0; i < folderModel.count; )  {
                    console.log(i+": "+folderModel.get(i,"fileName"));
                    listModel.append({   "name":folderModel.get(i,"fileName"),
                                         "url":folderModel.get(i,"fileUrl")
                                        });
                    i++
                }
            }
        }

        // ------------------------------- Ligne 1
        GroupBox{
            id: filterBox
            Layout.row: 1
            Layout.column: 0
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignTop
            title: "Filtres:"
            RowLayout{
                anchors.fill: parent
                CheckBox {
                    id: checkBox1
                    x: 0
                    y: 0
                    text: qsTr("sans date")
                    // Liste des photos sans date
                }
                CheckBox {
                    id: checkBox2
                    x: 0
                    y: 33
                    text: qsTr("sans localisation")
                    // Liste des photos sans localisation
                }
                CheckBox {
                    id: checkBox3
                    x: 200
                    y: 0
                    text: qsTr("subfolders")
                    // include subfolders
                    enabled: false
                }
            }
        }

        TabBar {
            id: bar
            Layout.row: 1
            Layout.column: 1
            Layout.fillWidth: true
            TabButton {
                text: qsTr("Preview")
            }
            TabButton {
                text: qsTr("Carte")
            }
            TabButton {
                text: qsTr("Tag Dates")
            }
        }

        // --------------------------------- Ligne 2
        Frame{  // ou Rectangle
            Layout.row: 2
            Layout.column: 0
            Layout.fillWidth: false
            Layout.fillHeight: true
            Layout.preferredHeight: 200
            Layout.preferredWidth: 380

            // https://www.youtube.com/watch?v=ZArpJDRJxcI
            /*
            Component{
                // le délégate pour afficher la FolderListModel dans la ListView
                // OBSOLETE
                id: listDelegate
                Text{
                    readonly property ListView __lv : ListView.view
                    width: parent.width
                    text: fileName + "   gps" + "    Bruxelles";
                    font.pixelSize: 16
                    MouseArea{
                        anchors.fill: parent
                        onClicked: __lv.currentIndex = model.index
                    }
                }
            }
*/
            Component{
                // le délégate pour afficher la ListModel dans la ListView
                id: listDelegate2
                Text{
                    readonly property ListView __lv : ListView.view
                    width: parent.width
                    text: name;
                    font.pixelSize: 16
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            __lv.currentIndex = model.index
                        }
                    }
                }
            }

            ListView{
                id: listView
                anchors.fill: parent
                model: listModel
                delegate: listDelegate2
                focus: true
                clip: true   // pour que les items restent à l'interieur de la listview
                footer: Rectangle{
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: "darkgrey"
                }
                highlight: Rectangle{
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: "lightgrey"
                }
            }
        }

        StackLayout {
            Layout.row: 2
            Layout.column: 1
            Layout.fillWidth: true
            currentIndex: bar.currentIndex

            Item {
                id: previewTab
                Image {
                    id: previewImage
                    readonly property ListView __lv : listView.view
                    readonly property ListModel __model : listView.model
                    property int currentItemIndex: -1
                    width: 640; height: 480
                    fillMode: Image.PreserveAspectFit
                    // source: "file:///C:/Users/ddelorenzo/Pictures/Photos/IMG_20230709_145111.jpg"
                    source: listModel.get(currentItemIndex, "fileurl")
                    onSourceChanged: {
                        console.log(currentItemIndex);
                        console.log(source);
                    }
                    Component.onCompleted: {
                        console.log("onCompleted");
                        console.log("currentItemIndex:"+currentItemIndex);
                        console.log(listView.currentIndex);
                        currentItemIndex = listView.currentIndex
                        console.log("currentItemIndex:"+currentItemIndex);
                        console.log(listModel.get(currentItemIndex, "name"));
                       }
                }
            }
            Item {
                id: mapTab
                Plugin{
                    id: mapPlugin
                    name: "osm"
                    // parametres optionels
                    //PluginParameter{ name: "" ; value: ""}
                }
                Map{
                    anchors.fill: parent
                    plugin: mapPlugin
                    center: QtPositioning.coordinate(48.85, 2.34) // paris
                    zoomLevel: 6
                }
            }
            Item {
                id: datesTab
                ColumnLayout{
                    GroupBox{
                        title: "Tags"
                    }
                    GroupBox{
                        title: "Trashcan"
                    }
                }
            }
        }
        // --------------------------------- Ligne 3
        // Imagettes
        Frame{
            Layout.row: 3
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
                    source: modelData // "file:///C:/Users/ddelorenzo/Pictures/Photos/IMG_20230709_145111.jpg"
                }
            }
        }

        // --------------------------------- Ligne 4
        // Barre de boutons en bas
        RowLayout{
            Layout.row: 4
            Layout.columnSpan: 2
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 20
            //alignment: left
            CheckBox {
                id: checkBox
                text: qsTr("Générer backups")
            }
            Button {
                id: button1
                text: qsTr("Enregistrer")
                //onPressed: folderDialog.open()
            }
            Button {
                id: button
                text: qsTr("Quitter")
                onPressed: Qt.quit()
            }
        }
    }

    // ----------------------------------------------------------------
    Popup {
        id: about
        anchors.centerIn: Overlay.overlay
        width: 200
        height: 300
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        padding: 10
        background: Rectangle {
            width: parent.width
            height: parent.height
            color: "white"
        }
        contentItem: Text {
            Column{
                Text { text: qsTr("TiPhotoLocator a été concu en remplacement du freeware GeoSetter.")}
                Text { text: qsTr("Il permet de placer ses photos sur une carte, et d'éditer des tags exifs.")}
                Text { text: qsTr("Programme réalisé par David de Lorenzo")}
                Button {
                    text: "Close"
                    onClicked: about.close()
                }
            }
        }
    }


}



/*##^##
Designer {
    D{i:0;formeditorColor:"#ffffff";formeditorZoom:0.75}
}
##^##*/
