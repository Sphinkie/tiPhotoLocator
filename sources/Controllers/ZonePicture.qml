import QtQuick
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities


// Controlleur de la zone avec les informations sur la photo
ZonePictureForm {

    // On determine le contenu des chips ici.

    chipDate.content: Utilities.toStandardDate(tabbedPage.selectedData.dateTimeOriginal)
    chipTime.content: Utilities.toStandardTime(tabbedPage.selectedData.dateTimeOriginal)
    chipCreator.content:  tabbedPage.selectedData.artist
    chipDescription.content: "TODO: multiline description"
    chipWriter.content:   tabbedPage.selectedData.descriptionWriter

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
