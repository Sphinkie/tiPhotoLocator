import QtQuick
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities


/** **********************************************************************************************************
 * @brief Controlleur.
 * ***********************************************************************************************************/
ZonePreviewForm {

    readonly property bool isphoto: !tabbedPage.selectedData.isWelcome
    // Styled text
    readonly property string bienvenue: qsTr("Bienvenue !")
    readonly property string brief: qsTr("<b>TiPhotoLocator</b> vous aide à géolocaliser et tagger vos photos.")
    readonly property string usage: qsTr("Pour commencer, ouvrez le répertoire contenant les photos avec le menu <pre>Dossiers → Ouvrir...</pre><br>Puis naviguez dans les onglets pour renseigner les différents tags.")
    readonly property string note: qsTr("<u>Note:</u> Les données modifiées sont enregistrées dans les photos, uniquement lors du clic sur le bouton <pre>'Enregistrer'.</pre>")
    readonly property string br: "<br><br>"

    welcomeText: isphoto ? "" : br + bienvenue + br + brief + br + usage + br + note

    txtZone: isphoto ? qsTr("Summary") : ""

    // On determine le contenu des champs ici, mais ça marche aussi si on le fait dans la vue.
    chipName.content: isphoto ? tabbedPage.selectedData.filename : ""
    chipSize.content: isphoto ? tabbedPage.selectedData.imageWidth + " x "
                                + tabbedPage.selectedData.imageHeight : ""
    chipDate.content: Utilities.toReadableDate(
                          tabbedPage.selectedData.dateTimeOriginal)
    chipTime.content: Utilities.toReadableTime(
                          tabbedPage.selectedData.dateTimeOriginal)
    chipMake.content: tabbedPage.selectedData.make
    chipCamModel.content: tabbedPage.selectedData.camModel
    chipCountry.content: tabbedPage.selectedData.country
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

