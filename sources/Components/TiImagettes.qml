import QtQuick
import QtQuick.Layouts

Rectangle {
    Layout.preferredHeight: 120
    color: TiStyle.surfaceContainerColor

    RowLayout{
        anchors.fill: parent
        anchors.leftMargin: listViewFrame.width
        anchors.topMargin: 8

        Rectangle {
            width: 15
            height: 104
            color: "green"
        }

        ImagettesListView{
            Layout.fillWidth: true
            height: 104
        }

        Rectangle {
            width: 15
            height: 104
            Layout.rightMargin: 20
            color: "green"
        }

    }

}
