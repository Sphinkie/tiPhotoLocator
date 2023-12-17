import QtQuick
import QtQuick.Layouts

ZoneTitle{
    // iconZone: "qrc:/Images/icon-tag.png"
    // txtZone: "IPTC"
    readonly property string title: "<b>IPTC tags</b> "
    readonly property string brief: "<e>(International Press Telecom Council)</e>"
    readonly property string usage: qsTr("Les tags IPTC contiennent principalement des informations éditoriales (description de l'image, etc) renseignés manuellement. ")
    readonly property string note : ""
    readonly property string br   : "<br>"
    titleText : title + brief + br + usage + note
}
