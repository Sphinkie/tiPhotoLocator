import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"


/** **********************************************************************************************************
 * @brief QML: Vue de la Toolbar principale: boutons du haut: Reload - Rescan - Dossier
 * *********************************************************************************************************** */
Rectangle {
    property alias bt_rescan: bt_rescan
    property alias folderPath: folderPath
    implicitHeight: 60
    implicitWidth: 800
    color: Style.surfaceContainerColor

    RowLayout {
        spacing: 20

        /// Bouton de rescan
        Button {
            id: bt_rescan
            icon.source: "qrc:/Images/bt-reload.png"
            text: qsTr("Rescan")
            ToolTip.text: qsTr(
                              "Rescanne les tags EXIF des photos du répertoire")
            ToolTip.visible: hovered
            ToolTip.delay: 500
            // Positionnement à l'interieur du Layout
            Layout.leftMargin: 20
        }

        /// Indicateur de travail
        BusyIndicator {
            implicitHeight: bt_rescan.height
            running: _photoModel.loading
        }

        /// Nom du dossier en cours
        Label {
            text: qsTr("Répertoire:")
            font.pixelSize: 16
            // Positionnement à l'interieur du rectangle
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            id: folderPath
            font.pixelSize: 16
            font.family: "Courier"
            // Positionnement à l'interieur du rectangle
            verticalAlignment: Text.AlignVCenter
        }
    }
}
