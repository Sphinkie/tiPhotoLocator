import QtQuick
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities


/** **********************************************************************************************************
 * @brief Controlleur de la zone avec les informations sur l'appareil ayant fabriqué l'image
 *        (appareil photo ou scanner ou IA).
 * ***********************************************************************************************************/
ZoneCameraForm {

    // On determine le contenu des chips ici, mais ça marche aussi si on le fait dans la vue.
    chipModel.content: tabbedPage.currentPhoto.camModel
    chipMaker.content: tabbedPage.currentPhoto.make
    chipAperture.content: "ƒ " + tabbedPage.currentPhoto.fNumber.toFixed(1)
    chipSpeed.content: Utilities.arrondir(tabbedPage.currentPhoto.shutterSpeed)
    chipSoftware.content: tabbedPage.currentPhoto.software
    chipMetadata.content: tabbedPage.currentPhoto.metadata

    chipSpeed.visible: (tabbedPage.currentPhoto.shutterSpeed > 0)
    chipAperture.visible: (tabbedPage.currentPhoto.fNumber > 0)

    property string camPng: tabbedPage.currentPhoto.camModel
    // on enleve les espaces et / et \
    camThumb.source: camPng ? "/Cameras/" + camPng.replace(/[\s\\\/]/g,
                                                           '') + ".png" : ""
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

