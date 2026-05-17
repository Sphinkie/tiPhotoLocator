import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Material
import ".."


/** **********************************************************************************************************
 * @brief Ce composant reproduit un MaterialDesign::Chip en se basant sur un Qt Rectangle.
 * A noter que l'ombre doit être définie avant le rectangle, de façon à être dessinée avant, donc dessous.
 * A noter que le Rectangle contient un texte, mais ne s'adapte pas automatiquement à la longueur du texte.
 * C'est plutot le texte qui s'adapte au rectangle parent.
 * @see {https://doc.qt.io/qt-5/qml-qtquick-controls2-label.html}
 * ***********************************************************************************************************/
Item {
    property bool canSave: false ///< type:bool Fait apparaitre le mini-bouton Save.
    property bool editable: false ///< type:bool Fait apparaitre le mini-bouton Edit.
    property bool deletable: false ///< type:bool Fait apparaitre le mini-bouton Delete.
    /// type:string le texte du Chips
    property string content
    /// type:string Le label du Chips
    property string targetName
    property alias editArea: editArea ///< type:MouseArea Zone cliquable du mini-bouton Edit.
    property alias saveArea: saveArea ///< type:MouseArea Zone cliquable du mini-bouton Save.
    property alias revertArea: revertArea ///< type:MouseArea Zone cliquable du mini-bouton Revert.
    property alias deleteArea: deleteArea ///< type:MouseArea Zone cliquable du mini-bouton Delete.
    /// Pour le controle inviduel des items
    property alias chipText: chipText
    property bool hideTargetWhenFilled: false ///< type:bool Si true, le targetName disparait dès que content est renseigné (pour FatChip).
    // Les différents Chips doivent être dans un ColumLayout. On peut ainsi les aligner tous de la même façon.
    Layout.topMargin: 10 ///< marge haut (outside the item)
    Layout.leftMargin: 20 ///< marge gauche (outside the item)
    implicitHeight: 32 ///< Hauteur préférée si height n'est pas spécifiée.
    implicitWidth: 280 ///< Largeur préférée si width n'est pas spécifiée.


    /** ************************************************************************************
     * Ombre sous le Chip. (Avec Material, on pourrait utiliser 'elevation').
     * *************************************************************************************/
    RectangularShadow {
        id: chipShadow
        anchors.fill: chipRectangle
        offset.x: 10
        offset.y: 10
        radius: 8
        blur: 20
        spread: 0
        color: Qt.darker(chipRectangle.color, 1.6)
        visible: chipRectangle.visible
        cached: true // Performances. Mettre false pour les objets animés uniquement.
    }


    /** ************************************************************************************
     * Rectangle du Chip.
     * *************************************************************************************/
    Rectangle {
        id: chipRectangle
        radius: 16
        visible: content ? true : false
        color: Style.chipBackgroundColor
        anchors.fill: parent


        /** ************************************************************************************
         * Icone "crayon" pour modifier la valeur du tag.
         * *************************************************************************************/
        Image {
            id: chipEdit
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            height: 26
            width: 26
            source: "qrc:/Images/chip-edit.png"
            visible: editable
            /// Clic sur l'icone EDIT: A gérer dans le controleur de la Zone parente avec chipXXX.editArea.onClicked:{...}
            MouseArea {
                id: editArea
                anchors.fill: parent
            }
        }


        /** ************************************************************************************
         * Icone "save" pour mémoriser la valeur du tag.
         * Cette image se superpose à la précédente (Edit).
         * Il faut donc faire attention à ce qu'elles ne soient pas à 'visible' en même temps.
         * *************************************************************************************/
        Image {
            id: chipSave
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            height: 26
            width: 26
            source: "qrc:/Images/chip-save.png"
            visible: canSave
            /// Clic sur l'icone SAVE: A gérer dans le controlleur de la Zone parente avec chipXXX.saveArea.onClicked:{...}
            MouseArea {
                id: saveArea
                anchors.fill: parent
            }
        }


        /** ************************************************************************************
         * Libellé "Target", cad le nom du tag à attribuer.
         * Couleur automatique du thème Material: foreground
         * On décale un peu le texte s'il y a un bouton.
         * *************************************************************************************/
        Label {
            id: chipTarget
            anchors.left: parent.left // Pas de bouton quand on affiche la target
            anchors.leftMargin: (editable || canSave) ? 36 : 12
            anchors.verticalCenter: parent.verticalCenter
            visible: !(hideTargetWhenFilled && content.trim() !== "")
            width: (hideTargetWhenFilled && content.trim() !== "") ? 0 : implicitWidth
            text: targetName
            font.pixelSize: 12
            // Positionnement du texte
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.NoWrap
            clip: true // Le texte peut être tronqué
        }


        /** ************************************************************************************
         * Texte du chip, cad la valeur du tag à attribuer.
         * Couleur automatique du thème Material: noir
         * *************************************************************************************/
        TextInput {
            id: chipText
            anchors.left: targetName ? chipTarget.right : chipEdit.right
            anchors.right: chipDel.left
            anchors.leftMargin: 4
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            text: content
            readOnly: true
            font.pixelSize: 14
            // Positionnement du texte
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            // Retour à la ligne si le texte est plus long que le Rectangle
            wrapMode: Text.Wrap
            clip: false // Le texte n'est pas tronqué
            //  La taille max du texte pouvant être saisi (24 pour le Chips, 180 pour les FatChips).
            maximumLength: 24
        }


        /** ************************************************************************************
         * Icone "corbeille" pour enlever le tag.
         * *************************************************************************************/
        Image {
            id: chipDel
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            height: 26
            width: 26
            source: "qrc:/Images/chip-del.png"
            visible: deletable
            /// Clic sur l'icone DELETE: A gérer dans le controlleur de la Zone parente avec chipXXX.deleteArea.onClicked:{...}
            MouseArea {
                id: deleteArea
                anchors.fill: parent
            }
        }


        /** ************************************************************************************
         * Icone "revert" pour remettre la valeur précédente du tag.
         * *************************************************************************************/
        Image {
            id: chipRevert
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            height: 26
            width: 26
            source: "qrc:/Images/chip-revert.png"
            visible: canSave
            /// Clic sur l'icone REVERT: A gérer dans le controlleur de la Zone parente avec chipXXX.revertArea.onClicked:{...}
            MouseArea {
                id: revertArea
                anchors.fill: parent
            }
        }
    }
}
