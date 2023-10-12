import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12  // pour Frame

Frame {
    Layout.preferredHeight: 120

    ListView {
        height: 120
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        orientation: Qt.Horizontal
        delegate:
            Image {
            width: 130
            height: 100
            fillMode: Image.PreserveAspectFit
            source: modelData
        }
    }
}
