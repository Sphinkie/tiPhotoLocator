pragma Singleton
import QtQuick

/*!
 * Définition du Singleton de Style, où l'on définit les couleurs de l'application.
 *
 * On essaye de suivre quelques principes...
 * - Les roles des couleurs dans le MaterialDesign (Surface, Primary, Secondary, Tertiary):
 *   \sa https://m3.material.io/styles/color/the-color-system/color-roles
 *
 * - Les noms des couleurs (keywords) définis dans la norme SVG.
 *   Ces noms sont utilisables en Python et en QMl notamment.
 *   \sa https://johndecember.com/html/spec/colorsvg.html
 *   \sa https://www.w3.org/wiki/CSS3/Color/Extended_color_keywords
 *
 * - Choisir les couleurs de sa SystemPalette
 *   Le site suivant compare 9 différents outils de donstruction de palette
 *   \sa https://www.webfx.com/blog/web-design/material-design-color-generators/
 *
 *   \see https://www.w3schools.com/colors/colors_picker.asp
 *
 *   Le site le plus connu: https://materialPalette.com
 *
 */
Item{

    // Surface
    // Surface colors define contained areas, distinguishing them from a background and other on-screen elements.
    // Surface = couleur de fond
    // Surface container = couleur de fond des outils en haut et en bas
    readonly property color surfaceBackgroundColor: "#f7f7f7"       // gris très clair pour la surface de fond
    readonly property color surfaceContainerColor: "#dcedc8"        // vert très pale pour le container de fond

    readonly property color primaryColor: "#8bc34a"                 // vert pour les boutons et les zones standard

    // Primary: Zones
    readonly property color zoneBackgroundColor: primaryColor       // vert pour les zones standard (darker=#6ca64f)
    readonly property color trashcanBackgroundColor: "lightgrey"    // #d3d3d3 gris pour les zones corbeille  (darker=#c2c6c9)
    readonly property color suggestionBackgroundColor: "lightblue"  // #add8e6 bleu pour les zones de suggestions (darker=#70b1c9)

    // Chips
    readonly property color chipBackgroundColor: "#689f38"          // darkgreen : fond des Chips et TinyChips
    readonly property color tinychipTextColor: "lightblue"          // Textes des TinyChips
    readonly property color chipTextColor:       "#ffe0b3"          // Textes des Chips

    // Popups
    readonly property color tertiaryForegroundColor: "#448aff"      // bleu soutenu
    readonly property color tertiaryBackgroundColor: "lightblue"

    // Boutons
    readonly property color buttonIdleColor: primaryColor
    readonly property color buttonHoveredColor: Qt.lighter(buttonIdleColor, 1.2)
    readonly property color buttonPressedColor: Qt.darker(buttonIdleColor, 1.3)

    // Textes
    readonly property color primaryTextColor:   "#212121"          // gris foncé      : Listview + toolbar
    readonly property color secondaryTextColor: "#757575"          // gris moyen      : Répertoire dans la toolbar
    readonly property color tertiaryTextColor:  "#bdbdbd"          // gris clair      : Annotations dans les settings
    //TODO : améliorer les couleurs suivantes:
    readonly property color accentTextColor: "firebrick"           // filenames toBeSaved
    readonly property color highlightBackgroundColor: "lightgrey"  // filename sélectionné
}


/*
 * Comment déclarer un style en QML:
 *
 Méthode 1:
  Ajouter un fichier 'qmldir' dans le même répertoire, contenant la ligne:
    singleton TiStyle 1.0 TiStyle.qml
  Et déclarer ce fichier dans les ressources
 *
 Méthode 2:
  @see @see http://imaginativethinking.ca/make-qml-component-singleton/
  Appeler (dans le main.cpp, par ex):
    #include <QtQml>
    ...
    qmlRegisterSingletonType( QUrl("file:///Components/TiStyle.qml"), "ca.imaginativethinking.tutorial.style", 1, 0, "TiStyle" );


  */
