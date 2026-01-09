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

    /// Nom du dossier de photos
    folderPath.text: Utilities.toStandardPath(folderListModel.folder)
}
