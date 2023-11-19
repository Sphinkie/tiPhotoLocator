import QtQuick
import QtQuick.Controls

// ----------------------------------------------------------------
// Menu principal
// ----------------------------------------------------------------
MenuBar{
    Menu {
        id: fileMenu
        title: qsTr("Dossiers")
        MenuItem  { text: qsTr("Ouvrir..."); onTriggered: folderDialog.open(); }
        MenuItem  { text: qsTr("Recents..."); enabled: false; }
        MenuSeparator {}
        MenuItem  { text: qsTr("Quitter"); onTriggered: Qt.quit(); }
    }
    Menu {
        id: settingsMenu
        title: qsTr("Réglages")
        MenuItem  { text: qsTr("Configuration");
            onClicked: {
                var component = Qt.createComponent("../Vues/SettingsWindowForm.qml");
                var settingsWindow    = component.createObject();
                settingsWindow.show();
            }
        }
    }
    Menu {
        id:helpMenu
        title: qsTr("Aide")
        MenuItem  { text: qsTr("Obtenir une API KEY"); enabled: false; }
        MenuItem  { text: qsTr("Credits"); onTriggered: creditsPage.open(); }
        MenuItem  { text: qsTr("A propos"); onTriggered: about.open(); }
    }
}
