import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/** **********************************************************************************************************
 * @brief Fenêtre d'aide pour l'obtention d'une API Key d'IA VLM (Vision-Language Model).
 * Utilise un Dialog QML (et non MessageDialog natif) pour que les hyperliens soient cliquables.
 * @note Plusieurs IA ont été testées (via Hugging Face). La seule qui fonctionne gratuitement est Groq).
 * ***********************************************************************************************************/
Dialog {
    id: vlmTokenDialog
    title: qsTr("How to get a Token for AI")
    modal: true
    standardButtons: Dialog.Ok
    anchors.centerIn: Overlay.overlay
    Component.onCompleted: visible = false

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        Text {
            text: qsTr("An API key can be obtained from Groq AI as follows:")
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
            text: qsTr("Note: The AI will try to find the location of the photo, not keywords.<br/>AI suggests a <b>yellow marker</b>, and a <b>location name</b>.")
            wrapMode: Text.WordWrap
            font.pointSize: 11
            font.italic: true
            color: Style.secondaryTextColor
            Layout.fillWidth: true
        }
    }

    readonly property string t1: qsTr("- Go to the website: ")
    readonly property string t2: "<a href='console.groq.com'>https://console.groq.com</a>.<br/>"
    // readonly property string t2: "<a href='https://huggingface.co'>https://huggingface.co</a>.<br/>"
    readonly property string t3: qsTr("- Create an account.<br/>")
    readonly property string t4: qsTr("- Validate the email.<br/>")
    // readonly property string t5: qsTr("- Go to Settings > Access tokens > create a new token.<br/>")
    readonly property string t5: qsTr("- Go to top-right menu >  API Keys → Create API Key.<br/>")
    readonly property string t6: qsTr("- Give it a name, ie <i>TiPhotoLocator</i>.<br/>")
    // readonly property string t7: qsTr("- Give it a type: <b>Read</b><br/>")
    readonly property string t7: qsTr("- Submit.<br/>")
    readonly property string t8: qsTr("- Paste it in the 'Configuration' menu.<br/>")
    readonly property string t9: qsTr("- Restart <b>TiPhotoLocator</b>.<br/>")
}
