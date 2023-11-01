import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../Components"



Item {
    property alias bt_save_pos: bt_save_pos
    property alias bt_remove_pos: bt_remove_pos
    property alias bt_apply_pos: bt_apply_pos
    property alias bt_clear_coords: bt_clear_pos
    property alias slider_radius: slider_radius
    property alias bt_get_info: bt_get_info

    height: bt_save_pos.height + 20

    TiButton {
        id: bt_save_pos
        enabled: false
        text: qsTr("Save Position")
        icon.source: "qrc:/Images/mappin-black.png"
        ToolTip.text: qsTr("Mémorise la position de la photo courante")
        ToolTip.visible: hovered
        ToolTip.delay: 500
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.verticalCenter: parent.verticalCenter
    }

    TiButton {
        id: bt_remove_pos
        enabled: false
        text: qsTr("Clear Saved Position")
        icon.source: "qrc:/Images/mappin-strike.png"
        anchors.left: bt_save_pos.right
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        // TODO Attention au cas ou on a vide le modele (reload): il faut masquer ce bouton
    }

    TiButton {
        id: bt_apply_pos
        enabled: false
        text: qsTr("Apply Saved Position")
        icon.source: "qrc:/Images/mappin-go.png"
        ToolTip.text: qsTr("Applique la position mémorisée à la photo courante")
        ToolTip.visible: hovered
        ToolTip.delay: 500
        anchors.left: bt_remove_pos.right
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
    }

    Slider {
        id: slider_radius
        enabled: false
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        to: 2000 // unité = 1 mètre
        anchors.left: bt_apply_pos.right
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
    }

    TiButton {
        id: bt_get_info
        text: qsTr("Get Info")
        anchors.left: slider_radius.right
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
    }

    TiButton {
        id: bt_clear_pos
        enabled: false
        text: qsTr("Clear GPS Coords")
        icon.source: "qrc:/Images/suppr-icon.png"
        anchors.right: parent.right
        anchors.rightMargin: 40
        anchors.verticalCenter: parent.verticalCenter
        ToolTip.text: qsTr("Efface les coordonnées GPS de la photo (si besoin de confidentialité)")
        ToolTip.visible: hovered
        ToolTip.delay: 500
    }
}
