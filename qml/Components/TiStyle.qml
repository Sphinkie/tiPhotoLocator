pragma Singleton
import QtQuick 2.15

// @see http://www.w3.org/TR/SVG/types.html#ColorKeywords
// @see http://imaginativethinking.ca/make-qml-component-singleton/

Item{
    readonly property color primaryForegroundColor: "green"
    readonly property color primaryBackgroundColor: "#f7f7f7"

    readonly property color secondaryForegroundColor: "slateblue"
    readonly property color secondaryBackgroundColor: "lightblue"


    readonly property color buttonIdleColor: primaryForegroundColor
    readonly property color buttonHoveredColor: Qt.lighter(buttonIdleColor, 1.2)
    readonly property color buttonPressedColor: Qt.darker(buttonIdleColor, 1.3)

    readonly property color primaryTextColor: "navy"
    readonly property color secondaryTextColor: "firebrick"             // images toBeSaved
    readonly property color highlightBackgroundColor: "lightgrey"
}


/*

  Soit ajouter un fichier qmldir dans le même répertoire, contenant la ligne:
  singleton TiStyle 1.0 TiStyle.qml
  Et déclarer ce fichier dans les ressources

  Soit appeler (dans le main.cpp, par ex):

    #include <QtQml>
    ...
    qmlRegisterSingletonType( QUrl("file:///Components/TiStyle.qml"), "ca.imaginativethinking.tutorial.style", 1, 0, "TiStyle" );
    ...

  */
