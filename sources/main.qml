import QtQuick
import QtQml.Models
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import QtCore

import "./Dialogs"
import "./Components"
import "./Models"
import "./Controllers"

Window {
    id: window
    title: "tiPhotoLocator"
    visible: true
    visibility: "Maximized"
    // dimensions si on démaximise
    width: 1920
    height: 1080
    // dimensions minimales
    minimumHeight: 640
    minimumWidth: 1200
    color: TiStyle.surfaceBackgroundColor

    // ----------------------------------------------------------------
    // Les signaux vers PhotoModel
    // ----------------------------------------------------------------
    // sur une photo unitaire:
    signal append(string filename, string url)                      // Ajoute une JPG au modèle
    signal fetchSingleExifMetadata(int row)                         // Lit les metadata d'une JPG
    signal setPhotoProperty(int photo, string texte, string target) // Fait un setData pour affecter un role du Model
    signal setSelectedPhotoCoords(double lati, double longi)        // Positionne les coords de la photo séléctionnée
    // sur plusieurs photos:
    signal fetchExifMetadata()                                      // Lit les metadata de toutes les JPG
    signal saveMetadata()                                           // Ecrit les metadata sur le disque
    signal applyCreatorToAll()                                      // Applique le Creator (des settings) à toutes les photos du modèle
    signal applySavedPositionToCoords()                             // Affecte la position mémorisée à toutes les photos du cercle
    // Gestion de la SavedPosition
    signal savePosition(double lati, double longi)                  // Mémorise une position
    signal clearSavedPosition()                                     // Efface une position mémorisée
    // ----------------------------------------------------------------
    // Les signaux vers SuggestionModel
    // ----------------------------------------------------------------
    signal setSuggestionFilter(int row)
    signal setCategoryFilter(string category)
    signal removePhotoFromSuggestion(int row)       // Retire la photo courante de la Suggestion passée en paramètre
    // ----------------------------------------------------------------
    // Autres signaux
    // ----------------------------------------------------------------
    signal requestReverseGeocode(double lati, double longi)
    signal requestCoords(string city)


    // ----------------------------------------------------------------
    // Fenêtre de dialogue pour selectionner le dossier
    // ----------------------------------------------------------------
    TiFolderDialog { id: folderDialog }
    // ----------------------------------------------------------------
    // Déclaration des popups
    // ----------------------------------------------------------------
    AboutDialog   { id: aboutPage }
    CreditsDialog { id: creditsPage}
    ApikeyDialog  { id: apiPage}
    RescanWarning { id: rescanWarning}
    SettingsPopup { id: settingsPopup}
    MetadataPopup { id: metadataPopup}
    // ----------------------------------------------------------------
    // Modèles de données: Liste des fichiers du dossier
    // ----------------------------------------------------------------
    ModelFolderList { id: folderListModel }


    // ----------------------------------------------------------------
    // Page principale
    // ----------------------------------------------------------------

    // Ligne 0 --------------------------------------------------------
    // Menu principal (Prend toute la largeur)
    // ----------------------------------------------------------------
    TiMenuBar {
        id: menuBar
        anchors {top: parent.top; left: parent.left; right: parent.right;}
    }

    // Ligne 1 --------------------------------------------------------
    // Barre d'outils du folder: refresh / reload / rescan / foldername
    // ----------------------------------------------------------------
    ToolBarPrincipale {
        id: toolBar
        width: parent.width
        anchors {top: menuBar.bottom; left: parent.left}
    }

    // Ligne 2 --------------------------------------------------------
    // Filtres et Onglets
    // ----------------------------------------------------------------
    Rectangle {
        id:filtersAndTabsBar
        anchors.top: toolBar.bottom
        color: TiStyle.surfaceContainerColor
        width: parent.width
        height: filtersAndTabslayout.height

        RowLayout{
            id: filtersAndTabslayout
            anchors {left: parent.left; right: parent.right;}

            CheckBox {
                id: checkBox1
                Layout.leftMargin: 20
                text: qsTr("sans date")
                ToolTip.text: qsTr("Liste des photos sans date")
                ToolTip.visible: hovered
                ToolTip.delay: 500
                checked: false
                onClicked: {
                    _undatedPhotoProxyModel.filterEnabled = checked;
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
                    _unlocalizedProxyModel.filterEnabled = checked;
                }
            }

            TabBar {
                id: tabBar
                Layout.leftMargin: 120
                Layout.fillWidth: true
                Layout.rightMargin: 40
                TiTabButton { text: qsTr("PREVIEW"); }
                TiTabButton { text: qsTr("CARTE");  filter: "geo" }
                TiTabButton { text: qsTr("EXIF / IPTC TAGS"); filter: "tag"; }
                TiTabButton { text: qsTr("GLOBAL"); }
            }
        }
    }

    // Ligne 3 --------------------------------------------------------
    // ListView des filenames des photos + page de contenu de l'onglet
    // ----------------------------------------------------------------
    RowLayout{
        anchors {top: filtersAndTabsBar.bottom; bottom: imagettes.top; left: parent.left; right: parent.right;}

        Frame {
            id: listViewFrame
            Layout.fillHeight: true
            Layout.fillWidth: false
            Layout.margins: 4
            Layout.preferredHeight: 200
            Layout.preferredWidth: 380
            TiPhotoListview {}
        }

        StackLayout {
            id: tabbedPage
            Layout.fillWidth: true
            currentIndex: tabBar.currentIndex
            property var selectedData: _photoModel.get(0)  // On l'initialise sur la photo Welcome (type = QVariantMap)

            Connections{
                target: _photoModel
                function onDataChanged() {
                    console.log("PhotoModel Data changed !");
                    var currentrow = tabbedPage.selectedData.row;
                    tabbedPage.selectedData = _photoModel.get(currentrow);
                }
            }

            // ------------------ PREVIEW TAB --------------------------
            TiPhotoPreview { id: previewView; Layout.fillWidth: true}

            // ------------------ MAP TAB ------------------------------
            GridLayout {
                id: mapTab
                Layout.fillWidth: true
                // Les coordonnées du point sélectionné
                // Actualisé lors d'un clic sur la listView, ou sur la carte.
                property point homeCoords
                //property double photoLatitude: settings.homeCoords.x
                //property double photoLongitude: settings.homeCoords.y
                property double photoLatitude: homeCoords.x
                property double photoLongitude: homeCoords.y
                columnSpacing: 8
                rows: 3     // toolbar et carte/zones
                columns: 2  // carte et zone des tags
                // T T
                // M Z1
                // M Z2

                // Barre d'outils pour la carte (controleur)
                ToolBarMap {
                    id: mapTools
                    Layout.columnSpan: 2  // Toute la largeur
                    Layout.fillWidth: true
                }

                TiMapView {
                    id: mapView
                    Layout.rowSpan: 2     // Haute comme 2 zones
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                // Affichage des infos supplémentaires (coords GPS, etc)
                ZoneGeoloc{
                    Layout.rightMargin: 40
                    Layout.fillHeight: true
                }
                ZoneSuggestion{
                    id: zoneSuggestionGeo
                    Layout.rightMargin: 40
                    Layout.fillHeight: true
                }
                //                Zone{
                //                  Layout.rightMargin: 40
                //                  Layout.fillHeight: true
                //                  color: TiStyle.trashcanBackgroundColor
                //                  iconZone: "qrc:/Images/trashcan.png"
                //                }
            }

            // ------------------ IPTC/EXIF TAGS TAB ----------------------------
            TiPhotoTags { id: photoTagsTab }

            // ------------------ GLOBAL TAB ----------------------------
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                ExifTitle {
                    Layout.fillWidth: true
                    Layout.topMargin: 20
                    Layout.rightMargin: 40
                }
                ExifGrid {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                IptcTitle {
                    Layout.fillWidth: true
                    Layout.rightMargin: 40
                }
                IptcGrid {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

        }
    }

    // --------------------------------- Ligne 4
    // Imagettes
    // ----------------------------------------------------------------
    TiImagettes{
        id: imagettes
        height: 120
        anchors {bottom: bottomToolBar.top; left: parent.left; right: parent.right;}
    }

    // --------------------------------- Ligne 5
    // Barre de boutons en bas
    // ----------------------------------------------------------------
    ToolBarBottom {
        id: bottomToolBar
        anchors.bottom: parent.bottom
        width: parent.width
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
