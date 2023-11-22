import QtQuick
import "../Vues"



// Controleur de la fenetre des Settings
SettingsWindowForm {

    Component.onCompleted: {
        settingsWindow.show();
    }

/*
   buttonClose.onClicked: {
        settingsWindow.close()
    }
*/



    // Fonction pour enregistrer les Setings au moment du click sur OK.
    // Non utilisé
    function saveConfiguration()
    {
        //reglages.category= "configuration";
        reglages.setValue("photographe", textFieldName.text);
        reglages.setValue("initiales", textFieldInitials.text);
        reglages.setValue("creatorEnabled", checkBoxCreator.checked);
        reglages.setValue("captionEnabled", checkBoxCaption.checked);
        reglages.setValue("imgDescEnabled", checkBoxImgDesc.checked);
        reglages.setValue("debugModeEnabled", checkBoxDebug.checked);
    }
}
