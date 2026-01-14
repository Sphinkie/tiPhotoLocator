import QtQuick
import ".."

Rectangle {
    height: 50
    width: 80
    color: Style.surfaceContainerColor
    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "/Images/logo_TPL.png"
        anchors {
            top: parent.top
            left: parent.left
        }
    }
}
