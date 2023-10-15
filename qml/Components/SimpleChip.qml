import QtQuick 2.0
import QtQuick.Controls 2.12

/**
 * Ce composant reproduit un MaterialDesign::Chip en se basant sur un Qt label.
 * A noter que le Label possède un texte et un rectangle en background.
 * Avantage: la longueur de rectangle suit naturellement la longueur du texte.
 * @see https://doc.qt.io/qt-5/qml-qtquick-controls2-label.html
 */
Label {
    leftPadding: 20   // Positionnement du texte à l'intérieur du rectangle
    rightPadding: 20
    property bool editable: true
    property bool deletable: true
    property string content
    visible: content? true : false
    text: content
    font.pixelSize: 14
    color: TiStyle.secondaryBackgroundColor


    background:

  /*      Image{
            id: pastilleEdit
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.topMargin: 4
            height: 26
            width: 26
            source: "qrc:/Images/edit1-button.png"
            visible: editable
        }
*/
        Rectangle {
            color: TiStyle.secondaryForegroundColor;
            implicitHeight: 24
            radius: 12;
            id: pastilleText
            //anchors.left: pastilleEdit.right
            //anchors.leftMargin: 4
            //anchors.topMargin: 4
        }
/*
        Image{
            id: pastilleDel
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.topMargin: 4
            height: 26
            width: 26
            source: "qrc:/Images/suppr-button.png"
            visible: deletable
        }
        */

}
