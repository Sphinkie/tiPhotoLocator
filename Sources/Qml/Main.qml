import QtQuick
import QtQml.Models
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtCore

import "./Dialogs"
import "./Components"
import "./Models"
import "./Controllers"


/** **********************************************************************************************************
 * @brief QML: Fenêtre principale.
 * ***********************************************************************************************************/
Window {
    id: window
    title: "tiPhotoLocator" + " w:" + width + " h:" + height
    visible: true
    visibility: "Maximized"
    // dimensions si on démaximise
    width: 1920
    height: 1080
    // dimensions minimales
    minimumHeight: 640
    minimumWidth: 1400

    // ----------------------------------------------------------------
    // Couleurs du thème: voir aussi fichier conf.
    // ----------------------------------------------------------------
    Material.theme: Material.Light
    // Couleur des textes
    Material.foreground: Material.Orange
    // Couleur primaire = le bandeau de l'application. Les Chips.
    Material.primary: Material.Green
    // Couleur d'accentuation pour les items en highlight.
    Material.accent: Material.Red
    // Couleur du fond: Barre de menu. Barre des onglets. Zones.
    Material.background: Material.LightGreen

    // color: Style.surfaceBackgroundColor

    // ----------------------------------------------------------------
    // Les signaux vers PhotoModel
    // ----------------------------------------------------------------
    // sur une photo unitaire:
    signal append(string filename, string url)
    //< Ajoute une JPG au modèle
    signal fetchSingleExifMetadata(int row)
    //< Lit les metadata d'une JPG
    signal setPhotoProperty(int photo, string texte, string target)
    //< Fait un setData pour affecter un role du Model
    signal setSelectedPhotoCoords(var coords)
    //< Positionne les coords de la photo séléctionnée sur plusieurs photos
    signal fetchExifMetadata
    //< Lit les metadata de toutes les JPG
    signal saveMetadata
    //< Ecrit les metadata sur le disque
    signal applyCreatorToAll
    //< Applique le Creator (des settings) à toutes les photos du modèle
    signal applySavedPositionToCoords
    //< Affecte la position mémorisée à toutes les photos du cercle
    signal savePosition(var coords)
    //< Mémorise une position
    signal clearSavedPosition
    //< Efface une position mémorisée
    // ----------------------------------------------------------------
    // Les signaux vers SuggestionModel
    // ----------------------------------------------------------------
    signal setSuggestionFilter(int row)
    signal setCategoryFilter(string category)
    signal removePhotoFromSuggestion(int row)
    //< Retire la photo courante de la Suggestion passée en paramètre
    // ----------------------------------------------------------------
    // Les signaux vers geocodeWrapper
    // ----------------------------------------------------------------
    signal requestReverseGeocode(point coords)
    signal requestCoords(string city)

    // ----------------------------------------------------------------
    // Fenêtre de dialogue pour selectionner le dossier
    // ----------------------------------------------------------------
    TiFolderDialog {
        id: folderDialog
    }
    // ----------------------------------------------------------------
    // Déclaration des popups
    // ----------------------------------------------------------------
    AboutDialog {
        id: aboutPage
    }
    CreditsDialog {
        id: creditsPage
    }
    ApikeyDialog {
        id: apiPage
    }
    RescanWarning {
        id: rescanWarning
    }
    SettingsPopup {
        id: settingsPopup
    }
    MetadataPopup {
        id: metadataPopup
    }
    // ----------------------------------------------------------------
    // Modèles de données: Liste des photos (fichiers) du dossier
    // ----------------------------------------------------------------
    ModelFolderList {
        id: folderListModel
    }

    // ------------------------------------------------------------------------------
    // Page principale
    // ------------------------------------------------------------------------------


    /** *****************************************************************************
     * Ligne 0 : Menu principal (Prend toute la largeur)
     * ******************************************************************************/
    TiMenuBar {
        id: menuBar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
    }


    /** *****************************************************************************
     * Ligne 1 : Barre d'outils du folder: refresh / reload / rescan / foldername
     * ******************************************************************************/
    ToolBarPrincipale {
        id: toolBar
        //width: parent.width
        anchors {
            top: menuBar.bottom
            right: parent.right
            left: parent.left
        }
    }


    /** *****************************************************************************
     * Ligne 2 : Filtres et Onglets
     * ******************************************************************************/
    Rectangle {
        id: line2
        anchors.top: toolBar.bottom
        // TODO color: Style.surfaceContainerColor
        width: parent.width
        height: filtersAndTabslayout.height

        RowLayout {
            id: filtersAndTabslayout
            anchors {
                left: parent.left
                right: parent.right
            }

            CheckBox {
                id: checkBox1
                Layout.leftMargin: 20
                text: qsTr("sans date")
                ToolTip.text: qsTr("Liste des photos sans date")
                ToolTip.visible: hovered
                ToolTip.delay: 500
                checked: false
                onClicked: {
                    _undatedPhotoProxyModel.filterEnabled = checked
                }
            }

            CheckBox {
                id: checkBox2
                Layout.leftMargin: 20
                text: qsTr("sans localisation")
                ToolTip.text: qsTr("Liste des photos sans localisation")
                ToolTip.visible: hovered
                ToolTip.delay: 500
                checked: false
                onClicked: {
                    _unlocalizedProxyModel.filterEnabled = checked
                }
            }

            TabBar {
                id: tabBar
                Layout.leftMargin: 120
                Layout.fillWidth: true
                Layout.rightMargin: 40
                TiTabButton {
                    text: qsTr("PREVIEW")
                }
                TiTabButton {
                    text: qsTr("CARTE")
                    filter: "geo"
                }
                TiTabButton {
                    text: qsTr("EXIF / IPTC TAGS")
                    filter: "tag"
                }
                TiTabButton {
                    text: qsTr("GLOBAL")
                }
            }
        }
    }


    /** *****************************************************************************
     * Ligne 3 : ListView des filenames + Page de contenu de l'onglet.
     * ******************************************************************************/
    RowLayout {
        id: line3
        anchors {
            top: line2.bottom
            bottom: line4.top
            left: parent.left
            right: parent.right
        }


        /** *************************************************************************
         * Encadré avec la ListView des filenames. (Largeur fixe).
         * **************************************************************************/
        Frame {
            id: listViewFrame
            Layout.fillHeight: true
            Layout.fillWidth: false
            Layout.margins: 4
            Layout.preferredHeight: 200
            Layout.preferredWidth: 380
            TiPhotoListview {}
        }


        /** *************************************************************************
         * Frames avec le contenu des onglets.
         * **************************************************************************/
        StackLayout {
            id: tabbedPage
            Layout.fillWidth: true
            Layout.margins: 16

            currentIndex: tabBar.currentIndex
            // On l'initialise sur la photo Welcome (type = QVariantMap)
            property var selectedData: _photoModel.get(0)

            /// ------------------ CONNEXIONS----------------------------
            Connections {
                target: _photoModel
                function onDataChanged() {
                    // console.log("PhotoModel Data changed !");
                    var currentrow = tabbedPage.selectedData.row
                    tabbedPage.selectedData = _photoModel.get(currentrow)
                }
            }

            /// ------------------ PREVIEW TAB --------------------------
            TabFramePhotoPreview {
                id: previewView
                Layout.fillWidth: true
            }

            /// ------------------ MAP TAB ------------------------------
            TabFramePhotoMap {
                id: mapTab
                Layout.fillWidth: true
            }

            /// ------------------ IPTC/EXIF TAGS TAB ----------------------------
            TabFramePhotoTags {
                id: photoTagsTab
                Layout.fillWidth: true
            }

            /// ------------------ GLOBAL TAGS TAB ----------------------------
            TabFrameGlobalTags {
                id: tabFrameGlobalTags
                Layout.fillWidth: true
            }
        }
    }


    /** *****************************************************************************
     * Ligne 4 : Boutons et Imagettes.
     * ******************************************************************************/
    RowLayout {
        id: line4
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        //anchors.top: line3.bottom

        /// Barre de boutons
        ToolBarBottom {
            id: bottomToolBar
            height: 160
            Layout.preferredWidth: 380
        }

        /// Barre des imagettes
        ImagettesListView {
            id: imagettes
            height: 160
            Layout.fillWidth: true
            Layout.rightMargin: 30
        }
    }

    // ----------------------------------------------------------------
    // Lecture des Settings
    // ----------------------------------------------------------------
    Settings {
        id: settings
        property alias homeCoords: mapTab.homeCoords
    }
}

/*##^##
Designer {
    D{i:0;formeditorColor:"#ffffff";formeditorZoom:0.75}
}
##^##*/

