import QtQuick 2.4
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities

// Controlleur
ZonePreviewForm {

    // On determine le contenu des champs ici, mais ça marche aussi si on le fait dans la vue.

    chipName.content: tabbedPage.selectedData.filename
    chipSize.content: tabbedPage.selectedData.imageWidth + " x " + tabbedPage.selectedData.imageHeight
    chipDate.content: Utilities.toStandardDate(tabbedPage.selectedData.dateTimeOriginal)
    chipTime.content: Utilities.toStandardTime(tabbedPage.selectedData.dateTimeOriginal)
    chipMake.content: tabbedPage.selectedData.make
    chipCamModel.content: tabbedPage.selectedData.camModel

}
