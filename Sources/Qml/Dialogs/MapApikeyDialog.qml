import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/** **********************************************************************************************************
 * @brief Fenêtre d'aide pour l'obtention d'une API Key de cartes.
 * Utilise un Dialog QML (et non MessageDialog natif) pour que les hyperliens soient cliquables.
 * ***********************************************************************************************************/
Dialog {
    id: apikeyDialog
    title: qsTr("How to get an API Key for maps")
    modal: true
    standardButtons: Dialog.Ok
    anchors.centerIn: Overlay.overlay
    Component.onCompleted: visible = false

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        Text {
            text: qsTr("An API key can be obtained from a map provider (thunderforest, mapbox, esri...) as follows:")
            wrapMode: Text.WordWrap
            font.pointSize: 11
            color: Style.secondaryTextColor
            Layout.fillWidth: true
        }

        Text {
            textFormat: Text.RichText
            text: t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9
            wrapMode: Text.WordWrap
            font.pointSize: 11
            color: Style.secondaryTextColor
            Layout.fillWidth: true
            onLinkActivated: link => Qt.openUrlExternally(link)
        }

        Text {
            text: qsTr("This key removes the 'API Key Required' watermark from the maps.")
            wrapMode: Text.WordWrap
            font.pointSize: 11
            font.italic: true
            color: Style.secondaryTextColor
            Layout.fillWidth: true
        }
    }

    readonly property string t1: qsTr("- Go to the website: ")
    readonly property string t2: "<a href='https://www.thunderforest.com/pricing/'>https://www.thunderforest.com</a>.<br/>"
    readonly property string t3: qsTr("- Choose the <i>Hobby Project</i> plan.<br/>")
    readonly property string t4: qsTr("- Create an account.<br/>")
    readonly property string t5: qsTr("- Sign in with your account.<br/>")
    readonly property string t6: qsTr("- Go to the <i>Dashboard</i> page.<br/>")
    readonly property string t7: qsTr("- Copy the API Key.<br/>")
    readonly property string t8: qsTr("- Paste it in the 'Configuration' menu.<br/>")
    readonly property string t9: qsTr("- Restart <b>TiPhotoLocator</b>.<br/>")
}
