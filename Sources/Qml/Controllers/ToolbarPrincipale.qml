import QtQuick
import QtQuick.Controls.Material

import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities


/** **********************************************************************************************************
 * @brief QML: Controleur de la Toolbar principale: boutons du haut: Rescan et Folder Name
 * *********************************************************************************************************** */
ToolbarPrincipaleForm {

    /// Le bouton RESCAN vide le modèle et recharge le dossier de photos (après acceptation du popup).
    bt_rescan.onClicked: {
        rescanWarning.open()
    }

    /// Le bouton OPEN IN EXPLORER ouvre un Explorer Windows dans le dossier actif.
    bt_explorer.onClicked: {
        Qt.openUrlExternally(folderListModel.folder)
    }

    bt_rescan.visible: (folderListModel.count > 0)
    bt_explorer.visible: (folderListModel.count > 0)

    /// Nom du dossier de photos
    folderPath.text: Utilities.toStandardPath(folderListModel.folder)
    folderPath.visible: (folderListModel.count > 0)
}
