import QtQuick
import QtCore
import QtQuick.Controls
import "../Components"
import "../Javascript/TiUtilities.js" as Utilities

/*! *****************************************************************
 *  Menu principal.
 * ***************************************************************** */
MenuBar{
    Menu {
        id: fileMenu
        title: qsTr("Dossiers")
        MenuItem  { text: qsTr("Ouvrir..."); onTriggered: folderDialog.open(); }

        Menu {
            id: recentFoldersMenu
            title: qsTr("Récents")
            enabled: recentFoldersInstantiator.count > 0
            property var recents
            property var number

            Instantiator {
                id: recentFoldersInstantiator
                model: settings.recentList
                delegate: MenuItem {
                    text: Utilities.toStandardPath(modelData)
                    onTriggered: {
                        console.log(modelData);
                        folderListModel.folder = modelData;
                        // puis on met à jour la liste du PhotoModel
                        folderTimer.start();
                    }
                }
                onObjectAdded: (index, object) => recentFoldersMenu.insertItem(index, object)
                onObjectRemoved: (index, object) => recentFoldersMenu.removeItem(object)
            }

            MenuSeparator {}

            MenuItem {
                text: qsTr("Clear Recent Files")
                onTriggered: settings.clearRecentFolders()
            }
        }
        MenuSeparator {}
        MenuItem  { text: qsTr("Quitter"); onTriggered: Qt.quit(); }
    }
    Menu {
        id: settingsMenu
        title: qsTr("Réglages")
        MenuItem  { text: qsTr("Configuration"); onClicked: settingsPopup.open(); }
    }
    Menu {
        id:helpMenu
        title: qsTr("Aide")
        // TODO: MenuItem  { text: qsTr("Obtenir une API KEY"); onTriggered: apiPage.open(); }
        MenuItem  { text: qsTr("Credits"); onTriggered: creditsPage.open(); }
        MenuItem  { text: qsTr("A propos"); onTriggered: aboutPage.open(); }
    }

     FolderLoadTimer {id: folderTimer}

    // ------------------------------------------------------
    // On relit les chemins récents dans les Settings
    // ------------------------------------------------------
    Settings {
        id: settings
        category: "recentFolders"
        property alias recentList: recentFoldersMenu.recents
        property alias recentNumber: recentFoldersMenu.number

        function clearRecentFolders(){
            recentList = [];
            recentNumber = 0;
        }
    }
}
