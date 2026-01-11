pragma Singleton

import QtQuick
import QtQuick.Controls.Material


/** **********************************************************************************************************
 * @brief Définition du Singleton de Style, où l'on définit les couleurs de l'application.
 *
 * On essaye de suivre quelques principes...
 * - Les roles des couleurs dans le MaterialDesign (Surface, Primary, Secondary, Tertiary):
 *   @sa https://m3.material.io/styles/color/the-color-system/color-roles
 * Choisi sur coolors.co :
 *  lavender grey - indigo - ash brow - lawn green - deep saffron
 * Traduit par (équivalents Material pre-defined colors) :
 *  BlueGrey (100) - DeepPurple - Brown - Lime -  Orange
 * **********************************************************************************************************/
Item {

    readonly property color foregroundColor: Material.foreground // Material.DeepPurple
    readonly property color backgroundColor: Material.background // Material.BlueGrey,
    readonly property color accentColor: Material.accent // Material.Brown

    readonly property color secondaryColor: Material.LightBlue

    // ----------------------------------------------------------------------
    // Surfaces: couleurs de fond pour différents backgrounds
    // ----------------------------------------------------------------------

    // Surface container = couleur de fond des Toolbars (backgroundColor)
    readonly property color surfaceContainerColor: Material.color(
                                                       Material.BlueGrey,
                                                       Material.Shade50)

    // Zones standard : (backgroundColor)
    readonly property color zoneBackgroundColor: Material.color(
                                                     Material.BlueGrey,
                                                     Material.Shade100)

    // Zones de suggestions : bleu (secondaryColor)
    readonly property color suggestionBackgroundColor: Material.color(
                                                           Material.LightBlue,
                                                           Material.Shade50)

    // Chips: (backgroundColor)
    readonly property color chipBackgroundColor: Material.color(
                                                     Material.BlueGrey,
                                                     Material.Shade400)

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
    // gris clair     : Annotations dans les settings
    readonly property color tertiaryTextColor: Material.color(Material.Black,
                                                              Material.Shade200)
    // TODO : couleur à améliorer
    readonly property color accentTextColor: Material.accentColor // "firebrick" // filenames toBeSaved

    // La couleur de fond du filename(s) sélectionné dans la liste.
    readonly property color highlightBackgroundColor: Material.color(
                                                          Material.LightGreen,
                                                          Material.Shade200)
}
