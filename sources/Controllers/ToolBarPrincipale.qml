import QtQuick
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities

ToolBarPrincipaleForm {


        bt_reload.onClicked: {
            console.log("Manual Reload");
            _photoListModel.clear();
            // On ajoute une à une les photos du dossier dans le modèle
            for (var i = 0; i < folderListModel.count; i++)  {
                window.append(folderListModel.get(i,"fileName"), folderListModel.get(i,"fileUrl").toString() )
            }
        }
    

        bt_rescan.onClicked: {
            rescanWarning.open()
		}
 
        folderPath.text: Utilities.toStandardPath(folderDialog.folder)
}
