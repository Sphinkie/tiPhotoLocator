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
            title: qsTr("Valeurs par défaut")

            ColumnLayout {
                /// Valeur par défaut pour CREATOR
                RowLayout {
                    Label {
                        text: qsTr("Nom du photographe:")
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
                        text: qsTr("Initiales du rédacteur des descriptions:")
                        font.pixelSize: 12
                    }
                    TextField {
                        id: textFieldInitials
                        Layout.fillWidth: true
                        height: 30
                        horizontalAlignment: Text.AlignLeft
                        Layout.minimumWidth: 116
                        Layout.preferredWidth: 30
                        placeholderText: qsTr("initiales")
                    }
                    Text {
                        color: Style.tertiaryForegroundColor
                        text: "Caption Writer (IPTC)"
                        font.pixelSize: 12
                        style: Text.Normal
                    }
                }
                /// Valeur par défaut pour SOFTWARE
                RowLayout {
                    Label {
                        text: qsTr("Signature application:")
                        font.pixelSize: 12
                    }
                    TextField {
                        id: textFieldSoftware
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
            title: qsTr("Configuration")

            ColumnLayout {
                anchors.fill: parent
                /// Ville sur laquelle centrer la carte
                RowLayout {
                    Label {
                        text: qsTr("Centrage carte:")
                        font.pixelSize: 12
                    }
                    TextField {
                        id: textFieldHomecity
                        Layout.fillWidth: true
                        height: 30
                        placeholderText: qsTr("Votre ville la plus photographiée")
                    }
                    Text {
                        color: Style.tertiaryForegroundColor
                        text: "Redémarrage nécessaire"
                        font.pixelSize: 12
                        style: Text.Normal
                    }
                }
                /// Langue de l'application
                RowLayout {
                    Label {
                        text: qsTr("Langue de l'application:")
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
                        text: qsTr("Ne pas modifier les tags EXIF")
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
                        text: qsTr("Langue des tags et suggestions:")
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
                    Text {
                        text: qsTr("Clef API pour les cartes:")
                        font.pixelSize: 12
                        visible: false
                    }
                    TextField {
                        id: textFieldMapApiKey
                        Layout.fillWidth: true
                        height: 30
                        placeholderText: qsTr("XXXXXXXXXXXXXXX")
                        visible: false
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
            text: qsTr("Fermer")
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
        property alias software: textFieldSoftware.text
        property alias homecity: textFieldHomecity.text
        property alias mapApikey: textFieldMapApiKey.text
        property alias preserveExif: checkBoxExif.checked
        property alias debugModeEnabled: checkBoxDebug.checked
        property alias tagLanguage: tagLanguages.currentIndex // 0: English, 1: Default
        property alias guiLanguage: guiLanguages.currentIndex
    }
}
