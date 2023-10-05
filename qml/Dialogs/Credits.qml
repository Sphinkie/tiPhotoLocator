import QtQuick 2.15
import QtQuick.Dialogs 1.3

MessageDialog {
    title: "Credits"
    icon: StandardIcon.Information
    text: qsTr("remercier les ressources opensources utilisées")
    informativeText: qsTr("texte enrichi possible")
    onAccepted: quit()
    Component.onCompleted: visible=true
}
