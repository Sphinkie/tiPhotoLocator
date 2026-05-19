import QtQuick
import QtQuick.Controls.Material


/** **********************************************************************************************************
 * @brief Popup d'aperçu d'une imagette en grand format (largeur max 1080px).
 * Se ferme sur clic (intérieur ou extérieur) ou touche Echap.
 * ***********************************************************************************************************/
Popup {
    property string imageSource: ""

    property real naturalWidth:  previewImage.sourceSize.width
    property real naturalHeight: previewImage.sourceSize.height
    width:  naturalWidth  > 0 ? Math.min(naturalWidth, 1080) : 400
    height: naturalWidth  > 0 ? width * naturalHeight / naturalWidth : 300

    parent: Overlay.overlay
    anchors.centerIn: Overlay.overlay
    modal: true
    padding: 0
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Rectangle { radius: 6; border.width: 2 }

    Image {
        id: previewImage
        anchors.fill: parent
        source: imageSource
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        MouseArea {
            anchors.fill: parent
            onClicked: close()
        }
    }
}
