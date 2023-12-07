import QtQuick
import "../Vues"

// Controlleur de la zone avec les informations sur l'appareil ayant fabrqué l'image (appareil photo ou scanner ou IA)
ZoneCameraForm {

    // On determine le contenu des chips ici, mais ça marche aussi si on le fait dans la vue.

    chipModel.content:  tabbedPage.selectedData.camModel
    chipMaker.content:  tabbedPage.selectedData.make
    chipAperture.content: "ƒ " + tabbedPage.selectedData.fNumber.toFixed(1)
    chipSpeed.content:  arrondir(tabbedPage.selectedData.shutterSpeed) + " s"
    chipSoftware.content: tabbedPage.selectedData.software

    chipSpeed.visible: (tabbedPage.selectedData.shutterSpeed > 0)
    chipAperture.visible: (tabbedPage.selectedData.fNumber > 0)


    // Pour la vitesse, on veut une valeur plus lisible.
    // Au lieu de 1/714s, on veut 1/700s
    // Au lieu de 1/1520s, on veut 1/1500s
    function arrondir (valeur)
    {
        if (valeur > 1)
            return Math.floor(valeur);
        else if (valeur < 0.01 )     // au dela de 100, on arrondit au centième.
                valeur = 100*Math.round(1/(valeur*100));
        else if (valeur < 0.1 )     // au dela de 10, on arrondit au dizième.
                valeur = 10*Math.round(1/(valeur*10));
        else if (valeur < 1 )     // au dela de 10, on arrondit.
                valeur = Math.round(1/(valeur));
        return ("1 / " + valeur);
    }
}




/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
