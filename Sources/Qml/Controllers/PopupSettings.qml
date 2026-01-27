import QtQuick
import "../Vues"


/** **********************************************************************************************************
 * @brief Controleur de la fenêtre des Settings.
 * ***********************************************************************************************************/
PopupSettingsForm {

    readonly property string sysLang: Qt.locale().nativeLanguageName

    Component.onCompleted: {
        show()
    }

    /// Request the coords of the city and close the popup.
    buttonClose.onClicked: {
        console.log("Settings closed -> requesting coords for " + settings.homecity)
        window.requestCoords(settings.homecity, true)
        close()
    }

    /// Fonction pour enregistrer les Settings au moment du click sur OK. (Non utilisée).
    function saveConfiguration() {
        //settings.category= "configuration";
        settings.setValue("photographe", textFieldName.text)
        settings.setValue("initiales", textFieldInitials.text)
        settings.setValue("preserveExif", checkBoxExif.checked)
        settings.setValue("debugModeEnabled", checkBoxDebug.checked)
    }
}
