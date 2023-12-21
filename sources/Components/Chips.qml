import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

/*
 * \brief Ce composant reproduit un MaterialDesign::Chip en se basant sur un Qt Rectangle.
 * A noter que le Rectangle contient un texte, mais ne s'adapte pas automatiquement à la longueur du texte.
 * C'est plutot le texte qui s'adapte au rectangle parent.
 * \sa {https://doc.qt.io/qt-5/qml-qtquick-controls2-label.html}
 */
Rectangle {
    // Les différents Chips doivent être dans un ColumLayout. On peut ainsi les aligner tous de la même façon.
    Layout.topMargin: 10
    Layout.leftMargin: 20

    radius: 16
    implicitHeight: 32
    implicitWidth: 240
    layer.enabled: true
    visible: content? true : false
    color: TiStyle.chipBackgroundColor
    // Propriétés modifiables depuis les parents:
    property bool canSave: false
    property bool editable: false
    property bool deletable: false
    property string content
    property string targetName
    property alias editArea: editArea
    property alias saveArea: saveArea
    property alias revertArea: revertArea
    property alias deleteArea: deleteArea
    // Pour le controle inviduel des items
    property alias chipText: chipText

    Image{
        id: chipEdit
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        height: 26
        width: 26
        source: "../Images/chip-edit.png"
        visible: editable
        // Clic sur l'icone EDIT: A gérer dans le controleur de la Zone parente avec chipXXX.editArea.onClicked:{...}
        MouseArea {
            id: editArea
            anchors.fill: parent
        }
    }
    Image{
        // Cette image se superpose à la précédente (Edit).
        // Il faut dons faire attention à ce qu'elles ne soient pas à 'visible' en même temps.
        id: chipSave
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        height: 26
        width: 26
        source: "../Images/chip-save.png"
        visible: canSave
        // Clic sur l'icone SAVE: A gérer dans le controlleur de la Zone parente avec chipXXX.saveArea.onClicked:{...}
        MouseArea {
            id: saveArea
            anchors.fill: parent
        }
    }
    Text {
        id: chipTarget
        anchors.left: parent.left  // Pas de bouton quand on affiche la target
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        text: targetName
        font.pixelSize: 12
        color: TiStyle.surfaceContainerColor
        // Positionnement du texte
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.NoWrap
        clip: true // Le texte peut être tronqué
    }
    TextInput {
        id: chipText
        anchors.left: targetName? chipTarget.right : chipEdit.right
        anchors.right: chipDel.left
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        text: content
        readOnly: true
        font.pixelSize: 14
        color: canSave? "white" : TiStyle.chipTextColor
        // Positionnement du texte
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        // Retour à la ligne si le texte est plus long que le Rectangle
        wrapMode: Text.WordWrap
        clip: false // Le texte n'est pas tronqué
    }
    Image{
        id: chipDel
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        height: 26
        width: 26
        source: "qrc:/Images/chip-del.png"
        visible: deletable
        // Clic sur l'icone DELETE: A gérer dans le controlleur de la Zone parente avec chipXXX.deleteArea.onClicked:{...}
        MouseArea {
            id: deleteArea
            anchors.fill: parent
        }
    }
    Image{
        id: chipRevert
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        height: 26
        width: 26
        source: "qrc:/Images/chip-revert.png"
        visible: canSave
        // Clic sur l'icone REVERT: A gérer dans le controlleur de la Zone parente avec chipXXX.revertArea.onClicked:{...}
        MouseArea {
            id: revertArea
            anchors.fill: parent
        }
    }
    layer.effect: DropShadow {
        transparentBorder: true
        color: "#88000000"    // alpha
        radius: 4      // douceur de l'ombre
        samples: 9     // 2*radius+1
        cached: true   // Performances. Mettre false pour les objets animés uniquement.
        verticalOffset: 5
    }

}

