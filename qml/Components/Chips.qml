import QtQuick 2.0

/**
 * Ce composant reproduit un MaterialDesign::Chip en se basant sur un Qt Rectangle.
 * A noter que le Rectangle contient un texte, mais ne s'adapte pas automatiquement à la longueur du texte.
 * C'est plutot le texte qui s'adapte au rectangle parent.
 * @see https://doc.qt.io/qt-5/qml-qtquick-controls2-label.html
 */
Rectangle {

    radius: 16
    color: TiStyle.secondaryForegroundColor
    implicitHeight: 32
    implicitWidth: 240
    // Propriétés modifiables depuis les parents:
    property bool editable: true
    property bool deletable: true
    property string content
    visible: content? true : false

    Image{
        id: chipEdit
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.topMargin: 4
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
        anchors.topMargin: 4
        text: content
        font.pixelSize: 14
        color: TiStyle.secondaryBackgroundColor
        // Positionnement du texte
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap  // Retour à la ligne si le texte est plus long que le Rectangle
        clip: false // Le texte n'est pas tronqué
    }
    Image{
        id: chipDel
        anchors.right: parent.right
        anchors.rightMargin: 2
        anchors.topMargin: 4
        height: 26
        width: 26
        source: "qrc:/Images/suppr-button.png"
        visible: deletable
    }
}
