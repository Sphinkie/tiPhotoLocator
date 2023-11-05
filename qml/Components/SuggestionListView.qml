import QtQuick


ListView{
    model: _suggestionProxyModel
    delegate: suggestionDelegate
    focus: true
    clip: true   // pour que les items restent à l'interieur de la listview


    // le delegate pour afficher un item dans la ListView
    Component{
        id: suggestionDelegate

        Item{
            id: currrentItem
            width: parent.width
            height: 40
            // Avec les required properties dans un delegate, on indique qu'il faut utiliser les roles du modèle
            required property string text
            required property string target

            Chips {
                content: text + " (" + target + ")"
                editable: false
                deletable: true
            }

            // Gestion du clic sur un item
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("chipMouseArea:" + target + " for " + tabbedPage.selectedData.row);
                    // On affecte le texte de la suggestion à la target
                    window.setPhotoProperty(tabbedPage.selectedData.row, text, target);
                }
            }

        }
    }
}
