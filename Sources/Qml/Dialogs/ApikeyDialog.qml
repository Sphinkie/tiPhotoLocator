import QtQuick
import QtQuick.Dialogs


/** **********************************************************************************************************
 * @brief Fenêtre d'aide pour l'obtention d'une API Key de cartes.
 * ***********************************************************************************************************/
MessageDialog {
    /// Titre de la fenêtre de popup.
    title: qsTr("Get an API Key")
    /// Texte à afficher dans la fenêtre de popup.
    text: qsTr("An API key can be obtained from a map provider (thunderforest, mapbox, esri...) as follows:<br/>")
    /// Informative text can be used to expand upon the text to give more information to the user.
    informativeText: t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9
    /// This property holds the (unformated) text to be displayed in the details area.
    detailedText: t_details

    // onLinkActivated: Qt.openUrlExternally(link)
    readonly property string t1: qsTr("- Go to the website.<br/>")
    readonly property string t2: "  <a href='https://www.thunderforest.com/pricing/'>https://www.thunderforest.com</a>.<br/>"
    readonly property string t3: qsTr("- Choose the <i>Hobby Project</i> plan.<br/>")
    readonly property string t4: qsTr("- Create an account.<br/>")
    readonly property string t5: qsTr("- Sign in with your account.<br/>")
    readonly property string t6: qsTr("- Go to the <i>Dashboard</i> page.<br/>")
    readonly property string t7: qsTr("- Copy the API Key.<br/>")
    readonly property string t8: qsTr("- Paste it in the 'Configuration' menu.<br/>")
    readonly property string t9: qsTr("- Restart <b>TiPhotoLocator</b>.<br/>")
    readonly property string t_details: qsTr("This key removes the 'API Key Required' watermark from the maps.")

    /// Non visible au démarrage.
    Component.onCompleted: visible = false
}
