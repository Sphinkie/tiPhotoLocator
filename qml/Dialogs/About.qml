import QtQuick 2.15
import QtQuick.Dialogs 1.3

MessageDialog {
    title: "About"
    icon: StandardIcon.Information
    text: "TiPhotoLocator"
    readonly property string t1 : qsTr("TiPhotoLocator est <b>gratuit et sans publicité</b>.<br/><br/>")
    readonly property string t2 : qsTr("Programme réalisé par David de Lorenzo.<br/>")
    informativeText: t1 + t2
    detailedText: qsTr("TiPhotoLocator permet de placer vos photos sur la carte géographique du monde, et d'éditer les tags Exif internes aux photos.")
    // onAccepted: quit()
    Component.onCompleted: visible=false
}
