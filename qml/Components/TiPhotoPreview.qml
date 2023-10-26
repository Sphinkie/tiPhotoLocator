import QtQuick 2.0
import QtQuick.Layouts 1.15
import "../Controllers"


// TODO : ce tab charge les images meme quand il n'est pas visible, ce qui ralenti la GUI

        RowLayout {
            anchors.fill: parent

            Image {
                id: previewImage
                Layout.alignment: Qt.AlignHCenter   //  | Qt.AlignVCenter
                Layout.fillWidth: true       // Prend toute la largeur disponible
                // TODO : occuper toute la hauteur disponible
                // On limite pour les grandes photos
                Layout.preferredWidth: 600
                Layout.preferredHeight: 600
                // On limite la taille de l'image affichée à la taille du fichier (pas de upscale)
                Layout.maximumHeight: sourceSize.height
                Layout.maximumWidth: sourceSize.width
                fillMode: Image.PreserveAspectFit
                source: tabbedPage.selectedData.imageUrl
            }

            ZonePreview {
                id: zone1
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 30
                Layout.topMargin: 30
            }

        }

