import QtQuick 2.15
import QtQuick.Dialogs 1.3

MessageDialog {
    title: "Credits"
    icon: StandardIcon.Information
    text: qsTr("Je remercie les applications tierces qui ont aidé à la réalisation de ce programme:")
    readonly property string t1 : qsTr("- Le freeware <a href='https://geosetter.de/en/main-en/'>GeoSetter</a> pour l'idée initiale.<br/>")
    readonly property string t2 : qsTr("- le freeware <a href='https://exiftool.org/'>ExifTool</a> pour la gestion des données EXIF.<br/>")
    readonly property string t3 : qsTr("- le framework <a href='https://www.qt.io/'>Qt 5.15</a> pour le codage en C++ et QML.<br/>")
    readonly property string t4 : qsTr("- l'organisation <a href='https://www.openstreetmap.org'>OpenStreetMap</a> pour les informations cartographiques.<br/>")
    readonly property string t5 : qsTr("- la société <a href='https://www.thunderforest.com/about/'>Thunderforest</a> pour la mise à disposition des cartes.<br/>")
    informativeText: t1 + t2 + t3 + t4 + t5
    // onAccepted: quit()
    Component.onCompleted: visible=false
}
