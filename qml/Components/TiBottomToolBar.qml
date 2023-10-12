import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12   // pour Checkbox


RowLayout {
    //Layout.fillHeight: true
    Layout.alignment: Qt.AlignRight  // on cale les boutons à droite
    Layout.margins: 16
    spacing: 20

    TiButton {
        id: bt_dump
        text: qsTr("Dump model")
        onClicked: _photoListModel.dumpData()  // Pour les tests
    }
    CheckBox {
        id: checkBox
        text: qsTr("Générer backups")
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
