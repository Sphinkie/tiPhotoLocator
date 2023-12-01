import QtQuick
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities


// Controlleur de la zone avec les informations sur la photo
ZonePhotoForm {

    chipCreator.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "artist");
        tabbedPage.refreshSelectedData();
    }

    chipDescription.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "description");
        tabbedPage.refreshSelectedData();
    }

    chipWriter.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "descriptionWriter");
        tabbedPage.refreshSelectedData();
    }

    // On raffraichit la zone si SelectedData est modifiée
    Connections{
        target: tabbedPage
        function onSelectedDataChanged()
        {
            console.log("onSelectedDataChanged->ZonePhoto");
            chipDate.content = Utilities.toStandardDate(tabbedPage.selectedData.dateTimeOriginal)
            chipTime.content = Utilities.toStandardTime(tabbedPage.selectedData.dateTimeOriginal)
            chipCreator.content = tabbedPage.selectedData.artist
            chipDescription.content = tabbedPage.selectedData.description
            chipWriter.content = tabbedPage.selectedData.descriptionWriter
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
