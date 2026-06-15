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
            onTriggered: folderDialog.openInParentFolder()
        }

        /// Item du menu: File -> Recents: la liste de 7 RecentFolders + Séparator + Clear RecentFolders
        Menu {
            id: recentFoldersMenu
            title: qsTr("Recents")
            enabled: folderDialog.recentList.length > 0
            /// L'instanciateur crée dynamiquement des objets à partir d'une liste.
            Instantiator {
                id: recentFoldersInstantiator
                model: folderDialog.recentList
                delegate: MenuItem {
                    // Texte affiché.
                    text: Utilities.toShortPath(modelData)
                    rightPadding: 8
                    onTriggered: {
                        console.log(modelData);
                        let normalizedFolder = Utilities.normalizeUrl(modelData);
                        folderListModel.folder = normalizedFolder;
                        window.currentFolderUrl = normalizedFolder;
                        // puis on met à jour la liste du PhotoModel
                        folderTimer.start();
                    }
                }
                onObjectAdded: (index, object) => recentFoldersMenu.insertItem(index, object)
                onObjectRemoved: (index, object) => recentFoldersMenu.removeItem(object)
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

    /// Menu SETTINGS
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

    /// Menu HELP
    Menu {
        id: helpMenu
        title: qsTr("Help")
        MenuItem {
            text: qsTr("Tutorial")
            onTriggered: tutorialPage.open()
        }
        MenuItem {
            text: qsTr("Get an API KEY for maps")
            onTriggered: mapApiPage.open()
        }
        MenuItem {
            text: qsTr("Get an API KEY for AI")
            onTriggered: aiApiPage.open()
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

    /// Timer: Attend 1 seconde, avant de remplir le PhotoModel.
    TimerLoadFolder {
        id: folderTimer
    }
}
