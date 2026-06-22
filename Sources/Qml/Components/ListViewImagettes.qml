import QtQuick
import QtQuick.Controls.Material


/** **********************************************************************************************************
 * @brief QML: Liste (sur une ligne horizontale) des imagettes des photos sélectionnées.
 * Cette ListView est basée sur le Model _onTheMapProxyModel (ensemble des photos à l'intérieur du cercle).
 * La photo qui est sélectionné dans la listView principale a un cadre.
 * ***********************************************************************************************************/
ListView {
    spacing: 4
    leftMargin: 16
    orientation: Qt.Horizontal
    clip: true
    model: _onTheMapProxyModel
    focus: false

    signal imageClicked(string imageUrl)

    /** ******************************************************************************************************
     * Le delegate pour afficher chaque imagette dans la ListView. L'image courante a un cadre.
     * *******************************************************************************************************/
    delegate: Rectangle {
        id: delegateImagette
        required property string imageUrl
        required property bool isCurrent
        width: 160
        height: 160
        radius: 4
        border.color: isCurrent ? Material.accentColor : "transparent"
        border.width: 3
        Image {
            width: 154
            height: 154
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            source: delegateImagette.imageUrl
            asynchronous: true
            smooth: false
        }
        MouseArea {
            anchors.fill: parent
            onClicked: delegateImagette.ListView.view.imageClicked(delegateImagette.imageUrl)
        }
    }
}
