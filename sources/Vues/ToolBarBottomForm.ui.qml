import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtCore
import "../Components"

Rectangle {
    id: bottomRect
    color: TiStyle.surfaceContainerColor
    height: bottomToolBarLayout.height + 20

    property alias bt_dump1: bt_dump1
    property alias bt_dump2: bt_dump2
    property alias cb_backups: cb_backups
    property alias bt_save: bt_save
    property alias bt_quit: bt_quit
    property bool useDebug
    property bool shouldSave

    // property alias reglages2: reglages2
    RowLayout {
        id: bottomToolBarLayout
        Layout.alignment: Qt.AlignRight // on cale les boutons à droite
        spacing: 20

        TiButton {
            id: bt_dump1
            text: qsTr("Dump PhotoModel")
            visible: bottomRect.useDebug
            ToolTip.text: qsTr("DEBUG: Affiche une ligne du modèle dans la console")
            ToolTip.visible: hovered
            ToolTip.delay: 500
            Layout.leftMargin: 20
            Layout.topMargin: 10
        }
        TiButton {
            id: bt_dump2
            text: qsTr("Dump SuggModel")
            visible: bottomRect.useDebug
            ToolTip.text: qsTr("DEBUG: Affiche une ligne du modèle dans la console")
            ToolTip.visible: hovered
            ToolTip.delay: 500
            Layout.leftMargin: 20
            Layout.topMargin: 10
        }
        CheckBox {
            id: cb_backups
            text: qsTr("Générer backups")
            Layout.topMargin: 10
            ToolTip {
                text: qsTr("Cocher pour faire une sauvegarde des photos originales (IMAGENAME.jpg_original)")
                delay: 500
                visible: parent.hovered
            }
        }
        TiButton {
            id: bt_save
            text: qsTr("Enregistrer")
            Layout.topMargin: 10
            color: shouldSave ? TiStyle.buttonAccentColor : TiStyle.buttonIdleColor
            ToolTip.text: qsTr("Enregistre les tags EXIF des photos modifiées")
            ToolTip.visible: hovered
            ToolTip.delay: 500
        }
        TiButton {
            id: bt_quit
            text: qsTr("Quitter")
            ToolTip.text: qsTr("Quitte l'application")
            ToolTip.visible: hovered
            ToolTip.delay: 500
            Layout.rightMargin: 20
            Layout.topMargin: 10
        }
    }

    // ----------------------------------------------------------------
    // Dès qu'un item change, on active le bouton
    // ----------------------------------------------------------------
    Connections{
      target: _photoModel
      function onDataChanged(topLeft, bottomRight, roles)
      {
          // console.log("dataChanged", roles.length, " roles: ", roles);
          roles.forEach(function(role){
            // console.log(_photoModel.getRoleName(role));
            if (_photoModel.getRoleName(role) === "toBeSaved") shouldSave = true;
          });
      }
      function onDataCleared()
      {
          console.log("onDataCleared");
          shouldSave = false;
      }

    }

    // ----------------------------------------------------------------
    // On mémorise la ckeckbox dans les Settings
    // ----------------------------------------------------------------
    Settings {
        id: settings
        property alias backupsEnabled: cb_backups.checked
        property alias debugModeEnabled: bottomRect.useDebug
    }
}
