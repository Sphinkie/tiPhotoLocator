import QtQuick
import ".."


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
    clip: true

    //! Si true, n'affiche que les suggestions de type "keywords" (panneau droit).
    property bool onlyKeywords: false

    //! Fonction reçue du parent : renvoie le centre (en coords ghostLayer) de la zone destination pour un target donné.
    property var getCenterForTarget: null


    /** ******************************************************************************************************
     * Ghost chip : rectangle animé qui vole de la zone suggestion vers la zone destination.
     * Créé dynamiquement dans ghostLayer lors du clic, détruit en fin d'animation.
     * @see GhostChip.qml
     * *******************************************************************************************************/
    Component {
        id: ghostChipComponent
        GhostChip {}
    }


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
                if (onlyKeywords) {
                    // Panneau droit : keywords seulement, et non encore assignés
                    if (target !== "keywords")
                        return false
                    if (tabbedPage.currentPhoto.keywords)
                        return tabbedPage.currentPhoto.keywords.indexOf(
                                    text) === -1
                    return true
                }
                // Panneau gauche : tout sauf les keywords (qui vont dans le panneau droit)
                return target !== "keywords"
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
             * Gestion du clic sur le Chip: animation de vol vers la zone destination, puis affectation.
             * Rappel: -4 = applique la suggestion à toutes les photos sélectionnées
             *         -2 = applique la suggestion à la photo courante
             *         -3 = applique la suggestion à toutes les photos du cercle
             *      currentPhoto.row = applique la suggestion à la photo 'row'
             * *************************************************************************************************/
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Capture des valeurs avant toute opération asynchrone
                    var capturedText = (target === "description") ? " " : text
                    var capturedTarget = target
                    var capturedIndex = index

                    // Position du chip source dans le référentiel de ghostLayer
                    var sourcePos = currrentChip.mapToItem(ghostLayer, 0, 0)

                    // Centre de la zone destination (fallback: 150px vers le haut si pas de fonction fournie)
                    var destCenter = getCenterForTarget ? getCenterForTarget(
                                                              capturedTarget) : Qt.point(
                                                              sourcePos.x + currrentChip.width / 2,
                                                              sourcePos.y - 150)

                    // Création du ghost chip animé dans ghostLayer
                    ghostChipComponent.createObject(ghostLayer, {
                                                        "x": sourcePos.x,
                                                        "y": sourcePos.y,
                                                        "width": currrentChip.width,
                                                        "height": currrentChip.height,
                                                        "chipText": capturedText,
                                                        "destX": destCenter.x,
                                                        "destY": destCenter.y,
                                                        "onDone": function () {
                                                            window.setPhotoProperty(
                                                                        -4,
                                                                        capturedText,
                                                                        capturedTarget)
                                                            window.removePhotoFromSuggestion(
                                                                        capturedIndex)
                                                        }
                                                    })
                }
            }
        }
    }
}
