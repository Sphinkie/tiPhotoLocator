import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12

// ----------------------------------------------------------------
// Modal popup for the "About..." window
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
        ColumnLayout{
            anchors.fill: parent
            Text { text: qsTr("TiPhotoLocator permet de placer ses photos sur une carte, et d'éditer les tags Exif internes à la photo.")}
            Text { text: qsTr("TiPhotoLocator est gratuit et sans publicité.")}
            Text { text: qsTr("Programme réalisé par David de Lorenzo.")}
            Text { text: "\n" + qsTr("Credits:")}
            Text { text: qsTr("- Le freeware GeoSetter pour l'idée initiale.")}
            Text { text: qsTr("- la librairie Exiv2 pour la gestion des données EXIF.")}
            Button {
                text: "Close"
                onClicked: about.close()
            }
        }
    }
}
