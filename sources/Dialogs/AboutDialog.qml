import QtQuick
import QtQuick.Dialogs

MessageDialog {
    title: "About TiPhotoLocator"
    text: "<center><b>TiPhotoLocator</b></center>"

    readonly property string t0 : qsTr("<b>TiPhotoLocator</b> permet de placer vos photos sur la carte géographique du monde, ainsi que d'éditer les tags EXIF et IPTC internes aux photos.<br/>")
    readonly property string t1 : qsTr("<br/><br/>Programme réalisé par David de Lorenzo.")
    readonly property string t2 : qsTr("TiPhotoLocator est gratuit et sans publicité.")

    informativeText: t0 + t1
    detailedText: t2            // Non formaté

    Component.onCompleted: visible=false
}
