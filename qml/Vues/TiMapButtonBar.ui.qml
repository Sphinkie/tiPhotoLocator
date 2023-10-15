import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12
import "../Components"

RowLayout {

    property alias showAll_box: showAll_box
    property alias bt_save_pos: bt_save_pos
    property alias bt_remove_pos: bt_remove_pos
    property alias bt_apply_pos: bt_apply_pos
    property alias bt_clear_coords: bt_clear_pos

    CheckBox {
        id: showAll_box
        text: qsTr("Show All")
        // TODO : afficher toutes les photos du dossier
    }

    TiButton {
        id: bt_save_pos
        text: qsTr("Save Position")
        icon.source: "qrc:/Images/mappin-black.png"
        visible: false
        ToolTip.text: qsTr("Mémorise la position de la photo courante")
        ToolTip.visible: hovered
    }

    TiButton {
        id: bt_remove_pos
        text: qsTr("Clear Saved Position")
        icon.source: "qrc:/Images/mappin-strike.png"
        // TODO Attention au cas ou on a vide le modele (reload): il faut masquer ce bouton
        visible: false
    }

    TiButton {
        id: bt_apply_pos
        text: qsTr("Apply Saved Position")
        visible: false
        ToolTip.text: qsTr("Applique la position mémorisée à la photo courante")
        ToolTip.visible: hovered
    }

    Slider {
        id: circle_radius
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        to: 50
    }

    TiButton {
        id: bt_clear_pos
        text: qsTr("Clear GPS Coords")
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        visible: false
        ToolTip.text: qsTr("Efface les coordonnées GPS de la photo (si besoin de confidentialité)")
        ToolTip.visible: hovered
    }
}
