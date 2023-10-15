import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12   // pour Checkbox


RowLayout {

    Layout.alignment: Qt.AlignRight  // on cale les boutons à droite
    Layout.margins: 16
    spacing: 20

    TiButton {
        id: bt_dump
        text: qsTr("Dump model")
        ToolTip.text: qsTr("DEBUG: affiche une ligne du modèle dans la console")
        ToolTip.visible: hovered
        ToolTip.delay: 1000
        onClicked: _photoListModel.dumpData()
    }
    CheckBox {
        id: cb_backups
        text: qsTr("Générer backups")
        ToolTip {
            text: qsTr("Une sauvegarde de l'original peut être faite (sous le nom: IMAGE.jpg_original)")
            timeout: 10000
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
    }
    TiButton {
        id: bt_quit
        text: qsTr("Quitter")
        onClicked: Qt.quit()
    }
}
