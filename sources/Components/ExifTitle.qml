import QtQuick
import QtQuick.Layouts

ZoneTitle{
    // iconZone: "qrc:/Images/icon-tag.png"
    // txtZone: "EXIF"
    readonly property string title: "<b>EXIF tags</b>"
    readonly property string brief: "  <e>(EXchangeable Image Fileformat)</e>"
    readonly property string usage: qsTr("Ces tags sont définis au moment de la prise de vue.")
    readonly property string note: qsTr("Ils contiennent principalement des informations techniques (modèle d'appareil, objectif...)")
    readonly property string br:  "<br>"
    titleText : title + brief + br + usage + note
}
