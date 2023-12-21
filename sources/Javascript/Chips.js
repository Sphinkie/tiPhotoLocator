.pragma library

// -----------------------------------------------------------------------------------
// Fonctions liées aux boutons des Chips
// -----------------------------------------------------------------------------------

/*!
 * Active l'édition d'un chip
 */
function enableEdition(chip)
{
    // On désactive le bouton EDIT
    chip.editable = false;
    // On active les boutons SAVE et REVERT
    chip.canSave = true;
    // On gère la saisie d'un texte
    chip.chipText.readOnly = false;
    chip.chipText.focus = true;
}

/*!
 * Annule l'édition d'un chip
 */
function revertEdition(chip)
{
    chip.chipText.text = chip.content;
    resetChipButtons(chip);
}


/*!
 * Réactive le bouton Edit (en cas d'édition annulée par un REVERT).
 */
function resetChipButtons(chip)
{
    // On réactive le bouton EDIT
    chip.editable = true;
    // On désactive les boutons SAVE et REVERT
    chip.canSave = false;
    // Terminer la saisie du texte
    chip.chipText.readOnly = true;
    chip.chipText.focus = false;
}
