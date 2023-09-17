import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12

// ----------------------------------------------------------------
// Modal popup for the "About..." windows
// ----------------------------------------------------------------
Popup {
    anchors.centerIn: Overlay.overlay
    width: 200
    height: 300
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    padding: 8
    // TODO: Mettre en forme
    background: Rectangle {
        width: parent.width
        height: parent.height
        color: "white"
    }
    contentItem: Text {
        Column{
            Text { text: qsTr("TiPhotoLocator a été concu en remplacement du freeware GeoSetter.")}
            Text { text: qsTr("Il permet de placer ses photos sur une carte, et d'éditer les tags Exif internes à la photo.")}
            Text { text: qsTr("Programme réalisé par David de Lorenzo.")}
            Button {
                text: "Close"
                onClicked: about.close()
            }
        }
    }
}
