import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.5
import Qt.labs.folderlistmodel 2.15
import Qt.labs.platform 1.1
import "."

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
            title: qsTr("&Dossiers")
            MenuItem  { text: qsTr("&Ouvrir..."); onTriggered: folderDialog.open()}
            MenuItem  { text: qsTr("&Recents...") }
            MenuSeparator {}
            MenuItem  { text: qsTr("&Quitter"); onTriggered: Qt.quit()}
        }
        Menu {
            id: settingsMenu
            title: qsTr("&Réglages")
            MenuItem  { text: qsTr("Préférences") }
            MenuItem  { text: qsTr("Configuration") }
        }
        Menu {
            id:helpMenu
            title: qsTr("&Aide")
            MenuItem  { text: qsTr("A propos"); onTriggered: about.open() }
        }
    }
    // ----------------------------------------------------------------
    FolderDialog {
        id: folderDialog
        currentFolder: ""
        //folder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
        folder: ""
        onFolderChanged: {
            folderModel.folder = folder;
        }
    }
    // ----------------------------------------------------------------
    GridLayout
    {
        anchors.fill: parent
        anchors.margins: 8
        rows: 2
        columns: 2

        // ------------------------------- Ligne 1
        GroupBox{
            id: filterBox
            Layout.row: 0
            Layout.column: 0
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

    // --------------------------------- Ligne 2

        ListView{
            Layout.row: 1
            Layout.column: 0
            //y:100
            //width: filterBox.width
            Layout.fillHeight: true
            //PreferedWidth: 331
            //height: 336
            //leftMargin: 8
            //bottomMargin: 8
            //rightMargin: 8

            model: FolderListModel {
                id: folderModel
                sortCaseSensitive : false
                showDirs: false
                nameFilters: ["*.jpg"]
                folder: ""
            }
            delegate: Text { text: fileName }
        }

        StackLayout {
            Layout.row: 1
            Layout.column: 1
            currentIndex: bar.currentIndex
            Item {
                id: homeTab
            }
            Item {
                id: discoverTab
            }
            Item {
                id: activityTab

            }
        }
    }

    // Barre de boutons en bas
    Row{
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        spacing: 20
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
