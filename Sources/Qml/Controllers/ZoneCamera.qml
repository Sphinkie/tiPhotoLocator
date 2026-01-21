import QtQuick
import "../Vues"


/** **********************************************************************************************************
 * @brief Controlleur de la zone avec les informations sur l'appareil ayant fabriqué l'image
 *        (appareil photo ou scanner ou IA).
 * ***********************************************************************************************************/
ZoneCameraForm {

    // On determine le contenu des chips ici, mais ça marche aussi si on le fait dans la vue.
    chipModel.content: tabbedPage.currentPhoto.camModel
    chipMaker.content: tabbedPage.currentPhoto.make
    chipAperture.content: "ƒ " + tabbedPage.currentPhoto.fNumber.toFixed(1)
    chipSpeed.content: arrondir(tabbedPage.currentPhoto.shutterSpeed) + " s"
    chipSoftware.content: tabbedPage.currentPhoto.software
    chipMetadata.content: tabbedPage.currentPhoto.metadata

    chipSpeed.visible: (tabbedPage.currentPhoto.shutterSpeed > 0)
    chipAperture.visible: (tabbedPage.currentPhoto.fNumber > 0)

    property string camPng: tabbedPage.currentPhoto.camModel
    // on enleve les espaces et / et \
    camThumb.source: camPng ? "/Cameras/" + camPng.replace(/[\s\\\/]/g,
                                                           '') + ".png" : ""

    // Pour la vitesse, on veut une valeur plus lisible.
    // Au lieu de 1/714s, on veut 1/700s
    // Au lieu de 1/1526s, on veut 1/1500s
    function arrondir(valeur) {
        if (valeur > 1)
            return Math.floor(valeur)
        else if (valeur < 0.01)
            // au dela de 100, on arrondit au centième.
            valeur = 100 * Math.round(1 / (valeur * 100))
        else if (valeur < 0.1)
            // au dela de 10, on arrondit au dizième.
            valeur = 10 * Math.round(1 / (valeur * 10))
        else if (valeur < 1)
            // au dela de 10, on arrondit.
            valeur = Math.round(1 / (valeur))
        return ("1 / " + valeur)
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

