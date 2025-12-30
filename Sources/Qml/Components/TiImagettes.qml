import QtQuick
import QtQuick.Layouts


/** **********************************************************************************************************
 * @brief Rectangle contenant les imagettes des photos sélectionnées.
 * @warning OBSOLETE
 * ***********************************************************************************************************/
Rectangle {
    Layout.preferredHeight: 120

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: listViewFrame.width
        anchors.topMargin: 8

        ImagettesListView {
            Layout.fillWidth: true
            height: 104
            Layout.rightMargin: 30
        }
    }
}
