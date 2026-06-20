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
 *  lavender grey - indigo - amber - lawn green - deep saffron
 * Traduit par (équivalents Material pre-defined colors):
 *  @sa https://doc.qt.io/qt-6/qtquickcontrols-material.html
 *  BlueGrey (100) - DeepPurple - Amber - Lime - Orange
 * **********************************************************************************************************/
Item {

    // ----------------------------------------------------------------------
    // Définition du thème (voir Main.qml)
    // ----------------------------------------------------------------------
    /// Couleur du fond: Barre de menu. Barre des onglets
    property var background: Material.color(Material.BlueGrey, Material.Shade200) // Material.background
    /// Couleur d'accentuation pour les items et textes en highlight.
    property var accent: Material.color(Material.Amber, Material.Shade700) // Material.accent
    /// Couleur des textes.
    property int foreground: Material.DeepPurple // Material.foreground
    /// Couleur primaire = non utilisé sur Desktop ?
    property int primary: Material.BlueGrey
    /// Thème clair ou foncé.
    property int theme: Material.Light

    // ----------------------------------------------------------------------
    // Couleurs du Style
    // ----------------------------------------------------------------------
    readonly property color primaryColor: Material.color(primary)
    readonly property color accentColor: Material.color(accent)
    readonly property color backgroundColor: Material.color(background)
    readonly property color foregroundColor: Material.color(foreground)
    readonly property color secondaryColor: Material.LightBlue

    // ----------------------------------------------------------------------
    // Surfaces: couleurs de fond pour différents backgrounds
    // ----------------------------------------------------------------------

    // Surface container = couleur de fond des Toolbars (backgroundColor)
    readonly property color surfaceContainerColor: Material.color(Material.BlueGrey, Material.Shade50)

    // Zones standard : (backgroundColor)
    readonly property color zoneBackgroundColor: Material.color(Material.BlueGrey, Material.Shade100)

    // Zones de suggestions : bleu (secondaryColor)
    readonly property color suggestionBackgroundColor: Material.color(Material.LightBlue, Material.Shade50)

    // Chips: couleur par défaut (aucune catégorie)
    readonly property color chipBackgroundColor: Material.color(Material.BlueGrey, Material.Shade400)

    // Chips par catégorie — valeurs appliquées (Shade400/500)
    readonly property color chipGeoColor: Material.color(Material.Teal, Material.Shade400)
    readonly property color chipPhotoColor: Material.color(Material.DeepPurple, Material.Shade400)
    readonly property color chipCameraColor: Material.color(Material.BlueGrey, Material.Shade500)
    readonly property color chipKeywordColor: Material.color(Material.Indigo, Material.Shade400)
    // Chips suggestions — version pastel (Shade200/300, texte foncé)
    readonly property color chipGeoSuggestionColor: Material.color(Material.Teal, Material.Shade300)
    readonly property color chipPhotoSuggestionColor: Material.color(Material.DeepPurple, Material.Shade300)
    readonly property color chipCameraSuggestionColor: Material.color(Material.BlueGrey, Material.Shade300)
    readonly property color chipKeywordSuggestionColor: Material.color(Material.Indigo, Material.Shade300)
    // Chip modifié non encore sauvegardé
    readonly property color chipDirtyColor: Material.color(Material.DeepOrange, Material.Shade400)

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
    readonly property color tertiaryTextColor: Material.color(Material.Black, Material.Shade200)
    /// filenames toBeSaved
    readonly property color accentTextColor: Material.color(Material.DeepOrange, Material.Shade800)
    /// Selected Tab text
    readonly property color accentTabTextColor: Material.color(Material.DeepOrange, Material.Shade700)

    /// La couleur de fond du filename(s) sélectionné dans la liste.
    readonly property color highlightBackgroundColor: Material.color(Material.DeepPurple, Material.Shade100)
}
