import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"

TabButton {
    id: control
    height: 32 // filtersAndTabslayout.height

    contentItem: Text {
        text: control.text
        // DDL color: control.down ? "white" : "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        font.pointSize: 10
        font.styleName: "Gras"
        font.letterSpacing: 2
    }

    background: Rectangle {
        // DDL color: control.checked ? TiStyle.chipBackgroundColor : TiStyle.zoneBackgroundColor.lighter(1.1)
        radius: 3
    }
}
