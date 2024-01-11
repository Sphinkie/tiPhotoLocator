import QtQuick
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities


/*! *****************************************************************
 *  Toolbar principale: boutons du haut: Reload - Rescan - Dossier
 * ***************************************************************** */
ToolBarPrincipaleForm {

        bt_reload.onClicked: {
            console.log("Manual Reload");
            _photoModel.clear();
            // On ajoute une à une les photos du dossier dans le modèle
            for (var i = 0; i < folderListModel.count; i++)  {
                window.append(folderListModel.get(i,"fileName"), folderListModel.get(i,"fileUrl").toString() )
            }
        }
    
        bt_rescan.onClicked: {
            rescanWarning.open()
		}
 
        folderPath.text: Utilities.toStandardPath(folderListModel.folder)
}
