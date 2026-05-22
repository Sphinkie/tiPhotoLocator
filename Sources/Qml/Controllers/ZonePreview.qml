import QtQuick
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities


/** **********************************************************************************************************
 * @brief QML: Controleur pour la Zone des informations de Preview.
 * tabbedPage est l'item parent qui contient les infos sur la photo sélectionnée dans la listview (currentPhoto),
 * et qui les partage avec tous ses onglets (sous-items).
 * ***********************************************************************************************************/
ZonePreviewForm {

    /// Le flag isWelcome sert à savoir si on est positionné sur un filename ou sur l'item de bienvenue au démarrage.
    readonly property bool isWelcome: _photoModel.count === 0

    /// Texte de bienvenue (avec possibilité de style)
    readonly property string bienvenue: qsTr("Welcome!")
    readonly property string brief: qsTr("<b>TiPhotoLocator</b> helps you geotag and tag your photos.")
    readonly property string usage: qsTr("To get started, open the folder containing your photos via the menu <pre>Folders → Open...</pre><br>Then navigate the tabs to fill in the various tags.")
    readonly property string note: qsTr("<u>Note:</u> Modified data is saved into the photos only when you click the <pre>'Save'</pre> button")
    readonly property string br: "<br><br>"

    welcomeText: isWelcome ? br + br + bienvenue + br + brief + br + usage + br + note : ""

    txtZone: isWelcome ? "" : qsTr("Summary")
    // assignChips (!isWelcome)

    // On determine le contenu des Chips ici.
    chipName.content: isWelcome ? "TiPhotoLocator" : tabbedPage.currentPhoto.filename
    chipSize.content: Utilities.toReadableSize(
                          tabbedPage.currentPhoto.imageWidth,
                          tabbedPage.currentPhoto.imageHeight)
    chipDate.content: Utilities.toReadableDate(
                          tabbedPage.currentPhoto.dateTimeOriginal)
    chipTime.content: Utilities.toReadableTime(
                          tabbedPage.currentPhoto.dateTimeOriginal)
    chipMake.content: tabbedPage.currentPhoto.make
    chipCamModel.content: tabbedPage.currentPhoto.camModel
    chipSpeed.content: Utilities.toReadableSpeed(
                           tabbedPage.currentPhoto.shutterSpeed)
    chipAperture.content: Utilities.toReadableAperture(
                              tabbedPage.currentPhoto.fNumber)
    chipCountry.content: tabbedPage.currentPhoto.country
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

