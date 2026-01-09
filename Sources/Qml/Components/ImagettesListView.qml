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
    model: _onTheMapProxyModel
    focus: false


    /** ******************************************************************************************************
     * Le delegate pour afficher l'imagette dans la ListView.
     * *******************************************************************************************************/
    delegate: Rectangle {
        required property string imageUrl
        required property bool isSelected
        width: 160
        height: 160
        radius: 4
        border.color: isSelected ? Material.accentColor : "transparent"
        border.width: 3
        Image {
            id: image
            width: 154
            height: 154
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            source: imageUrl
            asynchronous: true
            // Smooth filtering gives better visual quality, but it may be slower on some hardware.
            smooth: false
        }
    }
}
