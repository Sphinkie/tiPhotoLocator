import QtQuick
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities

// Controlleur
ZonePreviewForm {

    readonly property bool isphoto : ! tabbedPage.selectedData.isWelcome

    txtPreviewZone : isphoto ? qsTr("Photo") : qsTr("Bienvenue\n\nNote: Les données modifiées sont enregistrées dans les photos uniquement lors du clic sur le bouton 'Enregistrer'.")

    // On determine le contenu des champs ici, mais ça marche aussi si on le fait dans la vue.

    chipName.content: isphoto? tabbedPage.selectedData.filename : ""
    chipSize.content: isphoto? tabbedPage.selectedData.imageWidth + " x " + tabbedPage.selectedData.imageHeight : ""
    chipDate.content: Utilities.toStandardDate(tabbedPage.selectedData.dateTimeOriginal)
    chipTime.content: Utilities.toStandardTime(tabbedPage.selectedData.dateTimeOriginal)
    chipMake.content: tabbedPage.selectedData.make
    chipCamModel.content: tabbedPage.selectedData.camModel

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
