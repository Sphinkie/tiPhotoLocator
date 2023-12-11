import QtQuick
import QtCore
import "../Vues"

IptcGridForm {
    id: iptcGrid
    property string creator
    property string writer

    bt_applyCreator.onClicked: {
        window.applyCreatorToAll()
    }

    Settings {
        id: settings
        property alias photographe: iptcGrid.creator
        property alias initiales: iptcGrid.writer
    }




}
