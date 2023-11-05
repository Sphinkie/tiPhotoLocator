import QtQuick
import QtQuick.Layouts
import "../Components"

Zone{
    id: suggestionZone
    color: TiStyle.suggestionBackgroundColor
    iconZone: "qrc:/Images/suggestion.png"
    txtZone: qsTr("Suggestions basées sur la position GPS de la photo, grace au service gratuit et opensource OpenStreetMap.\nLimité à 100 requètes par jour.")
    Layout.fillHeight: true


    SuggestionListView {id : slv }

    /*

    ListView{
        id: suggestionListView2
        anchors.fill: parent
        model: _suggestionProxyModel
        delegate: suggestionDelegate2
        focus: true
        clip: true   // pour que les items restent à l'interieur de la listview
    }

    ColumnLayout {

        //ListView{
        //    id: suggestionListView
        //    anchors.fill: parent
        //    model: _suggestionProxyModel
        //    delegate: suggestionDelegate
        //    focus: true
        //    clip: true   // pour que les items restent à l'interieur de la listview

        // le delegate pour afficher un item dans la ListView
        Component{
            id: suggestionDelegate2

            //        Item {
            //            width: parent.width
            //            height: 40
            //            required property string text
            //            required property string target
            Item{
                property alias suggestionChip: suggestionChip
                property alias chipMouseArea: chipMouseArea
                Chips {
                    // Avec les required properties dans un delegate, on indique qu'il faut utiliser les roles du modèle
                    id: suggestionChip
                    required property string text
                    required property string target
                    content: text + " (" + target + ")"
                    editable: false
                    deletable: true
                    MouseArea {
                        id: chipMouseArea
                        anchors.fill: parent
                    }
                }
            }
        }
    }
    */


}


