import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtCore
import "../Components"
import ".."


/** **********************************************************************************************************
 * @brief Vue du popup de gestion des keywords utilisateur.
 * On ne peut pas faire de fichier .ui.qml à cause du repeater, qui nous oblige à utiliser des signaux.
 * *********************************************************************************************************** */
Popup {
    id: keywordsPopupForm
    width: 640
    height: 680

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

    /// Signaux vers le Controller
    signal editRequested(int index)
    signal saveRequested(int index, string value)
    signal revertRequested(int index)
    signal deleteRequested(int index)
    signal addConfirmed(string value)
    signal addCancelled

    /// Aliases exposés au Controller
    property alias customModel: customModel
    property alias settings: settings
    property alias newChip: newChip
    property alias addButton: addButton
    property alias closeButton: closeButton

    /// Liste des keywords prédéfinis, chargée par le Controller depuis les ressources
    property var predefinedKeywords: []

    ListModel {
        id: customModel
    }

    ///  Layout
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Text {
            text: qsTr("User Keywords")
            font.pixelSize: 22
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            Layout.topMargin: 2
        }

        /// Keywords prédéfinis (read-only)
        GroupBox {
            title: qsTr("Predefined keywords")
                   + (settings.tagLanguage === 0 ? " (English)" : " (Français)")
            Layout.fillWidth: true

            GridLayout {
                columns: 2
                columnSpacing: 4
                rowSpacing: 4

                Repeater {
                    model: predefinedKeywords
                    delegate: Chips {
                        content: modelData
                        Layout.leftMargin: 2
                        Layout.topMargin: 2
                    }
                }
            }
        }

        /// Keywords personnalisés
        GroupBox {
            title: qsTr("My keywords")
            Layout.fillWidth: true

            ColumnLayout {
                width: parent.width
                spacing: 4

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    columnSpacing: 4
                    rowSpacing: 4

                    Repeater {
                        model: customModel
                        delegate: Chips {
                            property bool isEditing: model.editing
                            property bool isDuplicate: {
                                var n = customModel.count
                                var cnt = 0
                                for (var i = 0; i < n; i++) {
                                    if (customModel.get(i).kw.toLowerCase(
                                                ) === model.kw.toLowerCase())
                                        cnt++
                                }
                                return cnt > 1
                            }
                            content: model.kw
                            Layout.leftMargin: 2
                            Layout.topMargin: 2
                            editable: !isEditing
                            deletable: !isEditing
                            canSave: isEditing
                            chipText.color: isDuplicate ? Style.highlightBackgroundColor : Style.primaryTextColor

                            onIsEditingChanged: {
                                if (isEditing) {
                                    chipText.readOnly = false
                                    chipText.forceActiveFocus()
                                } else {
                                    chipText.text = Qt.binding(() => content)
                                    chipText.readOnly = true
                                }
                            }

                            editArea.onClicked: editRequested(index)
                            saveArea.onClicked: saveRequested(index,
                                                              chipText.text)
                            revertArea.onClicked: revertRequested(index)
                            deleteArea.onClicked: deleteRequested(index)
                        }
                    }

                    /// Chip vide éditable pour la saisie d'un nouveau keyword
                    Chips {
                        id: newChip
                        visible: false
                        content: " "
                        canSave: true
                        Layout.leftMargin: 0
                        Layout.topMargin: 0

                        onVisibleChanged: if (visible)
                                              chipText.readOnly = false

                        saveArea.onClicked: addConfirmed(chipText.text)
                        revertArea.onClicked: addCancelled()
                    }
                }

                /// Bouton Add new
                Button {
                    id: addButton
                    text: qsTr("+ Add new keyword")
                    visible: !newChip.visible && customModel.count < 12
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        /// Espace vide
        Item {
            Layout.fillHeight: true
        }

        /// Bouton pour quitter le popup
        Button {
            id: closeButton
            text: qsTr("Close")
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 4
        }
    }

    /// Settings partagés avec PopupSettings (même clef "tagLanguage")
    Settings {
        id: settings
        property int tagLanguage: 0
        property string customKeywords: ""
    }
}
