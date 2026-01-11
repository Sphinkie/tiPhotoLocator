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
              "Je remercie les applications tierces qui ont aidé à la réalisation de ce programme:")
    /// Texte secondaire.
    informativeText: t1 + t2 + t3 + t4 + t5
    /// PAr défaut: ce popup est masqué.
    Component.onCompleted: visible = false

    readonly property string t1: qsTr("- le freeware <a href='https://geosetter.de/en/main-en/'>GeoSetter</a> pour l'idée initiale.<br/>")
    readonly property string t2: qsTr("- le freeware <a href='https://exiftool.org/'>ExifTool</a> pour la gestion des métadonnées EXIF.<br/>")
    readonly property string t3: qsTr("- la <a href='https://www.qt.io/'>Qt Company</a> pour le framework Qt6 en C++ et QML.<br/>")
    readonly property string t4: qsTr("- l'organisation <a href='https://www.openstreetmap.org'>OpenStreetMap</a> pour les informations cartographiques.<br/>")
    readonly property string t5: qsTr("- la société <a href='https://www.thunderforest.com/about/'>Thunderforest</a> pour la mise à disposition des cartes.<br/>")
}
