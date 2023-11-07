import QtQuick
import QtQml.Models
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.settings

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
    // Les signaux
    // ----------------------------------------------------------------
    signal append(string filename, string url)
    signal setSelectedItemCoords(double lati, double longi)
    signal savePosition(double lati, double longi)
    signal clearSavedPosition()
    signal applySavedPositionToCoords()
    signal fetchExifMetadata()
    signal saveMetadata()
    signal hasPos()
    signal requestReverseGeocode(double lati, double longi)
    signal setPhotoFilter(int row)
    signal setPhotoProperty(int index, string texte, string target)
    signal removePhotoFrom(int row)

    // ----------------------------------------------------------------
    // Fenetre de dialogue pour selectionner le dossier
    // ----------------------------------------------------------------
    TiFolderDialog { id: folderDialog }
    // ----------------------------------------------------------------
    // Déclaration des popups  // TODO : est-ce le bon endroit ?
    // ----------------------------------------------------------------
    About { id: about }
    Credits { id: creditsPage}
    RescanWarning { id: rescanWarning}
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
    TiToolBar_ctrl {
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
                // TODO : hint: "Liste des photos sans date"
            }
            CheckBox {
                id: checkBox2
                Layout.leftMargin: 20
                text: qsTr("sans localisation")
                // TODO : hint: "Liste des photos sans localisation"
                checked: false
                onClicked: {
                    // voir exemple https://github.com/KDAB/kdabtv/blob/master/qml-intro/sol-qmlqsortfilterproxymodel/main.qml
                    _cppFilterProxyModel.gpsFilterEnabled = checked; // TODO : implementer un proxy model pour ce filtrage
                }
            }

            TabBar {
                id: tabBar
                Layout.leftMargin: 120
                Layout.fillWidth: true
                Layout.rightMargin: 40
                TabButton { text: qsTr("PREVIEW") }
                TabButton { text: qsTr("CARTE")   }
                TabButton { text: qsTr("EXIF/IPTC TAGS") }
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
            Layout.fillWidth: false
            Layout.fillHeight: true
            Layout.preferredHeight: 200
            Layout.preferredWidth: 380
            TiPhotoListview { id: photoListAndDelegate }
        }

        StackLayout {
            id: tabbedPage
            Layout.fillWidth: true
            currentIndex: tabBar.currentIndex
            property var selectedData: _photoListModel.get(0)  // On l'initialise sur la photo Welcome (type = QVariantMap)

            // ------------------ PREVIEW TAB --------------------------
            TiPhotoPreview { id: previewView; Layout.fillWidth: true}

            // ------------------ MAP TAB ------------------------------
            GridLayout {
                id: mapTab
                Layout.fillWidth: true
                // Les coordonnées du point sélectionné
                // Actualisé lors d'un clic sur la listView, ou sur la carte.
                property double photoLatitude: 0
                property double photoLongitude: 0
                columnSpacing: 8
                rows: 4     // toolbar et carte/zones
                columns: 2  // carte et zone des tags
                // T T
                // M Z1
                // M Z2
                // M Z3

                // Barre d'outils pour la carte (controleur)
                TiMapToolBar {
                    id: mapTools
                    Layout.columnSpan: 2  // Toute la largeur
                    Layout.fillWidth: true
                }

                TiMapView {
                    id: mapView
                    Layout.rowSpan: 3     // Haute comme 3 zones
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                // Affichage des infos supplémentaires (coords GPS, etc)
                ZoneGeoloc{
                    Layout.rightMargin: 40
                    Layout.fillHeight: true
                }
                ZoneSuggestion{
                    Layout.rightMargin: 40
                    Layout.fillHeight: true
                }
                Zone{
                    Layout.rightMargin: 40
                    Layout.fillHeight: true
                    color: TiStyle.trashcanBackgroundColor
                    iconZone: "qrc:/Images/trashcan.png"
                }
            }

            // ------------------ IPTC/EXIF TAGS TAB ----------------------------
            TiPhotoTags {
                id: datesTab
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
    TiBottomToolBar {
        id: bottomToolBar
        anchors.bottom: parent.bottom
        width: parent.width
    }


}



/*##^##
Designer {
    D{i:0;formeditorColor:"#ffffff";formeditorZoom:0.75}
}
##^##*/
