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
 * - Les noms des couleurs (keywords) définis dans la norme SVG.
 *   Ces noms sont utilisables en Python et en QMl notamment.
 *   @sa https://johndecember.com/html/spec/colorsvg.html
 *   @sa https://www.w3.org/wiki/CSS3/Color/Extended_color_keywords
 *
 * - Choisir les couleurs de sa SystemPalette
 *   Le site suivant compare 9 différents outils de construction de palette
 *   @sa https://www.webfx.com/blog/web-design/material-design-color-generators/
 *
 *   @see https://www.w3schools.com/colors/colors_picker.asp
 *
 *   Le site le plus connu: https://materialPalette.com
 *
 * **********************************************************************************************************/
Item {

    // Surface
    // Surface colors define contained areas, distinguishing them from a background and other on-screen elements.
    // Surface = couleur de fond
    // Surface container = couleur de fond des outils en haut et en bas
    readonly property color surfaceBackgroundColor: "#f7f7f7" // gris très clair pour la surface de fond
    readonly property color surfaceContainerColor: "#dcedc8" // vert très pale pour le container de fond

    readonly property color primaryColor: Material.LightGreen
    readonly property color secondaryColor: Material.Cyan

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

    // Popups:
    readonly property color tertiaryForegroundColor: "#448aff" // bleu soutenu
    readonly property color tertiaryBackgroundColor: "lightblue"

    // Boutons:
    // Gestion par Controls.Material

    // Textes
    readonly property color primaryTextColor: "#212121" // gris foncé      : Listview + toolbar
    readonly property color secondaryTextColor: "#757575" // gris moyen    : Répertoire dans la toolbar
    readonly property color tertiaryTextColor: "#bdbdbd" // gris clair     : Annotations dans les settings
    //TODO : améliorer les couleurs suivantes:
    readonly property color accentTextColor: "firebrick" // filenames toBeSaved
    readonly property color highlightBackgroundColor: "lightgrey" // filename sélectionné
}
