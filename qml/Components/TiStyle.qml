import QtQuick 2.15

// @see http://www.w3.org/TR/SVG/types.html#ColorKeywords
Item{
    id: tiStyle
    property color primaryBackgroundColor: "#white"
    property color primaryForegroundColor: "#4E5BF2"
    property color buttonPressedColor: Qt.darker(primaryForegroundColor, 1.8)
    property color buttonHoveredColor: Qt.lighter(primaryForegroundColor, 1.2)
    property color buttonIdleColor: primaryForegroundColor
    property color primaryTextColor: "navy"
    property color secondaryTextColor: "firebrick"   // images toBeSaved
    property color highlightBackgroundColor: "black"

}
