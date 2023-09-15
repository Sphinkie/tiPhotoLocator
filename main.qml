import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.5
//import QtQml.Models 2.3
import Qt.labs.folderlistmodel 2.15
import Qt.labs.platform 1.1


Window {
    id: window
    width: 1200
    height: 800
    visible: true
    color: "#f7f7f7"
    title: "tiPhotoLocator"

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
    FolderDialog {
        id: folderDialog
        currentFolder: "file:///C:"
        // URL du dossier de départ
        //folder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
        folder: ""
        onFolderChanged: {
            console.log(folder);
            console.log(folderModel.count);
//            folderModel2.append({ "name": "New York City"});
//            folderModel2.append({ "name": "Los Angeles"});
        }
        onAccepted: {
            folderModel.folder = folder;
            console.log("Accepted");
            console.log(folder);
            console.log(folderModel.count);
        }
    }
    // ----------------------------------------------------------------
    FolderListModel {
        // Ce modele est la liste des fichiers du dossier
        id: folderModel
        sortCaseSensitive : false
        showDirs: false
        nameFilters: ["*.jpg"]
        folder: ""
        onDataChanged: {
               console.log("data changed");}
        onFolderChanged: {
            console.log("folder changed");}
        onCountChanged: {
            console.log("count changed");
            console.log(count);
            for (var i = 0; i < count; )  {
                console.log(i+": "+get(i,"fileName"));
                i++
            }
        }
    }
    ListModel {
        // Ce modele est la liste des éléments de la listView
        id: folderModel2
        ListElement {
            name: "Paris"
            localized: "true"
            lat: 40.730610
        }
    }
    // ----------------------------------------------------------------
    GridLayout
    {
        anchors.fill: parent
        anchors.margins: 8
        rows: 4
        columns: 2

        // ------------------------------- Ligne 0
        GroupBox{
            id: filterBox
            Layout.row: 0
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
            Layout.row: 0
            Layout.column: 1
            Layout.fillWidth: true
            TabButton {
                text: qsTr("Carte")
            }
            TabButton {
                text: qsTr("Tag Dates")
            }
            TabButton {
                text: qsTr("Preview")
            }
        }

        // --------------------------------- Ligne 1
        Frame{  // ou Rectangle
            Layout.row: 1
            Layout.column: 0
            Layout.fillWidth: false
            Layout.fillHeight: true
            Layout.preferredHeight: 200
            Layout.preferredWidth: 380

            // https://www.youtube.com/watch?v=ZArpJDRJxcI

            Component{
                // le délégué
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

            Component{
                // le délégué
                id: listDelegate2
                Text{
                    readonly property ListView __lv : ListView.view
                    width: parent.width
                    text: name + "   " + lat;
                    font.pixelSize: 16
                    MouseArea{
                        anchors.fill: parent
                        onClicked: __lv.currentIndex = model.index
                    }
                }
            }

            ListView{
                anchors.fill: parent
                model: folderModel2
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
            Layout.row: 1
            Layout.column: 1
            Layout.fillWidth: true
            currentIndex: bar.currentIndex
            Item {
                id: mapTab
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
            Item {
                id: previewTab
                Image {
                    id: previewImage
                    width: 640; height: 480
                    fillMode: Image.PreserveAspectFit
                    source: "file:///C:/Users/ddelorenzo/Pictures/Photos/IMG_20230709_145111.jpg"
                }
            }
        }
        // --------------------------------- Ligne 2
        // Imagettes
        Frame{
            Layout.row: 2
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.preferredHeight: 120

            ColumnLayout {
                /*                Image {
                    width: 130
                    height: 100
                    fillMode: Image.PreserveAspectFit
                    source: "file:///C:/Users/ddelorenzo/Pictures/Photos/IMG_20230709_145111.jpg"
                }*/
            }
        }

        // --------------------------------- Ligne 3
        // Barre de boutons en bas
        RowLayout{
            Layout.row: 3
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
