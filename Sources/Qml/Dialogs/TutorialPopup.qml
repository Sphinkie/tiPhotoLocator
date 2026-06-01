import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material


/** **********************************************************************************************************
 * @brief Popup tutoriel — visite guidée de TiPhotoLocator en quelques pages.
 * Chaque page affiche une image (remplaçable dans pages[].image) et un texte descriptif.
 * Pas de contour Qt native : la carte flotte naturellement au-dessus de l'application.
 * ***********************************************************************************************************/
Popup {
    id: root

    parent: Overlay.overlay
    anchors.centerIn: Overlay.overlay
    modal: true // bloque les clics sur le reste de l'UI.
    dim: true // pour un fond semi-transparent derrière
    padding: 0
    closePolicy: Popup.CloseOnEscape

    width: 700
    height: 740

    // Pas de contour Qt native
    background: Item {}

    property int currentPage: 0
    onVisibleChanged: if (visible)
                          currentPage = 0

    // ------------------------------------------------------------------
    // Contenu des pages: Image et textes
    // ------------------------------------------------------------------
    readonly property var pages: [{
            "image": "qrc:/Tutorial/bellaminette-hello.png",
            "text": qsTr("Welcome to TiPhotoLocator!\n\n"
                         + "This short tutorial will guide you through the main features "
                         + "of the application.")
        }, {
            "image": "qrc:/Tutorial/bellaminette-open.png",
            "text": qsTr("Open a folder\n\n"
                         + "Use File → Open to select a folder containing your photos.\n"
                         + "The photos will be analyzed and listed.")
        }, {
            "image": "qrc:/Tutorial/bellaminette-list.png",
            "text": qsTr(
                        "Browse the list\n\n"
                        + "The photos are listed on the left side of the window.\n"
                        + "The pin marker indicates the photos that are already geolocalized.")
        }, {
            "image": "qrc:/Tutorial/bellaminette-tabs.png",
            "text": qsTr("Edit metadata of the different tabs\n\n"
                         + "Add keywords, titles, and captions to your photos.\n")
        }, {
            "image": "qrc:/Tutorial/bellaminette-map.png",
            "text": qsTr(
                        "Geotag your photos\n\n"
                        + "Click on the map to assign a location to the selected photo.\n"
                        + "Soon, you will also be able to load a GPX track to geotag photos automatically.")
        }, {
            "image": "qrc:/Tutorial/bellaminette-save.png",
            "text": qsTr("Save you changes\n\n"
                         + "A the end, hit Save to write the changes into the EXIF/IPTC data.")
        }]

    // ── Carte visuelle ────────────────────────────────────────────────────────
    Rectangle {
        id: card
        anchors.fill: parent
        radius: 14
        color: Qt.rgba(0.97, 0.97, 0.90, 0.22)
        clip: true

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // ── Image (remplit l'espace disponible)
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Image {
                    anchors.fill: parent
                    anchors.margins: 20
                    source: root.pages[root.currentPage].image
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    smooth: true
                }
            }

            // ── Séparateur
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: Qt.rgba(0.1, 0.1, 0.1, 0.32)
            }

            // ── Texte de la page
            Text {
                Layout.fillWidth: true
                topPadding: 14
                bottomPadding: 8
                leftPadding: 24
                rightPadding: 24
                text: root.pages[root.currentPage].text
                color: "black"
                wrapMode: Text.WordWrap
                font.pointSize: 12
            }

            // ── Barre de navigation
            Item {
                Layout.fillWidth: true
                implicitHeight: 56

                // Indicateurs de page (dots)
                Row {
                    anchors {
                        left: parent.left
                        leftMargin: 20
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: 7
                    Repeater {
                        model: root.pages.length
                        Rectangle {
                            width: index === root.currentPage ? 20 : 8
                            height: 8
                            radius: 4
                            color: index
                                   === root.currentPage ? Style.tertiaryForegroundColor : Qt.rgba(
                                                              1, 1, 1, 0.30)
                            anchors.verticalCenter: parent.verticalCenter
                            Behavior on width {
                                NumberAnimation {
                                    duration: 180
                                    easing.type: Easing.OutCubic
                                }
                            }
                        }
                    }
                }

                // Boutons droite
                Row {
                    anchors {
                        right: parent.right
                        rightMargin: 14
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: 6

                    Button {
                        text: qsTr("Close")
                        flat: true
                        Material.foreground: Qt.rgba(1, 1, 1, 0.65)
                        onClicked: root.close()
                    }

                    Button {
                        text: root.currentPage < root.pages.length - 1 ? qsTr("Next  ›") : qsTr(
                                                                             "Done")
                        highlighted: true
                        onClicked: {
                            if (root.currentPage < root.pages.length - 1)
                                root.currentPage++
                            else
                                root.close()
                        }
                    }
                }
            }
        }
    }
}
