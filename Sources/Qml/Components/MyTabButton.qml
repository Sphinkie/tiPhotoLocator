import QtQuick
import QtQuick.Controls
import ".."

/** **********************************************************************************************************
 * @brief Surcharge de TabButton pour dissocier la couleur du texte de la couleur d'accent.
 *
 * Par défaut, Qt Material colore le texte de l'onglet actif avec la couleur accent
 * (Amber), ce qui donne un contraste insuffisant sur le fond BlueGrey clair.
 * On force ici un texte foncé, tout en laissant Qt gérer l'indicateur (underline)
 * en couleur accent — ce qui suffit à signaler l'onglet actif.
 * **********************************************************************************************************/
TabButton {
    contentItem: Text {
        text: parent.text
        font.bold: parent.checked
        font.pixelSize: parent.font.pixelSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: parent.checked ? Style.accentTabTextColor : Style.foregroundColor
    }
}
