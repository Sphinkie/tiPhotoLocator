import QtQuick


/** **********************************************************************************************************
 * @brief Un chip un peu plus gros, qui permet un texte multiligne, pour la \b description de l'image.
 * content: "A character string giving the title of the image. It may be a comment such as '1988 company picnic' or the like. Two-bytes character codes cannot be used."
 * ***********************************************************************************************************/
Chips {
    /// Le fatChip est éditable.
    editable: true
    /// Le fatChip peut être supprimé.
    deletable: true

    implicitHeight: 100 ///< Hauteur préférée si height n'est pas spécifiée.
    implicitWidth: 400 ///< Largeur préférée si width n'est pas spécifiée.

    /// Alignement du texte à l'interoeur de l'Item
    chipText.horizontalAlignment: Text.AlignJustify
    /// La taille max du texte pouvant être saisi.
    chipText.maximumLength: 180
}
