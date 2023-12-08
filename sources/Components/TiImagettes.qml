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
            width: 500   // TODO ajuster la largeur automatiquement
            height: 104

            // width: parent.width  // => les images n'apparaissent plus
            // Layout.fillWidth: true
        }

        Rectangle {
            width: 15
            height: 104
            color: "green"
        }


    }

}
