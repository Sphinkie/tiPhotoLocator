import QtQuick 2.0
import QtQuick.Layouts 1.15
import "../Controllers"


// TODO : ce tab charge les images meme quand il n'est pas visible, ce qui ralenti la GUI

RowLayout {
    anchors.fill: parent

    Item{
        Layout.fillWidth: true       // Prend toute la largeur disponible
        Layout.fillHeight: true      // Occuper toute la hauteur disponible
        Image {
            id: previewImage
            // On limite pour les grandes photos
            Layout.preferredWidth: 600
            Layout.preferredHeight: 600
            // On limite la taille de l'image affichée à la taille du fichier (pas de upscale)
            Layout.maximumHeight: sourceSize.height
            Layout.maximumWidth: sourceSize.width
            fillMode: Image.PreserveAspectFit
            source: tabbedPage.selectedData.imageUrl
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

