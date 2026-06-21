import QtQuick
import QtQuick.Controls.Material
import "../Models"
import ".."

/** **********************************************************************************************************
 * @brief QML: Liste verticale des fichiers GPX détectés.
 * Cette ListView est basée sur le Model ModelGpxList (ensemble des fichiers GX du sous-répertoire).
 * ***********************************************************************************************************/
Rectangle {
    implicitWidth: 320
    height: 384  // 8 items × 48px

    /// Heure de début du fichier GPX sélectionné (ex: "14:23:00"), vide si aucun.
    property string currentStartTime: {
        if (__lv.currentIndex < 0) return ""
        var item = __lv.model.get(__lv.currentIndex)
        return item ? item.startTime : ""
    }

    /** ******************************************************************************************************
  * La ListView
  * *******************************************************************************************************/
    ListView {
        id: __lv
        anchors.fill: parent
        orientation: Qt.Vertical
        clip: true
        model: ModelGpxList {}
        focus: true
        delegate: delegateGpx
        highlight: Rectangle { color: Style.chipGeoSuggestionColor; opacity: 0.6 }
        highlightFollowsCurrentItem: true
    }

    /** ******************************************************************************************************
     * Le delegate pour afficher chaque GPX file
     * *******************************************************************************************************/
    Component {
        id: delegateGpx
        Item {
            id: myItem
            required property string name
            required property string startTime
            required property int index
            width: __lv.width
            height: 48

            Column {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 8
                spacing: 2
                Text {
                    text: myItem.name
                    font.pixelSize: 13
                    color: myItem.index === __lv.currentIndex ? Style.chipGeoColor : Material.foreground
                }
                Text {
                    text: myItem.startTime
                    font.pixelSize: 11
                    opacity: 0.6
                    color: Material.foreground
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: __lv.currentIndex = myItem.index
            }
        }
    }
}
