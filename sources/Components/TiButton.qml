import QtQuick
import QtQuick.Controls


/** **********************************************************************************************************
 * @brief Bouton customisé paour TiPhoto
 * Pressed:  event is generated when you push down the mouse button
 * Released: event is generated when you release the mouse button (which has been pressed down before)
 * Clicked:  event is generated when a mouse button Pressed & Released.
 *
 * @see https://doc.qt.io/qt-5/qtquickcontrols2-customize.html#customizing-button
 * ***********************************************************************************************************/
Button {
    display: AbstractButton.TextBesideIcon // IconOnly
    property color color: TiStyle.buttonIdleColor

    background: Rectangle {
        implicitWidth: 86
        implicitHeight: 40
        color: {
            // parent.pressed ? TiStyle.buttonPressedColor : (parent.hovered ? TiStyle.buttonHoveredColor : TiStyle.buttonIdleColor);
            parent.pressed ? Qt.darker(
                                 parent.color,
                                 1.3) : (parent.hovered ? Qt.lighter(
                                                              parent.color,
                                                              1.2) : parent.color)
        }
        radius: 6
    }
}
