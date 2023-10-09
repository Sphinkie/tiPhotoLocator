import QtQuick 2.0
import QtQuick.Layouts 1.15
import "TiUtilities.js" as Utilities

// TODO : ce tab charge les images même quand il n'est pas visible, ce qui ralenti la GUI
GridView{
    // id: previewView
    model: _selectedPhotoModel      // Ce modèle ne contient que la photo sélectionnée dans la ListView
    delegate: previewDelegate
    clip: true                      // pour que les items restent à l'interieur de la View
    // Layout.fillWidth: true

    // THE DELEGATE (displays one image and few metadata)
    Component {
        id: previewDelegate

        RowLayout{                          // wrapper
         //   spacing: 20
           // height: parent.height
           // width: parent.width
            required property int imageWidth
            required property int imageHeight
            required property string camModel
            required property string make
            required property string dateTimeOriginal
            required property string imageUrl

            Image {
                id: previewImage
                //property int clickedItem: -1
                //                            property url imageURl: "qrc:///Images/kodak.png"
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: 600
                Layout.preferredHeight: 600
                // On limite la taille de l'image affichée à la taille du fichier (pas de upscale)
                Layout.maximumHeight: sourceSize.height
                Layout.maximumWidth: sourceSize.width
                fillMode: Image.PreserveAspectFit
                source: imageUrl
                /*  onClickedItemChanged: {
                        // TODO: comment recupérer les données du modèle quand on est dans une fonction et pas dans un delegate?
                        //      il faut utiliser une méthode...
                        //      ou utiliser des delegate, ce qui semble être la méthode recommandée
                        //
                        // console.log("onClickedItemChanged:"+clickedItem);
                        // console.log(listModel.get(clickedItem).name);
                        // console.log(listModel.get(clickedItem).imageUrl);
                        // imageURl = Qt.resolvedUrl(_photoListModel.get(clickedItem).imageUrl);
                        imageURl = Qt.resolvedUrl(_photoListModel.getUrl(clickedItem));
                        console.log("data returns: ");
                        console.log(_photoListModel.data(_photoListModel.index(clickedItem,_photoListModel.ImageUrlRole), _photoListModel.ImageUrlRole));
                    }*/
            }

            Zone {
                id: zone1
                //Layout.alignment: right
                ColumnLayout{
                    Text{
                        Layout.topMargin: 20
                        Layout.leftMargin: 10
                        text: qsTr("Photographie:") }
                    Pastille{
                        Layout.leftMargin: 20
//                        content: previewImage.sourceSize.height + "x" + previewImage.sourceSize.height
                        content: imageWidth + " x " + imageHeight
                        editable: false
                        deletable: false
                    }
                    Pastille{
                        Layout.leftMargin: 20
                        content: Utilities.toStandardDate(dateTimeOriginal)
                        editable: false
                        deletable: false
                    }
                    Pastille{
                        Layout.leftMargin: 20
                        content: Utilities.toStandardTime(dateTimeOriginal)
                        editable: false
                        deletable: false
                    }
                    Text{
                        Layout.leftMargin: 10
                        text: qsTr("Appareil photo:") }
                    Pastille{
                        Layout.leftMargin: 20
                        content: camModel
                        editable: false
                        deletable: false
                    }
                    Pastille{
                        Layout.leftMargin: 20
                        content: make
                        editable: false
                        deletable: false
                    }
                }
            }
        }
    }
}
