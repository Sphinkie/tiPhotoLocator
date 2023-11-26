import QtQuick
import "../Vues"



// Controleur de la fenetre des Settings
SettingsPopupForm {

    readonly property string sysLang : Qt.locale().nativeLanguageName

    Component.onCompleted: {
        show();
    }

   buttonClose.onClicked: {
       console.log("Settings closed -> requesting coords for " + reglages.homecity);
       window.requestCoords(reglages.homecity);
       close();
    }

    // Fonction pour enregistrer les Setings au moment du click sur OK.
    // Non utilisé
    function saveConfiguration()
    {
        //reglages.category= "configuration";
        reglages.setValue("photographe", textFieldName.text);
        reglages.setValue("initiales", textFieldInitials.text);
        reglages.setValue("preserveExif", checkBoxExif.checked);
        reglages.setValue("debugModeEnabled", checkBoxDebug.checked);
    }
}
