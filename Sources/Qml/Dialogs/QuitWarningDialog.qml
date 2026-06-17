import QtQuick
import QtQuick.Dialogs

/** **********************************************************************************************************
 * @brief QML: Ouvre une MessageBox avant de Quitter si toutes les modifs n'ont pas été enregistrées.
 * *********************************************************************************************************** */
MessageDialog {
    title: "Attention"
    readonly property string t1: qsTr("Warning:all changes have not been saved.<br/>")
    readonly property string t2: qsTr("All unsaved changes will be lost.")
    text: t1 + t2
    informativeText: qsTr("Do you want to continue?")
    buttons: MessageDialog.Ok | MessageDialog.Cancel
    Component.onCompleted: visible = false

    /// Si Ok, on quitte l'application
    onAccepted: {
        console.log("Quit application");
        Qt.quit();
    }
}
