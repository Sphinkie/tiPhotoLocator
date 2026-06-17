import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"


/** **********************************************************************************************************
 * @brief QML: Vue de la Toolbar principale: boutons du haut: Reload - Rescan - Dossier
 * *********************************************************************************************************** */
Rectangle {
    property alias bt_rescan: bt_rescan
    property alias bt_explorer: bt_explorer
    property alias folderPath: folderPath
    implicitHeight: 60
    implicitWidth: 800
    color: Style.surfaceContainerColor

    RowLayout {
        spacing: 20
        /// Logo de l'application
        ApplicationLogo {
            id: topLogo
        }
        /// Bouton de rescan
        Button {
            id: bt_rescan
            icon.source: "qrc:/Images/bt-reload.png"
            text: qsTr("Rescan")
            Layout.leftMargin: 20
            ToolTip {
                visible: parent.hovered
                text: qsTr("Rescan all EXIF tags of the folder photos")
                delay: 500
                y: -height - 4
            }
        }
        /// Bouton 'Open in Explorer'
        Button {
            id: bt_explorer
            icon.source: "qrc:/Images/bt-folder.png"
            text: qsTr("Open in Explorer")
            Layout.leftMargin: 20
            ToolTip {
                visible: parent.hovered
                text: qsTr("Open the current folder in Windows Explorer")
                delay: 500
                y: -height - 4
            }
        }
        /// Indicateur de travail
        BusyIndicator {
            implicitHeight: bt_rescan.height
            running: _photoModel.loading
        }

        /// Nom du dossier en cours
        Label {
            id: folderlabel
            text: qsTr("Folder:")
            font.pixelSize: 16
            // Positionnement à l'interieur du rectangle
            verticalAlignment: Text.AlignVCenter
            visible: folderPath.visible
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
