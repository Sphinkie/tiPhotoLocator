import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12   // pour Checkbox
import Qt.labs.settings 1.1
import "../Components"


Rectangle {
    color: TiStyle.surfaceContainerColor
    height: bottomToolBarLayout.height + 20

    property alias bt_dump: bt_dump
    property alias cb_backups: cb_backups
    property alias bt_save: bt_save
    property alias bt_quit: bt_quit
    property alias reglages2: reglages2

    RowLayout {
        id: bottomToolBarLayout
        Layout.alignment: Qt.AlignRight  // on cale les boutons à droite
        spacing: 20

        TiButton {
            id: bt_dump
            text: qsTr("Dump model")
            ToolTip.text: qsTr("DEBUG: Affiche une ligne du modèle dans la console")
            ToolTip.visible: hovered
            ToolTip.delay: 500
            Layout.leftMargin: 20
            Layout.topMargin: 10
        }
        CheckBox {
            id: cb_backups
            text: qsTr("Générer backups")
            Layout.topMargin: 10
            ToolTip {
                text: qsTr("Cocher pour faire une sauvegarde des photos originales (IMAGENAME.jpg_original)")
                delay: 500
                visible: parent.hovered
            }
        }
        TiButton {
            id: bt_save
            text: qsTr("Enregistrer")
            Layout.topMargin: 10
            ToolTip.text: qsTr("Enregistre les tags EXIF des photos modifiées")
            ToolTip.visible: hovered
            ToolTip.delay: 500
        }
        TiButton {
            id: bt_quit
            text: qsTr("Quitter")       
            ToolTip.text: qsTr("Quitte l'application")
            ToolTip.visible: hovered
            ToolTip.delay: 500
            Layout.rightMargin: 20
            Layout.topMargin: 10
        }
    }
    // ----------------------------------------------------------------
    // On mémorise la ckeckbox dans les settings
    // ----------------------------------------------------------------
    Settings {
        id: reglages2
        //category: "configuration"
        property alias backupsEnabled: cb_backups.checked
        property alias debugModeEnabled
    }
}
