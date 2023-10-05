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
/*
    background: Rectangle {
        implicitWidth: 83
        implicitHeight: 37
        color: { tiStyle.buttonIdleColor
          parent.hovered ?  tiStyle.buttonHoveredColor:
                           parent.down ? tiStyle.buttonPressedColor: // TODO: ne marche pas bien
                                          tiStyle.buttonIdleColor;
        }
        radius: 3
    }*/
}
