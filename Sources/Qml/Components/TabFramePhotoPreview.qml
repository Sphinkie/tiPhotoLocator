import QtQuick
import QtQuick.Layouts
import "../Controllers"


/** *************************************************************************************
 * @brief QML: Composition de la page de l'onglet "PREVIEW".
 * *************************************************************************************/
RowLayout {


    /** ********************************************************************************
     * Une grande image de la photo occupe presque toute la page.
     * *********************************************************************************/
    Item {
        Layout.fillWidth: true // Occupe toute la largeur disponible
        Layout.fillHeight: true // Occupe toute la hauteur disponible
        clip: true // Tronque l'image au cas où elle deborderait


        /** ****************************************************************************
         * previewImage: L'image est chargée uniquement quand l'onglet n'est pas visible,
         * pour des raisons de performances.
         * *****************************************************************************/
        Image {
            id: previewImage
            source: (tabbedPage.currentIndex === 0) ? tabbedPage.currentPhoto.imageUrl : ""
            fillMode: Image.PreserveAspectFit
            // On limite les grandes photos à la taille de la page: (image affichée avec downscale)
            // On limite les petites photos à leur taille réelle: (image affichée sans upscale)
            height: Math.min(sourceSize.height, parent.height)
            width: Math.min(sourceSize.width, parent.width)
            // Centrer l'image
            anchors.centerIn: parent
            asynchronous: true
        }
    }


    /** ********************************************************************************
     * zonePreview: Une Zone à droite avec quelques Chips informatifs.
     * *********************************************************************************/
    ZonePreview {
        id: zonePreview
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignRight
        Layout.rightMargin: 40
        Layout.margins: 30
    }
}
