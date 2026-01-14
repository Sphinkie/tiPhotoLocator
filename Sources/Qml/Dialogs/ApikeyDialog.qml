import QtQuick
import QtQuick.Dialogs


/** **********************************************************************************************************
 * @brief Fenêtre d'aide pour l'obtention d'une API Key de cartes.
 * ***********************************************************************************************************/
MessageDialog {
    /// Titre de la fenêtre de popup.
    title: qsTr("Obtenir une API Key")
    /// Texte à afficher dans la fenêtre de popup.
    text: qsTr("Une clef API peut être obtenue auprès d'un fournisseur de cartes (thunderforest, mapbox, esri...), de la façon suivante:<br/>")
    /// Informative text can be used to expand upon the text to give more information to the user.
    informativeText: t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9
    /// This property holds the (unformated) text to be displayed in the details area.
    detailedText: t_details

    // onLinkActivated: Qt.openUrlExternally(link)
    readonly property string t1: qsTr("- Se connecter sur le site.<br/>")
    readonly property string t2: "  <a href='https://www.thunderforest.com/pricing/'>https://www.thunderforest.com</a>.<br/>"
    readonly property string t3: qsTr("- Choisir le plan <i>Hobby Project</i>.<br/>")
    readonly property string t4: qsTr("- Créer un compte.<br/>")
    readonly property string t5: qsTr("- Se connecter avec le compte.<br/>")
    readonly property string t6: qsTr("- Aller dans la page <i>Dashboard</i>.<br/>")
    readonly property string t7: qsTr("- Copier l'API Key.<br/>")
    readonly property string t8: qsTr("- Coller dans le menu 'Configuration'.<br/>")
    readonly property string t9: qsTr("- Relancer <b>TiPhotoLocator</b>.<br/>")
    readonly property string t_details: qsTr("Cette clef permet de ne plus avoir le watermark 'API Key Required' sur les cartes.")

    /// Non visible au démarrage.
    Component.onCompleted: visible = false
}
