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

            // Un keyword déjà présent dans la photo courante ne doit pas apparaître en suggestion.
            visible: {
                // Si ce n'est pas un keyword => hide
                if (target !== "keywords")
                    return false
                // Si c'est un keyword => show only if not found
                if (tabbedPage.currentPhoto.keywords)
                    return (tabbedPage.currentPhoto.keywords.indexOf(
                                text) === -1)
                // Si aucun keyword => hide
                else
                    return false
            }


            /** ************************************************************************************************
             * Chips de suggestion.
             * *************************************************************************************************/
            Chips {
                id: currrentChip
                content: text
                editable: false
                deletable: false
                target: currrentItem.target
            }


            /** ************************************************************************************************
             * Gestion du clic sur le Chip: On affecte le texte de la suggestion à la target.
             * Rappel: -4 = applique la suggestion à toutes les photos sélectionnées
             *         -2 = applique la suggestion à la photo courante
             *         -3 = applique la suggestion à toutes les photos du cercle
             *      currentPhoto.row = applique la suggestion à la photo 'row'
             * *************************************************************************************************/
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // On affecte le texte de la suggestion à la target de la (ou des) photo(s).
                    // console.log("onglet:" + tabbedPage.currentIndex);
                    console.log("chipMouseArea:" + target + " for " + tabbedPage.currentPhoto.row)

                    // Cas particulier: si c'est le tag 'description': on efface le texte qui est en fait un hint.
                    if (target === "description") {
                        text = " "
                    }

                    // Si onglet CARTE : on applique la suggestion à toutes les photos sélectionnées
                    if (tabbedPage.currentIndex === 1) {
                        window.setPhotoProperty(-4, text, target)
                    }

                    // Si onglet TAG : on applique la suggestion aux photos sélectionnées (-4)
                    if (tabbedPage.currentIndex === 2)
                        window.setPhotoProperty(-4, text, target)

                    // On enlève le Chip de la zone Suggestions. (Attn: c'est l'index dans le proxyModel).
                    window.removePhotoFromSuggestion(index)
                }
            }
        }
    }
}
