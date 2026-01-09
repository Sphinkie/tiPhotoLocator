import QtQuick
import QtCore
import QtQuick.Controls
import "../Components"
import "../Javascript/TiUtilities.js" as Utilities


/** **********************************************************************************************************
 * @brief QML: Menu principal.
 * ***********************************************************************************************************/
MenuBar {

    /// Contenu du menu principal: Logo | Files | Settings | Help
    Menu {
        id: fileMenu
        title: qsTr("Files")

        /// Item du menu: File -> Ouvrir
        MenuItem {
            text: qsTr("Open...")
            onTriggered: folderDialog.open()
        }

        /// Item du menu: File -> Recents: la liste de 7 RecentFolders + Séparator + Clear RecentFolders
        Menu {
            id: recentFoldersMenu
            title: qsTr("Recents")
            enabled: recentFoldersInstantiator.count > 0
            property var recents
            property var number
            /// L'instanciateur crée dynamiquement des objets à partir d'une liste.
            Instantiator {
                id: recentFoldersInstantiator
                model: settings.recentList
                delegate: MenuItem {
                    // Texte affiché.
                    text: Utilities.toShortPath(modelData)
                    onTriggered: {
                        console.log(modelData)
                        folderListModel.folder = modelData
                        // puis on met à jour la liste du PhotoModel
                        folderTimer.start()
                    }
                }
                onObjectAdded: (index, object) => recentFoldersMenu.insertItem(
                                   index, object)
                onObjectRemoved: (index, object) => recentFoldersMenu.removeItem(
                                     object)
            }
            MenuSeparator {}
            MenuItem {
                text: qsTr("Clear recent folders list")
                onTriggered: settings.clearRecentFolders()
            }
        }

        /// Item du menu: File -> Separateur
        MenuSeparator {}
        /// Item du menu: File -> Quit
        MenuItem {
            text: qsTr("Quit")
            onTriggered: Qt.quit()
        }
    }
    Menu {
        id: settingsMenu
        title: qsTr("Settings")
        MenuItem {
            text: qsTr("Configuration")
            onClicked: settingsPopup.open()
        }
    }
    Menu {
        id: helpMenu
        title: qsTr("Help")
        // TODO: MenuItem  { text: qsTr("Obtenir une API KEY"); onTriggered: apiPage.open(); }
        MenuItem {
            text: qsTr("Credits")
            onTriggered: creditsPage.open()
        }
        MenuItem {
            text: qsTr("About")
            onTriggered: aboutPage.open()
        }
    }

    FolderLoadTimer {
        id: folderTimer
    }

    // ------------------------------------------------------
    // On relit les chemins récents dans les Settings
    // ------------------------------------------------------
    Settings {
        id: settings
        category: "recentFolders"
        property alias recentList: recentFoldersMenu.recents
        property alias recentNumber: recentFoldersMenu.number

        function clearRecentFolders() {
            recentList = []
            recentNumber = 0
        }
    }
}
