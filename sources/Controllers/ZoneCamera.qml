import QtQuick
import "../Vues"

// Controlleur de la zone avec les informations sur l'appareil ayant fabrqué l'image (appareil photo ou scanner ou IA)
ZoneCameraForm {

    // On determine le contenu des chips ici, mais ça marche aussi si on le fait dans la vue.

    chipModel.content:  tabbedPage.selectedData.camModel
    chipMaker.content:  tabbedPage.selectedData.make
    chipFocale.content: tabbedPage.selectedData.aperture
    chipSpeed.content:  tabbedPage.selectedData.speed
    chipSoftware.content: tabbedPage.selectedData.software

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
