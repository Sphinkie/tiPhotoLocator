import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import QtCore
import "../Components"

/** **********************************************************************************************************
 * @brief Fenêtre popup de Configuration.
 * Deux onglets : "General" (paramètres usuels) et "API Keys" (Map, Groq, DeepAI).
 * ***********************************************************************************************************/
Popup {
    id: settingsForm
    width: 560
    height: 760
    property alias buttonClose: buttonClose
    property alias settings: settings
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Rectangle {
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
        spacing: 2

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
         * TabBar : General / API Keys
         * *********************************************************************/
        TabBar {
            id: tabBar
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10

            MyTabButton {
                text: qsTr("General")
            }
            MyTabButton {
                text: qsTr("API Keys")
            }
        }

        /** *********************************************************************
         * Contenu des onglets
         * *********************************************************************/
        StackLayout {
            currentIndex: tabBar.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true

            // ─── Onglet General ──────────────────────────────────────────────
            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 2

                    /** ---------------------------------------------------------
                     * Group Box 1 : "Default values"
                     * --------------------------------------------------------*/
                    GroupBox {
                        Layout.margins: 10
                        Layout.fillWidth: true
                        title: qsTr("Default values")

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 14

                            /// Valeur par défaut pour CREATOR
                            RowLayout {
                                Label {
                                    text: qsTr("Photographer name:")
                                    font.pixelSize: 12
                                }
                                TextFieldSettings {
                                    id: textFieldName
                                    Layout.fillWidth: true
                                    placeholderText: qsTr("Enter your name here")
                                }
                                Text {
                                    color: Style.tertiaryForegroundColor
                                    text: "Creator (IPTC)"
                                    font.pixelSize: 12
                                }
                            }
                            /// Valeur par défaut pour CAPTION WRITER
                            RowLayout {
                                Label {
                                    text: qsTr("Description writer initials:")
                                    font.pixelSize: 12
                                }
                                TextFieldSettings {
                                    id: textFieldInitials
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignLeft
                                    Layout.minimumWidth: 116
                                    Layout.preferredWidth: 30
                                    placeholderText: qsTr("Initials")
                                }
                                Text {
                                    color: Style.tertiaryForegroundColor
                                    text: "Caption Writer (IPTC)"
                                    font.pixelSize: 12
                                }
                            }
                            /// Valeur par défaut pour METADATA EDITING SOFTWARE
                            RowLayout {
                                Label {
                                    text: qsTr("Application signature:")
                                    font.pixelSize: 12
                                }
                                TextFieldSettings {
                                    id: textFieldMetadataSoftware
                                    Layout.fillWidth: true
                                    text: "TiPhotoLocator"
                                    enabled: false
                                }
                                Text {
                                    color: Style.tertiaryForegroundColor
                                    text: "Metadata Software (EXIF)"
                                    font.pixelSize: 12
                                }
                            }
                        }
                    }

                    /** ---------------------------------------------------------
                     * Group Box 2 : "Settings"
                     * --------------------------------------------------------*/
                    GroupBox {
                        Layout.margins: 10
                        Layout.fillWidth: true
                        title: qsTr("Settings")

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 14

                            /// Ville sur laquelle centrer la carte
                            RowLayout {
                                Label {
                                    text: qsTr("Map auto center:")
                                    font.pixelSize: 12
                                }
                                TextFieldSettings {
                                    id: textFieldHomecity
                                    Layout.fillWidth: true
                                    placeholderText: qsTr("Your most photographed place.")
                                }
                                Text {
                                    color: Style.tertiaryForegroundColor
                                    text: qsTr("Reboot needed")
                                    font.pixelSize: 12
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
                                    implicitHeight: 36
                                    model: ["English", "Français"]
                                }
                                Text {
                                    color: Style.tertiaryForegroundColor
                                    text: qsTr("Reboot needed")
                                    font.pixelSize: 12
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
                                    implicitHeight: 36
                                    model: ["English", "Français"]
                                }
                                Text {
                                    color: Style.tertiaryForegroundColor
                                    text: qsTr("Reboot needed")
                                    font.pixelSize: 12
                                }
                            }
                            /// Map Provider (Thunderforest or OpenStreetMap)
                            RowLayout {
                                Label {
                                    text: qsTr("Map Provider:")
                                    font.pixelSize: 12
                                }
                                ComboBox {
                                    id: mapProvider
                                    Layout.fillWidth: true
                                    implicitHeight: 36
                                    model: ["OSM Street map", "OSM Terrain Map", "ThunderForest"]
                                }
                                Text {
                                    color: Style.tertiaryForegroundColor
                                    text: qsTr("Reboot needed")
                                    font.pixelSize: 12
                                }
                            }
                            /// Style de carte
                            RowLayout {
                                Label {
                                    text: qsTr("Map theme:")
                                    font.pixelSize: 12
                                }
                                ComboBox {
                                    id: mapTheme
                                    Layout.fillWidth: true
                                    implicitHeight: 36
                                    model: ["outdoors", "landscape", "cycle", "neighbourhood", "atlas"]
                                }
                                Text {
                                    color: Style.tertiaryForegroundColor
                                    text: qsTr("Reboot needed")
                                    font.pixelSize: 12
                                }
                            }
                            // Mode DEBUG (caché)
                            RowLayout {
                                CheckBox {
                                    id: checkBoxDebug
                                    text: "Debug mode"
                                    visible: false
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }

            // ─── Onglet API Keys ─────────────────────────────────────────────
            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 2

                    GroupBox {
                        Layout.margins: 10
                        Layout.fillWidth: true
                        title: qsTr("API Keys")

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 14

                            /// Clef API pour les cartes (Thunderforest)
                            RowLayout {
                                property bool apiKeyVisible: false

                                Label {
                                    text: qsTr("Map provider API key:")
                                    font.pixelSize: 12
                                }
                                TextFieldSettings {
                                    id: textFieldMapApiKey
                                    Layout.fillWidth: true
                                    placeholderText: qsTr("Thunderforest or OpenStreetMap")
                                    echoMode: parent.apiKeyVisible ? TextInput.Normal : TextInput.Password
                                }
                                RoundButton {
                                    icon.source: "qrc:/Images/bt-eye.png"
                                    flat: true
                                    implicitHeight: 42
                                    implicitWidth: 42
                                    onClicked: parent.apiKeyVisible = !parent.apiKeyVisible
                                }
                            }

                            /// Clef API (token) pour VLM (Groq / reconnaissance de lieux)
                            RowLayout {
                                property bool apiKeyVisible: false

                                Label {
                                    text: qsTr("VLM API key (Groq):")
                                    font.pixelSize: 12
                                }
                                TextFieldSettings {
                                    id: textFieldVLMToken
                                    Layout.fillWidth: true
                                    placeholderText: qsTr("Groq API key")
                                    echoMode: parent.apiKeyVisible ? TextInput.Normal : TextInput.Password
                                }
                                RoundButton {
                                    icon.source: "qrc:/Images/bt-eye.png"
                                    flat: true
                                    implicitHeight: 42
                                    implicitWidth: 42
                                    onClicked: parent.apiKeyVisible = !parent.apiKeyVisible
                                }
                            }

                            /// Clef API pour DeepAI (génération de vignettes d'APN)
                            RowLayout {
                                property bool apiKeyVisible: false

                                Label {
                                    text: qsTr("Camera AI (DeepAI):")
                                    font.pixelSize: 12
                                }
                                TextFieldSettings {
                                    id: textFieldDeepAIKey
                                    Layout.fillWidth: true
                                    placeholderText: qsTr("DeepAI API key (optional)")
                                    echoMode: parent.apiKeyVisible ? TextInput.Normal : TextInput.Password
                                }
                                RoundButton {
                                    icon.source: "qrc:/Images/bt-eye.png"
                                    flat: true
                                    implicitHeight: 42
                                    implicitWidth: 42
                                    onClicked: parent.apiKeyVisible = !parent.apiKeyVisible
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
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
        property alias vlmApiKey: textFieldVLMToken.text
        property alias deepaikey: textFieldDeepAIKey.text
        property alias debugModeEnabled: checkBoxDebug.checked
        property alias tagLanguage: tagLanguages.currentIndex
        property alias guiLanguage: guiLanguages.currentIndex
        property alias mapTheme: mapTheme.currentText
        property alias mapProvider: mapProvider.currentIndex
    }
}
