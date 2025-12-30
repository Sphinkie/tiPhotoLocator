import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"


/** *****************************************************************************
 * @brief Les onglets principaux.
 * On laisse le controle Material gérer l'IHM.
 *
 * @TODO : mettre dans Bookstack la méthode de customisation
 * @TODO : dans universal colors on a du gras ?
 * ******************************************************************************/
TabButton {
    id: control
    height: 32 // filtersAndTabslayout.height
    text: control.text


    /*
    contentItem: Text {
        text: control.text
        color: control.down ? "white" : "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        font.pointSize: 10
        font.styleName: "Gras"
        font.letterSpacing: 2
    }

    background: Rectangle {
        color: control.checked ? Style.chipBackgroundColor : Style.zoneBackgroundColor.lighter(1.1)
        radius: 3
    }
*/
}
