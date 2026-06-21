import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"

/** **********************************************************************************************************
 * @brief Cette vue correspond à la barre d'outils spécifiques à la carte (onglet GPS Logger).
 * ***********************************************************************************************************/
Item {
    property alias bt_next: bt_next
    property alias bt_apply_all: bt_apply_all
    property alias bt_apply_point: bt_apply_point
    property alias slider_radius: dummy_slider
    property alias bt_revert: bt_revert

    height: bt_apply_point.height + 20

    RoundButton {
        id: bt_next
        enabled: false
        icon.source: "qrc:/Images/bt-next.png"
        anchors {
            left: parent.left
            leftMargin: 0
            verticalCenter: parent.verticalCenter
        }
    }

    Button {
        id: bt_apply_point
        enabled: false
        text: qsTr("Apply track point")
        icon.source: "qrc:/Images/bt-apply.png"
        anchors {
            left: bt_next.right
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
        ToolTip {
            visible: parent.hovered
            text: qsTr("Apply the track point to the current photo")
            delay: 500
            y: -height - 4
        }
    }

    Button {
        id: bt_apply_all
        enabled: false
        text: qsTr("Apply All")
        icon.source: "qrc:/Images/bt-apply.png"
        anchors {
            left: bt_apply_point.right
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
    }

    Slider {
        id: dummy_slider
        enabled: false
        visible: false
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        to: 10
        value: 0
        anchors {
            left: bt_apply_all.right
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
    }

    Button {
        id: bt_revert
        enabled: false
        text: qsTr("Restore")
        icon.source: "qrc:/Images/bt-revert.png"
        anchors {
            left: dummy_slider.right
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
        ToolTip {
            visible: parent.hovered
            text: qsTr("Reload the initial GPS coordinates of the photo")
            delay: 500
            y: -height - 4
        }
    }
}
