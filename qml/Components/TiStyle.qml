pragma Singleton
import QtQuick 2.15

/**
 * Définition du Singleton de Style, où l'on définit les couleurs de l'application.
 *
 * On essaye de suivre quelques principes...
 * - Les roles des couleurs dans le MaterialDesign (Surface, Primary, Secondary, Tertiary):
 *   @see https://m3.material.io/styles/color/the-color-system/color-roles
 *
 * - Les noms des couleurs (keywords) définis dans la norme SVG.
 *   Ces noms sont utilisables en Python et en QMl notamment.
 *   @see https://johndecember.com/html/spec/colorsvg.html
 *   @see https://www.w3.org/wiki/CSS3/Color/Extended_color_keywords
 *
 * - Choisir les couleurs de sa SystemPalette
 *   Le site suivant compare 9 différents outils de donstruction de palette
 *   @see https://www.webfx.com/blog/web-design/material-design-color-generators/
 *
 *   Le site le plus connu: MaterlaiPalette.com
 *
 */
Item{

    // Surface
    /*
     * Surface colors define contained areas, distinguishing them from a background and other on-screen elements.
     * Surface = couleur de fond
     * Surface container = couleur de fond des outils en haut et en bas
    */

    readonly property color surfaceBackgroundColor: "#f7f7f7"
    readonly property color surfaceCountainerColor: "#dcedc8"

    readonly property color primaryForegroundColor: "#8bc34a"       // green

    readonly property color secondaryForegroundColor: "#689f38"     // darkgreen
    readonly property color secondaryBackgroundColor: "lightblue"

    // Chips
    readonly property color tertiaryForegroundColor: "#448aff"
    readonly property color tertiaryBackgroundColor: "lightblue"
    readonly property color tertiaryTextColor: "slateblue"

    readonly property color buttonIdleColor: primaryForegroundColor
    readonly property color buttonHoveredColor: Qt.lighter(buttonIdleColor, 1.2)
    readonly property color buttonPressedColor: Qt.darker(buttonIdleColor, 1.3)

    readonly property color primaryTextColor:   "#212121"       // gris foncé
    readonly property color secondaryyyyTextColor: "#757575"       // gris moyen
    readonly property color dividerTextColor:   "#BDBDBD"       // gris très clair

    readonly property color accentTextColor: "firebrick"             // images toBeSaved

    readonly property color highlightBackgroundColor: "lightgrey"
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
    ...

  */
