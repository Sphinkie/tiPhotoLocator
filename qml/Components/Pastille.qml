import QtQuick 2.0

Rectangle {

    radius: 16
    color: TiStyle.secondaryForegroundColor
    implicitHeight: 32
    implicitWidth: 160
    property bool editable: true
    property bool deletable: true
    property string content
    visible: content? true : false

    Image{
        id: pastilleEdit
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.topMargin: 4
        height: 26
        width: 26
        source: "qrc:/Images/edit1-button.png"
        visible: editable
    }
    Text {
        id: pastilleText
        anchors.left: pastilleEdit.right
        anchors.leftMargin: 4
        anchors.topMargin: 4
        text: content
        font.pixelSize: 14
        color: TiStyle.secondaryBackgroundColor
    }
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
}
