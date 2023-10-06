import QtQuick 2.15
import QtQuick.Dialogs 1.3

MessageDialog {
    title: "Credits"
    icon: StandardIcon.Information
    text: qsTr("Aides à la réalisation de ce programme")
    readonly property string t1 : qsTr("- Le freeware GeoSetter pour l'idée initiale.<br/>")
    readonly property string t2 : qsTr("- le freeware ExifTools pour la gestion des données EXIF.<br/>")
    readonly property string t3 : qsTr("- le framework Qt v5.15 pour le codage en C++ et QML.<br/>")
    informativeText: t1 + t2 + t3
    // onAccepted: quit()
    Component.onCompleted: visible=false
}
