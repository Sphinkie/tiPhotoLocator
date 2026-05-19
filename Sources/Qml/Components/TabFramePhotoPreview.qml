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
            height: Math.min(sourceSize.height, parent.height)
            width: Math.min(sourceSize.width, parent.width)
            anchors.centerIn: parent
            asynchronous: true
        }

        // Flèche gauche : photo précédente
        Rectangle {
            id: prevArrow
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: 80
            radius: 4
            color: prevMouse.containsMouse ? "#80000000" : "#40000000"
            visible: photoListView.currentIndex > 0

            Text {
                anchors.centerIn: parent
                text: "◄"
                color: "white"
                font.pixelSize: 22
            }

            MouseArea {
                id: prevMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: photoListView.navigatePrev()
            }
        }

        // Flèche droite : photo suivante
        Rectangle {
            id: nextArrow
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: 80
            radius: 4
            color: nextMouse.containsMouse ? "#80000000" : "#40000000"
            visible: photoListView.currentIndex < photoListView.count - 1

            Text {
                anchors.centerIn: parent
                text: "►"
                color: "white"
                font.pixelSize: 22
            }

            MouseArea {
                id: nextMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: photoListView.navigateNext()
            }
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
