import QtQuick
import QtQuick.Dialogs

/** **********************************************************************************************************
 * @brief Popup "A propos de l'application" (menu principal).
 * ***********************************************************************************************************/
MessageDialog {
    readonly property string version: "2.0"
    readonly property string t0: qsTr("<b>TiPhotoLocator</b> allows you to locate your photos on the world map, and edit the EXIF and IPTC tags embedded inside the photos.<br/>")
    readonly property string t1: qsTr("<br/><br/>This application was created by David de Lorenzo.")
    readonly property string t_details: qsTr("TiPhotoLocator is free and without ads.")

    // -------------------------------------------------
    // Propriétés de MessageDialog
    // -------------------------------------------------

    /// Titre de la fenêtre de popup.
    title: "About TiPhotoLocator"
    /// This property holds the text to be displayed on the message dialog.
    text: "<center><b>TiPhotoLocator</b> v" + version + "</center>"
    /// Informative text can be used to expand upon the text to give more information to the user.
    informativeText: t0 + t1
    /// This property holds the (unformated) text to be displayed in the details area.
    detailedText: t_details

    /// Non visible au démarrage.
    Component.onCompleted: visible = false
}
