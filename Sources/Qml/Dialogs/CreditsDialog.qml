import QtQuick
import QtQuick.Dialogs


/** **********************************************************************************************************
 * @brief Fenêtre de dialogue typique pour afficher les remerciements.
 * ***********************************************************************************************************/
MessageDialog {

    /// Titre de la fenêtre.
    title: "Credits"
    /// Texte principal.
    text: qsTr(
              "I would like to thank the third-party applications that helped build this program:")
    /// Texte secondaire.
    informativeText: t1 + t2 + t3 + t4 + t5
    /// PAr défaut: ce popup est masqué.
    Component.onCompleted: visible = false

    readonly property string t1: qsTr("- the freeware <a href='https://geosetter.de/en/main-en/'>GeoSetter</a> for the initial idea.<br/>")
    readonly property string t2: qsTr("- the freeware <a href='https://exiftool.org/'>ExifTool</a> for EXIF metadata management.<br/>")
    readonly property string t3: qsTr("- the <a href='https://www.qt.io/'>Qt Company</a> for the Qt6 C++ and QML framework.<br/>")
    readonly property string t4: qsTr("- the <a href='https://www.openstreetmap.org'>OpenStreetMap</a> organisation for map data.<br/>")
    readonly property string t5: qsTr("- the <a href='https://www.thunderforest.com/about/'>Thunderforest</a> company for providing the map tiles.<br/>")
}
