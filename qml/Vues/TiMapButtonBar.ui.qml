import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12
import "../Components"

RowLayout {

    property alias bt_save_pos: bt_save_pos
    property alias bt_remove_pos: bt_remove_pos
    property alias bt_apply_pos: bt_apply_pos
    property alias bt_clear_coords: bt_clear_pos
    property alias slider_radius: slider_radius

    TiButton {
        id: bt_save_pos
        enabled: false
        text: qsTr("Save Position")
        icon.source: "qrc:/Images/mappin-black.png"
        ToolTip.text: qsTr("Mémorise la position de la photo courante")
        ToolTip.visible: hovered
        ToolTip.delay: 500
    }

    TiButton {
        id: bt_remove_pos
        enabled: false
        text: qsTr("Clear Saved Position")
        icon.source: "qrc:/Images/mappin-strike.png"
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
    }

    Slider {
        id: slider_radius
        enabled: false
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        to: 2000 // unité = 1 mètre
    }

    TiButton {
        id: bt_clear_pos
        enabled: false
        text: qsTr("Clear GPS Coords")
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        ToolTip.text: qsTr("Efface les coordonnées GPS de la photo (si besoin de confidentialité)")
        ToolTip.visible: hovered
        ToolTip.delay: 500
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

