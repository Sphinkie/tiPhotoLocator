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
    height: bottomToolBarColumn.height + 20

    property alias cb_backups: cb_backups
    property alias bt_save: bt_save
    property alias bt_quit: bt_quit
    property alias bt_dump1: bt_dump1
    property alias bt_dump2: bt_dump2
    property bool useDebug
    property bool shouldSave


    /** *************************************************************************************
     * La barre principale (toujours 3 lignes) et la ligne de debug (facultative) sont dans
     * des layouts distincts, afin que l'apparition des boutons de debug ne perturbe jamais
     * le placement des boutons Save/Quit dans le GridLayout principal.
     * **************************************************************************************/
    ColumnLayout {
        id: bottomToolBarColumn
        spacing: 0

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
                    text: qsTr("Check to keep a copy of the original photos (IMAGENAME.jpg_original)")
                    delay: 500
                    visible: parent.hovered
                    y: -height - 4
                }
            }
            Button {
                id: bt_save
                text: qsTr("Save")
                Layout.topMargin: 10
                highlighted: shouldSave
                enabled: shouldSave
                ToolTip {
                    visible: parent.hovered
                    text: qsTr("Save EXIF tags of edited photos")
                    delay: 500
                    y: -height - 4
                }
            }
            Button {
                id: bt_quit
                text: qsTr("Quit")
                Layout.rightMargin: 20
                Layout.topMargin: 10
                ToolTip {
                    visible: parent.hovered
                    text: qsTr("Quit application")
                    delay: 500
                    y: -height - 4
                }
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
        }

        /** *************************************************************************************
         * Boutons de debug : dans leur propre RowLayout, en dehors du GridLayout principal.
         * **************************************************************************************/
        RowLayout {
            id: debugToolsRow
            visible: bottomRect.useDebug
            spacing: 0

            Button {
                id: bt_dump1
                text: "Dump PhotoModel"
                Layout.leftMargin: 20
                Layout.topMargin: 10
                ToolTip {
                    visible: parent.hovered
                    text: qsTr("DEBUG: display one line of the model in the console")
                    delay: 500
                    y: -height - 4
                }
            }
            Button {
                id: bt_dump2
                text: "Dump SuggModel"
                Layout.leftMargin: 20
                Layout.topMargin: 10
                ToolTip {
                    visible: parent.hovered
                    text: qsTr("DEBUG: display one line of the model in the console")
                    delay: 500
                    y: -height - 4
                }
            }
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
