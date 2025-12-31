pragma Singleton

import QtQuick
import QtQuick.Controls.Material


/** **********************************************************************************************************
 * @brief Définition du Singleton de Style, où l'on définit les couleurs de l'application.
 *
 * On essaye de suivre quelques principes...
 * - Les roles des couleurs dans le MaterialDesign (Surface, Primary, Secondary, Tertiary):
 *   @sa https://m3.material.io/styles/color/the-color-system/color-roles
 *
 * **********************************************************************************************************/
Item {

    readonly property color primaryColor: Material.primaryColor
    readonly property color secondaryColor: Material.Cyan

    // ----------------------------------------------------------------------
    // Surfaces: couleurs de fond pour différents backgrounds
    // ----------------------------------------------------------------------

    // Fond principal
    // "#f7f7f7" // gris très clair pour la surface de fond (non utilisé)
    // readonly property color surfaceBackgroundColor: Material.color(Material.LightGreen,Material.Shade200)

    // Surface container = couleur de fond des outils en haut et en bas
    // "#dcedc8" // vert très pale pour le container de fond
    readonly property color surfaceContainerColor: Material.color(
                                                       Material.LightGreen,
                                                       Material.Shade200)

    // Zones standard : vert (primary)
    readonly property color zoneBackgroundColor: Material.color(
                                                     Material.LightGreen,
                                                     Material.Shade400)

    // Zones de suggestions : bleu (secondary)
    readonly property color suggestionBackgroundColor: Material.color(
                                                           Material.Cyan,
                                                           Material.Shade200)

    // Chips : vert (primary)
    readonly property color chipBackgroundColor: Material.color(
                                                     Material.LightGreen,
                                                     Material.Shade700)
    readonly property color tinychipTextColor: "lightblue" // Textes des TinyChips
    readonly property color chipTextColor: "#ffe0b3" // Textes des Chips

    // ----------------------------------------------------------------------
    // Popups:
    // ----------------------------------------------------------------------
    readonly property color tertiaryForegroundColor: "#448aff" // bleu soutenu
    readonly property color tertiaryBackgroundColor: "lightblue"

    // ----------------------------------------------------------------------
    // Boutons:
    // ----------------------------------------------------------------------
    // Gestion par Controls.Material

    // ----------------------------------------------------------------------
    // Textes
    // ----------------------------------------------------------------------
    readonly property color primaryTextColor: "#212121" // gris foncé      : Listview + toolbar
    readonly property color secondaryTextColor: "#757575" // gris moyen    : Répertoire dans la toolbar
    readonly property color tertiaryTextColor: "#bdbdbd" // gris clair     : Annotations dans les settings
    // TODO : couleur à améliorer
    readonly property color accentTextColor: Material.accentColor // "firebrick" // filenames toBeSaved

    // Le(s) filename(s) sélectionné(s) dans la liste
    readonly property color highlightBackgroundColor: Material.color(
                                                          Material.LightGreen,
                                                          Material.Shade200)
}
