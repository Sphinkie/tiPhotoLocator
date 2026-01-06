import QtQuick
import QtQuick.Controls.Material
import "../Components"


/** *****************************************************************************
 * @brief Les onglets principaux.
 * On laisse le controle Material gérer l'IHM.
 * ******************************************************************************/
TabButton {
    id: control
    height: 32
    text: control.text
}
