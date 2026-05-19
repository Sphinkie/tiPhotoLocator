import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"


/** **********************************************************************************************************
 * @brief Cette vue correspond à la barre d'outils spécifiques à la carte.
 * ***********************************************************************************************************/
Item {
    property alias txt_find: txt_find
    property alias bt_find: bt_find
    property alias bt_next: bt_next
    property alias bt_save_pos: bt_save_pos
    property alias bt_remove_savedpos: bt_remove_savedpos
    property alias bt_apply_savedpos: bt_apply_savedpos
    property alias slider_radius: slider_radius
    property alias bt_revert: bt_revert

    height: bt_save_pos.height + 20

    TextField {
        id: txt_find
        height: 40
        width: 160
        placeholderText: qsTr("Find a place")
        anchors {
            left: parent.left
            leftMargin: 0
            verticalCenter: parent.verticalCenter
        }
    }
    RoundButton {
        id: bt_find
        enabled: txt_find.text !== ""
        icon.source: "qrc:/Images/bt-find.png"
        anchors {
            left: txt_find.right
            leftMargin: 0
            verticalCenter: parent.verticalCenter
        }
    }

    RoundButton {
        id: bt_next
        enabled: txt_find.text !== ""
        icon.source: "qrc:/Images/bt-next.png"
        anchors {
            left: bt_find.right
            leftMargin: 0
            verticalCenter: parent.verticalCenter
        }
    }

    Button {
        id: bt_save_pos
        enabled: false
        text: qsTr("Save Position")
        icon.source: "qrc:/Images/mappin-black.png"
        ToolTip.text: qsTr("Store the position of the current photo")
        ToolTip.visible: hovered
        ToolTip.delay: 500
        anchors {
            left: bt_next.right
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
    }

    Button {
        id: bt_remove_savedpos
        enabled: false
        text: qsTr("Clear Saved Position")
        icon.source: "qrc:/Images/bt-clear.png"
        anchors {
            left: bt_save_pos.right
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
    }

    Button {
        id: bt_apply_savedpos
        enabled: false
        text: qsTr("Apply Saved Position")
        icon.source: "qrc:/Images/bt-apply.png"
        ToolTip.text: qsTr("Apply the stored position to the current photo")
        ToolTip.visible: hovered
        ToolTip.delay: 500
        anchors {
            left: bt_remove_savedpos.right
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
    }

    Slider {
        id: slider_radius
        enabled: false
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        to: 4000 // unité = 1 mètre
        //onMoved: slider_label.text = Math.round(slider_radius.value/10)/100 + " km"
        anchors {
            left: bt_apply_savedpos.right
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
    }
    Label {
        id: slider_label
        anchors {
            left: slider_radius.right
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
        text: Math.round(slider_radius.value / 10) / 100 + " km"
    }

    Button {
        id: bt_revert
        enabled: false
        text: qsTr("Restore")
        icon.source: "qrc:/Images/bt-revert.png"
        anchors {
            left: slider_label.right
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
        ToolTip.text: qsTr("Reload the initial GPS coordinates of the photo")
        ToolTip.visible: hovered
        ToolTip.delay: 500
    }
}
