import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtCore
import "../Components"


/** **********************************************************************************************************
 * @brief Fenêtre popup de Configuration.
 * Elle se compose de deux frames: les valeurs par défaut et les reglages.
 * ***********************************************************************************************************/
Popup {
    id: settingsForm
    width: 520
    height: 720
    property alias buttonClose: buttonClose
    property alias settings: settings
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Rectangle {
        // color: Style.tertiaryBackgroundColor
        // border.color: Style.tertiaryForegroundColor
        border.width: 2
        radius: 8
    }
    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        color: "#80f3f9ec"
    }
    anchors.centerIn: Overlay.overlay

    ColumnLayout {
        anchors.fill: parent
        spacing: 10


        /** *********************************************************************
         * Titre de la fenêtre.
         * *********************************************************************/
        Text {
            text: qsTr("Configuration")
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            Layout.fillHeight: false
            Layout.fillWidth: true
        }


        /** *********************************************************************
         * Group Box 1 : "Default values"
         * *********************************************************************/
        GroupBox {
            id: groupBox1
            Layout.margins: 10
            Layout.fillWidth: true
            title: qsTr("Default values")

            ColumnLayout {
                /// Valeur par défaut pour CREATOR
                RowLayout {
                    Label {
                        text: qsTr("Photographer name:")
                        font.pixelSize: 12
                    }
                    TextField {
                        id: textFieldName
                        Layout.fillWidth: true
                        height: 30
                        placeholderText: qsTr("Enter your name here")
                    }
                    Text {
                        color: Style.tertiaryForegroundColor
                        text: "Creator (IPTC)"
                        font.pixelSize: 12
                        style: Text.Normal
                    }
                }
                /// Valeur par défaut pour CAPTION WRITER
                RowLayout {
                    Label {
                        text: qsTr("Description writer initials:")
                        font.pixelSize: 12
                    }
                    TextField {
                        id: textFieldInitials
                        Layout.fillWidth: true
                        height: 30
                        horizontalAlignment: Text.AlignLeft
                        Layout.minimumWidth: 116
                        Layout.preferredWidth: 30
                        placeholderText: qsTr("Initials")
                    }
                    Text {
                        color: Style.tertiaryForegroundColor
                        text: "Caption Writer (IPTC)"
                        font.pixelSize: 12
                        style: Text.Normal
                    }
                }
                /// Valeur par défaut pour METADATA EDITING SOFTWARE
                RowLayout {
                    Label {
                        text: qsTr("Application signature:")
                        font.pixelSize: 12
                    }
                    TextField {
                        id: textFieldMetadataSoftware
                        Layout.fillWidth: true
                        height: 30
                        text: "TiPhotoLocator"
                        enabled: false
                    }
                    Text {
                        color: Style.tertiaryForegroundColor
                        text: "Metadata Software (Exif)"
                        font.pixelSize: 12
                        style: Text.Normal
                    }
                }
            }
        }


        /** *********************************************************************
         * Group Box 2 "Configuration"
         * *********************************************************************/
        GroupBox {
            id: groupBox2
            Layout.margins: 10
            Layout.fillWidth: true
            title: qsTr("Settings")

            ColumnLayout {
                anchors.fill: parent
                /// Ville sur laquelle centrer la carte
                RowLayout {
                    Label {
                        text: qsTr("Map auto center:")
                        font.pixelSize: 12
                    }
                    TextField {
                        id: textFieldHomecity
                        Layout.fillWidth: true
                        height: 30
                        placeholderText: qsTr("Your most photographed place.")
                    }
                    Text {
                        color: Style.tertiaryForegroundColor
                        text: qsTr("Reboot needed")
                        font.pixelSize: 12
                        style: Text.Normal
                    }
                }
                /// Langue de l'application
                RowLayout {
                    Label {
                        text: qsTr("Application language:")
                        font.pixelSize: 12
                    }
                    ComboBox {
                        id: guiLanguages
                        Layout.fillWidth: true
                        height: 30
                        model: ["français"]
                    }
                }
                /// Mode debug
                RowLayout {
                    CheckBox {
                        id: checkBoxExif
                        text: qsTr("Do not change EXIF tags")
                        visible: false
                        checked: false
                    }
                    CheckBox {
                        id: checkBoxDebug
                        text: "Debug mode"
                        visible: false
                    }
                }
                /// Langue des suggestions
                RowLayout {
                    Label {
                        text: qsTr("Tags and suggestions language:")
                        font.pixelSize: 12
                    }
                    ComboBox {
                        id: tagLanguages
                        Layout.fillWidth: true
                        height: 30
                        model: ["english", sysLang + " (system)"]
                    }
                }
                /// Clef API pour les cartes
                RowLayout {
                    Label {
                        text: qsTr("Map provider API key:")
                        font.pixelSize: 12
                    }
                    TextField {
                        id: textFieldMapApiKey
                        Layout.fillWidth: true
                        height: 30
                        placeholderText: qsTr("Thunderforest or OpenStreetMap")
                    }
                }
            }
        }


        /** *********************************************************************
         * Boutons
         * *********************************************************************/
        Button {
            id: buttonClose
            width: 100
            text: qsTr("Close")
            Layout.fillWidth: false
            Layout.fillHeight: false
            Layout.margins: 0
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }
    }


    /** *********************************************************************
     * On mémorise la configuration dans les Settings
     * *********************************************************************/
    Settings {
        id: settings
        property alias photographe: textFieldName.text
        property alias initiales: textFieldInitials.text
        property alias metadataSoftware: textFieldMetadataSoftware.text
        property alias homecity: textFieldHomecity.text
        property alias mapApikey: textFieldMapApiKey.text
        property alias preserveExif: checkBoxExif.checked
        property alias debugModeEnabled: checkBoxDebug.checked
        property alias tagLanguage: tagLanguages.currentIndex // 0: English, 1: Default
        property alias guiLanguage: guiLanguages.currentIndex
    }
}
