import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

/*!
 * \brief Ce composant reproduit un MaterialDesign::Chip en se basant sur un Qt Rectangle.
 * A noter que le Rectangle contient un texte, mais ne s'adapte pas automatiquement à la longueur du texte.
 * C'est plutot le texte qui s'adapte au rectangle parent.
 * \sa https://doc.qt.io/qt-5/qml-qtquick-controls2-label.html
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
    property bool editable: true
    property bool deletable: true
    property string content
    property alias deleteArea:deleteArea

    Image{
        id: chipEdit
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        height: 26
        width: 26
        source: "qrc:/Images/edit1-button.png"
        visible: editable
    }
    Text {
        id: chipText
        anchors.fill: parent
        anchors.left: chipEdit.right
        anchors.leftMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        text: content
        font.pixelSize: 14
        color: TiStyle.chipTextColor
        // Positionnement du texte
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap  // Retour à la ligne si le texte est plus long que le Rectangle
        clip: false // Le texte n'est pas tronqué
    }
    Image{
        id: chipDel
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        height: 26
        width: 26
        source: "qrc:/Images/suppr-button.png"
        visible: deletable
        // Gestion du clic sur un item
        MouseArea {
            id: deleteArea
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

