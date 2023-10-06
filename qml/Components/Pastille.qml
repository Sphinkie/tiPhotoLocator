import QtQuick 2.0

Rectangle {

    radius: 10
    color: TiStyle.secondaryForegroundColor
    implicitHeight: 20
    implicitWidth: 120
    Image{
        id: pastilleEdit
        height: 18
        width: 18
        source: "qrc:/Images/mappin-red.png"
    }
    Text {
        id: pastilleText
        anchors.left: pastilleEdit.right
        anchors.leftMargin: 4
        text: qsTr("Contenu")
        color: TiStyle.secondaryBackgroundColor
    }
    Image{
        id: pastilleDel
        anchors.right: parent.right
        height: 18
        width: 18
        source: "qrc:/Images/mappin-yellow.png"
    }
}
