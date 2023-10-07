import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12


RowLayout {

    CheckBox {
        id: showAll_box
        text: qsTr("Show All")
        // TODO : afficher toutes les photos du dossier
    }

    TiButton {
        id: bt_save_pos
        text: qsTr("Save Position")
        icon.source: "qrc:/Images/mappin-green.png"
        // onClicked: // TODO
    }

    TiButton {
        id: bt_apply_pos
        text: qsTr("Apply Saved Position")
        // onClicked:// TODO
    }

    TiButton {
        id: bt_clear_pos
        text: qsTr("Clear Position")
        // onClicked:// TODO
    }
}
