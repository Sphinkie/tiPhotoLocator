import QtQuick
import QtQuick.Dialogs


/** **********************************************************************************************************
 * @brief Popup "A propos de l'application" (menu principal).
 * ***********************************************************************************************************/
MessageDialog {
    readonly property string version: "1.3"
    readonly property string t0: qsTr("<b>TiPhotoLocator</b> permet de placer vos photos sur la carte géographique du monde, ainsi que d'éditer les tags EXIF et IPTC internes aux photos.<br/>")
    readonly property string t1: qsTr("<br/><br/>Programme réalisé par David de Lorenzo.")
    readonly property string t2: qsTr("TiPhotoLocator est gratuit et sans publicité.")

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
    detailedText: t2

    /// Non visible au démarrage.
    Component.onCompleted: visible = false
}
