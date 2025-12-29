import QtQuick


/** **********************************************************************************************************
 * @brief Un chip un peu plus gros, qui permet un texte multiligne, pour la description de l'image.
 * ***********************************************************************************************************/
Chips {
    editable: true
    deletable: true

    implicitHeight: 100
    implicitWidth: 400
    chipText.horizontalAlignment: Text.AlignJustify
    chipText.maximumLength: 180

    // content: "A character string giving the title of the image. It may be a comment such as '1988 company picnic' or the like. Two-bytes character codes cannot be used."
}
