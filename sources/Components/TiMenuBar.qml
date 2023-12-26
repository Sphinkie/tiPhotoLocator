import QtQuick
import QtQuick.Controls

/*! *****************************************************************
 *  Menu principal.
 * ***************************************************************** */
MenuBar{
    Menu {
        id: fileMenu
        title: qsTr("Dossiers")
        MenuItem  { text: qsTr("Ouvrir..."); onTriggered: folderDialog.open(); }
        // MenuItem  { text: qsTr("Recents..."); enabled: false; }
        MenuSeparator {}
        MenuItem  { text: qsTr("Quitter"); onTriggered: Qt.quit(); }
    }
    Menu {
        id: settingsMenu
        title: qsTr("Réglages")
        MenuItem  { text: qsTr("Configuration"); onClicked: settingsPopup.open(); }
        // MenuItem  { text: qsTr("Metadata"); onClicked: metadataPopup.open(); }
    }
    Menu {
        id:helpMenu
        title: qsTr("Aide")
        MenuItem  { text: qsTr("Obtenir une API KEY"); onTriggered: apiPage.open(); }
        MenuItem  { text: qsTr("Credits"); onTriggered: creditsPage.open(); }
        MenuItem  { text: qsTr("A propos"); onTriggered: aboutPage.open(); }
    }
}
