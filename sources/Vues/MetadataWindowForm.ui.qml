

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: metadata
    width: 1024
    height: 768

    property alias button: button

    Button {
        id: button
        x: 396
        y: 690
        text: qsTr("Button")
    }

    Grid {
        id: exifTable
        x: 0
        y: 81
        width: 0
        height: 299
        rightPadding: 12
        leftPadding: 12
        topPadding: 5
        spacing: 1
        rows: 10
        columns: 4
    }
}
