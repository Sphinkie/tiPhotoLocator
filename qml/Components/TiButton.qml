import QtQuick 2.15
import QtQuick.Controls 2.5

/*
Pressed:  event is generated when you push down the mouse button
Released: event is generated when you release the mouse button (which has been pressed down before)
Clicked:  event is generated when a mouse button Pressed & Released.

* @see https://doc.qt.io/qt-5/qtquickcontrols2-customize.html#customizing-button
*/
Button {
    display: AbstractButton.TextBesideIcon   // IconOnly
    //icon.width: 45
    //icon.height: 45
    property bool buttonOn: true   // Certains boutons ont 2 positions ON et OFF


    background: Rectangle {
        implicitWidth: 86
        implicitHeight: 40
        color: {
            parent.pressed ? TiStyle.buttonPressedColor : (parent.hovered ? TiStyle.buttonHoveredColor : TiStyle.buttonIdleColor);
            // getButtonColor(parent)
        }
        radius: 6
    }

    // unused
    function getButtonColor(bouton) {
        if (bouton.down) return TiStyle.buttonPressedColor
        else if (bouton.hovered) return TiStyle.buttonHoveredColor
        else return TiStyle.buttonIdleColor;
    }
}
