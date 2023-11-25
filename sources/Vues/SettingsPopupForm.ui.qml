import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window
import QtQuick.Layouts
import QtCore
import "../Components"

Popup {
    id: settingsForm
    width: 520
    height: 720
    property alias buttonClose: buttonClose
    property alias reglages: reglages
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Rectangle {
        color: TiStyle.tertiaryBackgroundColor
        border.color: TiStyle.tertiaryForegroundColor
        border.width: 2
    }
    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        color: "#80f3f9ec"
    }
    anchors.centerIn: Overlay.overlay

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // ------------------------------------------------------------------
        // ---------------- TITRE
        // ------------------------------------------------------------------
        Text {
            text: qsTr("Configuration")
            font.pixelSize: 24
            color: TiStyle.tertiaryForegroundColor
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            Layout.fillHeight: false
            Layout.fillWidth: true
        }

        // ------------------------------------------------------------------
        // ---------------- Group Box 1 "Default values"
        // ------------------------------------------------------------------
        GroupBox {
            id: groupBox1
            Layout.margins: 10
            Layout.fillWidth: true
            title: qsTr("Valeurs par défaut")

            ColumnLayout {
                // ------------------------------------------------------------------
                // Valeur par défaut pour CREATOR
                // ------------------------------------------------------------------
                RowLayout {
                    Text {
                        text: qsTr("Nom du photographe:")
                        font.pixelSize: 12
                    }
                    TextField {
                        id: textFieldName
                        width: 200
                        height: 30
                        placeholderText: qsTr("Enter your name here")
                    }
                    Text {
                        color: TiStyle.tertiaryForegroundColor
                        text: "Creator (IPTC)"
                        font.pixelSize: 12
                        style: Text.Normal
                    }
                }
                // ------------------------------------------------------------------
                // Valeur par défaut pour DESCRIPTION WRITER
                // ------------------------------------------------------------------
                RowLayout {
                    Text {
                        text: qsTr("Initiales du rédacteur des descriptions:")
                        font.pixelSize: 12
                    }
                    TextField {
                        id: textFieldInitials
                        width: 60
                        height: 30
                        horizontalAlignment: Text.AlignLeft
                        Layout.minimumWidth: 116
                        Layout.preferredWidth: 30
                        placeholderText: qsTr("initiales")
                    }
                    Text {
                        color: TiStyle.tertiaryForegroundColor
                        text: "Description Writer (IPTC)"
                        font.pixelSize: 12
                        style: Text.Normal
                    }
                }
                // ------------------------------------------------------------------
                // Valeur par défaut pour SOFTWARE
                // ------------------------------------------------------------------
                RowLayout {
                    Text {
                        text: qsTr("Signature application:")
                        font.pixelSize: 12
                    }
                    TextField {
                        id: textFieldSoftware
                        width: 200
                        height: 30
                        text: "TiPhotoLocator"
                        enabled: false
                    }
                    Text {
                        color: TiStyle.tertiaryForegroundColor
                        text: "Software (Exif)"
                        font.pixelSize: 12
                        style: Text.Normal
                    }
                }
            }
        }

        // ------------------------------------------------------------------
        // ---------------- Group Box 2 "Configuration"
        // ------------------------------------------------------------------
        GroupBox {
            id: groupBox2
            Layout.fillWidth: true
            Layout.margins: 10
            title: qsTr("Configuration:")

            ColumnLayout {
                Text {
                    text: qsTr("Langue de l'application:")
                    font.pixelSize: 12
                }
                ComboBox {
                    id: guiLanguages
                    width: 200
                    height: 30
                    model: ["Français"]
                }

                CheckBox {
                    id: checkBoxExif
                    text: qsTr("Ne pas modifier les tags EXIF")
                    checked: false
                }
                CheckBox {
                    id: checkBoxDebug
                    text: "Debug mode"
                }
                Text {
                    text: qsTr("Centrage carte (redémarrage nécessaire):")
                    font.pixelSize: 12
                }
                TextField {
                    id: textFieldHomecity
                    width: 200
                    height: 30
                    placeholderText: qsTr("Votre ville la plus photographiée")
                }
                Text {
                    text: qsTr("Langue des tags et suggestions:")
                    font.pixelSize: 12
                }
                ComboBox {
                    id: tagLanguages
                    width: 200
                    height: 30
                    model: ["English", "System language"]
                }
                Text {
                    text: qsTr("Clef API pour les cartes:")
                    font.pixelSize: 12
                }
                TextField {
                    id: textFieldMapApiKey
                    width: 400
                    height: 30
                    placeholderText: qsTr("XXXXXXXXXXXXXXX")
                }
            }
        }
        // ------------------------------------------------------------------
        // ---------------- Buttons
        // ------------------------------------------------------------------
        TiButton {
            id: buttonClose
            width: 100
            text: qsTr("Fermer")
            Layout.fillHeight: false
            Layout.margins: 30
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: false
            color: TiStyle.tertiaryForegroundColor
        }
    }

    // ----------------------------------------------------------------
    // On mémorise la configuration dans les settings
    // ----------------------------------------------------------------
    Settings {
        id: reglages
        //category: "configuration"
        property alias photographe: textFieldName.text
        property alias initiales: textFieldInitials.text
        property alias software: textFieldSoftware.text
        property alias homecity: textFieldHomecity.text
        property alias apikey: textFieldMapApiKey.text
        property alias preserveExif: checkBoxExif.checked
        property alias debugModeEnabled: checkBoxDebug.checked
        property alias tagLanguage: tagLanguages.currentIndex
        property alias guiLanguage: guiLanguages.currentIndex
    }
}
