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
    title: "tiPhotoLocator" // + " w:" + width + " h:" + height
    visible: true
    visibility: "Maximized"
    // dimensions si on dé-maximise
    width: 1920
    height: 1080
    // dimensions minimales
    minimumHeight: 768
    minimumWidth: 1400

    // ----------------------------------------------------------------
    // Couleurs du thème: voir aussi Style.qml
    // ----------------------------------------------------------------
    Material.theme: Material.Light
    // Couleur du fond: Barre de menu. Barre des onglets
    Material.background: Material.color(Material.BlueGrey, Material.Shade200)
    // Couleur des textes.
    Material.foreground: Material.DeepPurple
    // Couleur d'accentuation pour les items et textes en highlight.
    Material.accent: Material.color(Material.Brown, Material.Shade400)
    // Couleur primaire = non utilisé sur Desktop ?
    Material.primary: Material.Red

    // color: Style.surfaceBackgroundColor

    // ----------------------------------------------------------------
    // Les signaux vers PhotoModel pour une photo unitaire:
    // ----------------------------------------------------------------
    /// Ajoute une JPG au modèle.
    signal append(string filename, string url)
    /// Demande la lecture des metadata d'un fichier JPG.
    signal fetchSingleExifMetadata(int row)
    /// Fait un setData pour affecter un role du Model.
    signal setPhotoProperty(int photo, string texte, string target)
    /// Demande la lecture des metadata de toutes les fichiers JPG.
    signal fetchExifMetadata
    /// Ecrit les metadata sur le disque.
    signal saveMetadata
    /// Applique le Creator (des settings) à toutes les photos du modèle.
    signal applyCreatorToAll
    /// Affecte la position mémorisée à toutes les photos du cercle.
    signal applySavedPositionToCoords
    /// Mémorise la position courante.
    signal savePosition
    /// Efface une position mémorisée.
    signal clearSavedPosition
    // ----------------------------------------------------------------
    // Les signaux vers SuggestionModel
    // ----------------------------------------------------------------
    signal setSuggestionFilter(int row)
    /// Demande le filtrage des suggestions sur la catégorie donnée.
    signal setCategoryFilter(string category)
    /// Retire la photo courante de la Suggestion passée en paramètre.
    signal removePhotoFromSuggestion(int row)
    // ----------------------------------------------------------------
    // Les signaux vers geocodeWrapper
    // ----------------------------------------------------------------
    /// Demande d'informations géographiques sur la position courante.
    signal requestReverseGeocode(double lati, double longi)
    /// Demande les coordonnées GPS de la ville donnée.
    signal requestCoords(string city)

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
    // Fenêtre de dialogue pour selectionner le dossier
    // ----------------------------------------------------------------
    TiFolderDialog {
        id: folderDialog
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
    Rectangle {
        id: topLogo
        height: 50
        width: 80
        color: Material.background
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "/Images/logo_TPL.png"
            anchors {
                top: parent.top
                left: parent.left
            }
        }
    }


    /** *****************************************************************************
     * Ligne 0 : Menu principal (Prend toute la largeur)
     * ******************************************************************************/
    MainMenuBar {
        id: menuBar
        anchors {
            top: parent.top
            left: topLogo.right
            right: parent.right
        }
    }


    /** *****************************************************************************
     * Ligne 1 : Barre d'outils du folder: refresh / reload / foldername
     * ******************************************************************************/
    ToolbarPrincipale {
        id: toolBar
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
        width: parent.width
        height: filtersAndTabslayout.height
        color: Style.surfaceContainerColor

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
                TabButton {
                    text: qsTr("PREVIEW")
                }
                TabButton {
                    text: qsTr("CARTE")
                    onClicked: _suggestionCategoryProxyModel.setFilterValue(
                                   "geo")
                }
                TabButton {
                    text: qsTr("EXIF / IPTC TAGS")
                    onClicked: _suggestionCategoryProxyModel.setFilterValue(
                                   "tag")
                }
                TabButton {
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
            PhotoListview {
                id: photoListView
            }
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
            property var currentPhoto: _photoModel.get(0)

            /// ------------------ CONNEXIONS----------------------------
            Connections {
                target: _photoModel
                function onDataChanged() {
                    // console.log("PhotoModel Data changed !");
                    var currentrow = tabbedPage.currentPhoto.row
                    tabbedPage.currentPhoto = _photoModel.get(currentrow)
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
        anchors {
            bottom: parent.bottom
            right: parent.right
            left: parent.left
            bottomMargin: 8
        }

        /// Barre de boutons
        ToolbarBottom {
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
}

/*##^##
Designer {
    D{i:0;formeditorColor:"#ffffff";formeditorZoom:0.75}
}
##^##*/

