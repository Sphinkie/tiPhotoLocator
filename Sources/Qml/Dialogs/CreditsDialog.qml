import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/** **********************************************************************************************************
 * @brief Fenêtre de dialogue pour afficher les remerciements.
 * Utilise un Dialog QML (et non MessageDialog natif) pour que les hyperliens soient cliquables.
 * ***********************************************************************************************************/
Dialog {
    id: creditsDialog
    title: qsTr("Credits")
    modal: true
    standardButtons: Dialog.Ok
    anchors.centerIn: Overlay.overlay
    Component.onCompleted: visible = false

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        Text {
            text: qsTr("I would like to thank the third-party applications that helped build this program:")
            wrapMode: Text.WordWrap
            font.pointSize: 11
            color: Style.secondaryTextColor
            Layout.fillWidth: true
        }

        Text {
            textFormat: Text.RichText
            text: t1 + t2 + t3 + t4 + t5 + t6 + t7
            wrapMode: Text.WordWrap
            font.pointSize: 11
            color: Style.secondaryTextColor
            Layout.fillWidth: true
            onLinkActivated: link => Qt.openUrlExternally(link)
        }
    }

    readonly property string t1: qsTr("- the freeware <a href='https://geosetter.de/en/main-en/'>GeoSetter</a> for the initial idea.<br/>")
    readonly property string t2: qsTr("- the freeware <a href='https://exiftool.org/'>ExifTool</a> for EXIF metadata management.<br/>")
    readonly property string t3: qsTr("- the <a href='https://www.qt.io/'>Qt Company</a> for the Qt6 C++ and QML framework.<br/>")
    readonly property string t4: qsTr("- the <a href='https://www.openstreetmap.org'>OpenStreetMap</a> organisation for map data.<br/>")
    readonly property string t5: qsTr("- the <a href='https://www.thunderforest.com/about/'>Thunderforest</a> company for providing the map tiles.<br/>")
    readonly property string t6: qsTr("- the <a href='https://groq.com'>Groq</a> IA Vision-Language Model (with llama-4) for photo localization.<br/>")
    readonly property string t7: qsTr("- <a href='https://bellaminettes.com/'>Bruno Bellamy</a> for the pretty instructor of the tutorial.<br/>  (Temporarily without his permission, as long as the software is only used by 2 or 3 people).<br/>")
}
