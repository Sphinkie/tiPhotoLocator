import QtQuick
import QtQuick.Controls

/** **********************************************************************************************************
 * @brief Snackbar Material Design — notification non-bloquante qui s'affiche brièvement en bas de l'écran.
 * Utilisation : appeler show("message") depuis le parent.
 * Le parent: Overlay.overlay garantit que le snackbar est au-dessus de tout le contenu dans un ApplicationWindow.
 * ***********************************************************************************************************/
Rectangle {
    id: snackbar
    parent: Overlay.overlay
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 20
    anchors.left: parent.left
    anchors.leftMargin: 20
    width: snackbarText.implicitWidth + 32
    height: 48
    radius: 4
    color: "#323232"
    opacity: 0
    visible: opacity > 0
    z: 998

    Text {
        id: snackbarText
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: 13
    }

    Timer {
        id: snackbarTimer
        interval: 5000
        onTriggered: hideAnim.start()
    }

    NumberAnimation { id: showAnim; target: snackbar; property: "opacity"; to: 1; duration: 200 }
    NumberAnimation { id: hideAnim;  target: snackbar; property: "opacity"; to: 0; duration: 400 }

    function show(msg) {
        snackbarText.text = msg
        hideAnim.stop()
        showAnim.start()
        snackbarTimer.restart()
    }
}
