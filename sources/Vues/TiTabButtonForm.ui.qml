import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../Components"

TabButton {
    id: control
    height: filtersAndTabslayout.height

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.down ? "white" : "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        color: control.checked ? TiStyle.chipBackgroundColor : TiStyle.zoneBackgroundColor
        radius: 3
    }
}
