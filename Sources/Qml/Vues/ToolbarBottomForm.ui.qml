import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtCore
import "../Components"


/** **********************************************************************************************************
 * @brief Vue de la barre de boutons du bas.
 * *********************************************************************************************************** */
Rectangle {
    id: bottomRect
    height: bottomToolBarLayout.height + 20

    property alias cb_backups: cb_backups
    property alias bt_save: bt_save
    property alias bt_quit: bt_quit
    property alias bt_dump1: bt_dump1
    property alias bt_dump2: bt_dump2
    property bool useDebug
    property bool shouldSave


    /** *************************************************************************************
     * Les boutons sont en ligne, calée sur la droite.
     * **************************************************************************************/
    GridLayout {
        id: bottomToolBarLayout
        columns: 3
        columnSpacing: 20

        /// Ligne 0:
        Text {
            text: qsTr("%n selected photos / ", "0",
                       _photoModel.selectionCount) + _photoModel.count
            leftPadding: 8
            Layout.row: 0
            Layout.column: 0
        }

        /// Ligne 1:
        CheckBox {
            id: cb_backups
            text: qsTr("Generate backups")
            Layout.topMargin: 10
            Layout.row: 1
            ToolTip {
                text: qsTr("Cocher pour faire une sauvegarde des photos originales (IMAGENAME.jpg_original)")
                delay: 500
                visible: parent.hovered
            }
        }
        Button {
            id: bt_save
            text: qsTr("Save")
            Layout.topMargin: 10
            highlighted: shouldSave
            ToolTip.text: qsTr("Enregistre les tags EXIF des photos modifiées")
            ToolTip.visible: hovered
            ToolTip.delay: 500
        }
        Button {
            id: bt_quit
            text: qsTr("Quit")
            ToolTip.text: qsTr("Quit application")
            ToolTip.visible: hovered
            ToolTip.delay: 500
            Layout.rightMargin: 20
            Layout.topMargin: 10
        }
        /// Ligne 2:
        ProgressBar {
            id: saveProgress
            Layout.row: 2
            Layout.column: 1
            Layout.columnSpan: 2
            value: _photoModel.writeProgress
            visible: (value > 0 && value < 1)
        }

        /// Ligne 3:
        Button {
            id: bt_dump1
            Layout.row: 3
            Layout.column: 0
            text: "Dump PhotoModel"
            visible: bottomRect.useDebug
            ToolTip.text: qsTr("DEBUG: Affiche une ligne du modèle dans la console")
            ToolTip.visible: hovered
            ToolTip.delay: 500
            Layout.leftMargin: 20
            Layout.topMargin: 10
        }
        Button {
            id: bt_dump2
            Layout.row: 3
            Layout.column: 1
            text: "Dump SuggModel"
            visible: bottomRect.useDebug
            ToolTip.text: qsTr("DEBUG: Affiche une ligne du modèle dans la console")
            ToolTip.visible: hovered
            ToolTip.delay: 500
            Layout.leftMargin: 20
            Layout.topMargin: 10
        }
    }


    /** *************************************************************************************
     * Mémorisation de la ckeckbox "Générer backups" dans les Settings.
     * **************************************************************************************/
    Settings {
        id: settings
        property alias backupsEnabled: cb_backups.checked
        property alias debugModeEnabled: bottomRect.useDebug
    }
}
