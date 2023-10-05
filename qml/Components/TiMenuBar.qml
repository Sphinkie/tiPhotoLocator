import QtQuick 2.15
import QtQuick.Controls 2.12


// ----------------------------------------------------------------
// Menu principal
// ----------------------------------------------------------------
MenuBar{
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
        MenuItem  { text: qsTr("Obtenir une API KEY"); enabled: false }
        MenuItem  { text: qsTr("Credits"); onTriggered: creditsPage.open(); }
        MenuItem  { text: qsTr("A propos"); onTriggered: about.open() }
    }
}
