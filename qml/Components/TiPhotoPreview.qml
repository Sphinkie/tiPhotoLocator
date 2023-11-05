import QtQuick
import QtQuick.Layouts
//import "../Components"
import "../Controllers"


// TODO : ce tab charge les images même quand il n'est pas visible, ce qui ralenti la GUI

RowLayout {

    Item{
        Layout.fillWidth: true       // Prend toute la largeur disponible
        Layout.fillHeight: true      // Occuper toute la hauteur disponible
        clip: true                   // Tronque l'image au cas où elle deborderait
        Image {
            id: previewImage
            source: tabbedPage.selectedData.imageUrl
            fillMode: Image.PreserveAspectFit
            // On limite les grandes photos à la taille de la page: (image affichée avec downscale)
            // On limite les petites photos à leur taille réelle: (image affichée sans upscale)
            height: Math.min (sourceSize.height, parent.height)
            width: Math.min (sourceSize.width, parent.width)
            // Centrer l'image
            anchors.centerIn: parent
        }
    }

    ZonePreview {
        id: zonePreview
        Layout.alignment: Qt.AlignRight
        Layout.rightMargin: 30
        Layout.topMargin: 30
    }

}

