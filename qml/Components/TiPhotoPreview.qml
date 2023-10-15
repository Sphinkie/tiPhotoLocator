import QtQuick 2.0
import QtQuick.Layouts 1.15
import "../Javascript/TiUtilities.js" as Utilities

// TODO : ce tab charge les images meme quand il n'est pas visible, ce qui ralenti la GUI
GridView{
    // id: previewView
    model: _onTheMapProxyModel      // Ce modèle ne contient que les photos devant apparaitre sur la carte
    delegate: previewDelegate
    clip: true                      // pour que les items restent à l'interieur de la View
    // Layout.fillWidth: true

    // THE DELEGATE (displays one image and few metadata)
    Component {
        id: previewDelegate

        RowLayout{                          // wrapper
         //   spacing: 20
            required property string filename
            required property int imageWidth
            required property int imageHeight
            required property string camModel
            required property string make
            required property string dateTimeOriginal
            required property string imageUrl

            Image {
                id: previewImage
                Layout.alignment: Qt.AlignCenter
                //Layout.fillWidth: true       // Prend toute la largeur
                Layout.preferredWidth: 600
                Layout.preferredHeight: 600
                // On limite la taille de l'image affichée à la taille du fichier (pas de upscale)
                Layout.maximumHeight: sourceSize.height
                Layout.maximumWidth: sourceSize.width
                fillMode: Image.PreserveAspectFit
                source: imageUrl
            }

            Zone {
                id: zone1
                //Layout.alignment: Qt.AlignRight
                ColumnLayout{
                    Text{
                        Layout.topMargin: 20
                        Layout.leftMargin: 10
                        text: qsTr("Photographie:") }
                    Chips{
                        Layout.leftMargin: 20
                        content: filename
                        editable: false
                        deletable: false
                    }
                    Chips{
                        Layout.leftMargin: 20
//                        content: previewImage.sourceSize.height + "x" + previewImage.sourceSize.height
                        content: imageWidth + " x " + imageHeight
                        editable: false
                        deletable: false
                    }
                    Chips{
                        Layout.leftMargin: 20
                        content: Utilities.toStandardDate(dateTimeOriginal)
                        editable: false
                        deletable: false
                    }
                    Chips{
                        Layout.leftMargin: 20
                        content: Utilities.toStandardTime(dateTimeOriginal)
                        editable: false
                        deletable: false
                    }
                    Text{
                        Layout.leftMargin: 10
                        text: qsTr("Appareil photo:") }
                    Chips{
                        Layout.leftMargin: 20
                        content: make
                        editable: false
                        deletable: false
                    }
                    Chips{
                        Layout.leftMargin: 20
                        content: camModel
                        editable: false
                        deletable: false
                    }
                }
            }
        }
    }
}
