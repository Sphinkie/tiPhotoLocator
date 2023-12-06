import QtQuick

Repeater{
    model: _suggestionCategoryProxyModel
    delegate: suggestionDelegate
    focus: false
    clip: true   // pour que les items restent à l'interieur du Repeater


    // le delegate pour afficher un item dans le Flow
    Component{
        id: suggestionDelegate

        Item{
            id: currrentItem
            width:  currrentChip.width
            height:  currrentChip.height
            // Avec les required properties dans un delegate, on utilise les roles du modèle
            required property string text
            required property string target
            required property string category
            required property string index  // property particulière = indice de la suggestion

            Chips {
                id: currrentChip
                content: text + " (" + target + ")"
                editable: false
                deletable: false
            }

            // Gestion du clic sur un item (Chip suggestion)
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("chipMouseArea:" + target + " for " + tabbedPage.selectedData.row);
                    // On affecte le texte de la suggestion à la target
                    window.setPhotoProperty(tabbedPage.selectedData.row, text, target);
                    // On enlève le Chip de la zone Suggestions
                    window.removePhotoFrom(index);      // Attn : c'est l'index dans le proxyModel.
                    // On recharge les data pour forcer un refresh de la Zone
                    // tabbedPage.refreshSelectedData();
                }
            }
        }
    }
}
