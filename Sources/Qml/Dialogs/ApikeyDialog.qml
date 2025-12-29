import QtQuick
import QtQuick.Dialogs

MessageDialog {
    title: qsTr("Obtenir une API Key")
    text: qsTr("Une clef API peut être obtenue auprès d'un fournisseur de cartes (thunderforest, mapbox, esri...), de la façon suivante:<br/>")

    readonly property string t1 : qsTr("- Se connecter sur le site <a href='https://www.thunderforest.com/pricing/'>https://www.thunderforest.com</a>.<br/>")
    readonly property string t2 : qsTr("- Choisir le plan 'Hobby Project' et créer un compte.<br/>")
    readonly property string t3 : qsTr("- Se connecter avec le compte, et aller dans la page 'Dashboard'.<br/>")
    readonly property string t4 : qsTr("- Copier l'API Key et la coller dans le menu 'Configuration' de TiPhotoLocator.<br/>")
    readonly property string t5 : qsTr("- Relancer l'application.<br/>")
    readonly property string t6 : qsTr("<br/>Cette clef permet de ne plus avoir le watermark 'API Key Required' sur les cartes.<br/>")

    informativeText: t1 + t2 + t3 + t4 + t5 + t6

    Component.onCompleted: visible=false
}
