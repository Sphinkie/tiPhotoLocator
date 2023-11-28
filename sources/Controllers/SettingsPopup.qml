import QtQuick
import "../Vues"



// Controleur de la fenetre des Settings
SettingsPopupForm {

    readonly property string sysLang : Qt.locale().nativeLanguageName

    Component.onCompleted: {
        show();
    }

   buttonClose.onClicked: {
       console.log("Settings closed -> requesting coords for " + settings.homecity);
       window.requestCoords(settings.homecity);
       close();
    }

    // Fonction pour enregistrer les Setings au moment du click sur OK.
    // Non utilisé
    function saveConfiguration()
    {
        //settings.category= "configuration";
        settings.setValue("photographe", textFieldName.text);
        settings.setValue("initiales", textFieldInitials.text);
        settings.setValue("preserveExif", checkBoxExif.checked);
        settings.setValue("debugModeEnabled", checkBoxDebug.checked);
    }
}
