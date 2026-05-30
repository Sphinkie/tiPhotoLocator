import QtQuick
import ".."


/** **********************************************************************************************************
 * @brief Rectangle animé représentant un Chip en vol vers sa zone de destination.
 * Créé dynamiquement dans ghostLayer lors du clic sur un chip de suggestion, détruit en fin d'animation.
 *
 * Usage:
 *   ghostChipComponent.createObject(ghostLayer, {
 *       x: sourcePos.x, y: sourcePos.y,
 *       width: chipWidth, height: chipHeight,
 *       chipText: "Paris", destX: cx, destY: cy,
 *       onDone: function() { ... }
 *   })
 * ***********************************************************************************************************/
Rectangle {
    id: ghostRect

    /// Texte affiché dans le chip fantôme (valeur de la suggestion).
    property string chipText: ""
    /// Coordonnées du centre de la zone de destination (en coords ghostLayer).
    property real destX: 0
    property real destY: 0
    /// Callback appelé à la fin de l'animation, avant destruction.
    property var onDone: null
    /// Durée de l'animation en millisecondes.
    property int duree: 450

    radius: 16
    color: Style.chipBackgroundColor
    opacity: 0.9

    /// Le texte du GhostChip est reçu à sa création.
    Text {
        anchors.centerIn: parent
        text: ghostRect.chipText
        font.pixelSize: 14
        color: "black"
        clip: true
    }


    /** ************************************************************************************
     * Animation du GhostChip : déplacement vers la destination + fondu + réduction.
     * @see https://easings.net/
     * *************************************************************************************/
    ParallelAnimation {
        id: flyAnim

        /// Déplacement horizontal vers le centre de la zone destination.
        NumberAnimation {
            target: ghostRect
            property: "x"
            to: ghostRect.destX - ghostRect.width / 2
            duration: duree
            easing.type: Easing.InOutCubic
        }
        /// Déplacement verical vers le centre de la zone destination.
        NumberAnimation {
            target: ghostRect
            property: "y"
            to: ghostRect.destY - ghostRect.height / 2
            duration: duree
            easing.type: Easing.OutBack
        }
        /// Devient semi-transparent pendant le vol.
        NumberAnimation {
            target: ghostRect
            property: "opacity"
            to: 0.5
            duration: duree
        }
        /// Diminue de taille pendant le vol.
        NumberAnimation {
            target: ghostRect
            property: "scale"
            to: 0.75
            duration: duree
        }

        /// À la fin : déclenche le callback, puis détruit le ghost.
        onFinished: {
            if (ghostRect.onDone)
                ghostRect.onDone()
            ghostRect.destroy()
        }
    }

    /// L'animation démarre automatiquement dès que le composant est créé.
    Component.onCompleted: flyAnim.start()
}
