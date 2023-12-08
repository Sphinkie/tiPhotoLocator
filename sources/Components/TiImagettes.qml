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
            // width: 500
            Layout.fillWidth: true
            Layout.rightMargin: 20
            height: 104

        }

        Rectangle {
            width: 15
            height: 104
            color: "green"
        }


    }

}
