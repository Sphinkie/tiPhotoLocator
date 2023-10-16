import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12   // pour Checkbox
import Qt.labs.settings 1.1


RowLayout {

    Layout.alignment: Qt.AlignRight  // on cale les boutons à droite
    Layout.margins: 16
    spacing: 20

    TiButton {
        id: bt_dump
        text: qsTr("Dump model")
        ToolTip.text: qsTr("DEBUG: Affiche une ligne du modèle dans la console")
        ToolTip.visible: hovered
        ToolTip.delay: 500
        onClicked: _photoListModel.dumpData()
    }
    CheckBox {
        id: cb_backups
        text: qsTr("Générer backups")
        ToolTip {
            text: qsTr("Cocher pour faire une sauvegarde des photos originales (IMAGENAME.jpg_original)")
            delay: 500
            visible: parent.hovered
        }
        onCheckedChanged:  {
            // On stocke l'état de la checkbox dans la propriété generateBackup de exifWrapper
            _exifWrapper.generateBackup = cb_backups.checked
        }
    }
    TiButton {
        id: bt_save
        text: qsTr("Enregistrer")
        // Puis on lance l'écriture des données EXIF (envoi signal)
        onClicked: window.saveExifMetadata()
        ToolTip.text: qsTr("Enregistre les tags EXIF des photos modifiées")
        ToolTip.visible: hovered
        ToolTip.delay: 500
    }
    TiButton {
        id: bt_quit
        text: qsTr("Quitter")
        onClicked: Qt.quit()
        ToolTip.text: qsTr("Quitte l'application")
        ToolTip.visible: hovered
        ToolTip.delay: 500
    }

    // ----------------------------------------------------------------
    // On mémorise la ckeckbox dans les settings
    // ----------------------------------------------------------------
    Settings {
        id: reglages
        category: "general"
        property alias checkbox_backups: cb_backups.checked
        }
}
