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
            property var recents: folderDialog.recentList // utilité ?
            /// L'instanciateur crée dynamiquement des objets à partir d'une liste.
            Instantiator {
                id: recentFoldersInstantiator
                model: folderDialog.recentList
                delegate: MenuItem {
                    // Texte affiché.
                    text: Utilities.toShortPath(modelData)
                    rightPadding: 8
                    onTriggered: {
                        console.log(modelData)
                        let normalizedFolder = Utilities.normalizeUrl(modelData)
                        folderListModel.folder = normalizedFolder
                        window.currentFolderUrl = normalizedFolder
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
                onTriggered: folderDialog.clearRecentFolders()
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
        MenuItem {
            text: qsTr("Keywords")
            onClicked: keywordsPopup.open()
        }
    }
    Menu {
        id: helpMenu
        title: qsTr("Help")
        MenuItem {
            text: qsTr("Obtenir une API KEY")
            onTriggered: apiPage.open()
        }
        MenuItem {
            text: qsTr("Credits")
            onTriggered: creditsPage.open()
        }
        MenuItem {
            text: qsTr("About")
            onTriggered: aboutPage.open()
        }
    }

    TimerLoadFolder {
        id: folderTimer
    }
}
