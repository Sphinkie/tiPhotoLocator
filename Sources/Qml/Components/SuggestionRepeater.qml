import QtQuick


/** **********************************************************************************************************
 * @brief QML. Ce Repeater contient les suggestions fournies par le modèle SuggestionCategoryProxyModel.
 * Le Repeater doit être encapsulé dans un positionneur de type Flow, ColumnLayout ou Column.
 * Ce modele est basé sur SuggestionModel et est filtré selon la Category.
 * Le ProxyModel doit être configuré pour filtrer soit les suggestions "geo", soit les suggestions "tag".
 * ***********************************************************************************************************/
Repeater {
    model: _suggestionCategoryProxyModel
    delegate: suggestionDelegate
    focus: false
    clip: true // pour que les items restent à l'interieur du Repeater


    /** ******************************************************************************************************
     * Le delegate pour afficher chaque item du Flow. Chaque item est composé d'un Chips cliquable
     * (cad avec MouseArea).
     * *******************************************************************************************************/
    Component {
        id: suggestionDelegate

        Item {
            id: currrentItem
            width: currrentChip.width
            height: currrentChip.height
            // Avec les required properties dans un delegate, on utilise les roles du modèle
            required property string text
            required property string target
            required property string category
            // index = property particulière = indice de la suggestion courante
            required property string index


            /** ************************************************************************************************
             * Chips de suggestion.
             * *************************************************************************************************/
            Chips {
                id: currrentChip
                content: text
                editable: false
                deletable: false
                targetName: target + ":"
            }


            /** ************************************************************************************************
             * Gestion du clic sur le Chip.
             * *************************************************************************************************/
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // On affecte le texte de la suggestion à la target
                    // console.log("onglet:" + tabbedPage.currentIndex);
                    console.log("chipMouseArea:" + target + " for " + tabbedPage.currentPhoto.row)

                    // Si onglet CARTE : on applique la suggestion à toutes les photos sélectionnées (-4)
                    if (tabbedPage.currentIndex === 1) {
                        window.setPhotoProperty(-4, text, target)
                        // window.setPhotoProperty(-2, text, target)// -2: photo courante
                        // window.setPhotoProperty(-3, text,target) // -3: photos du cercle
                    }

                    // Si onglet TAG : on applique la suggestion aux photos sélectionnées (-4)
                    if (tabbedPage.currentIndex === 2)
                        window.setPhotoProperty(-4, text, target)
                    // window.setPhotoProperty(tabbedPage.currentPhoto.row, text, target)

                    // On enlève le Chip de la zone Suggestions. (Attn: c'est l'index dans le proxyModel).
                    window.removePhotoFromSuggestion(index)
                }
            }
        }
    }
}
