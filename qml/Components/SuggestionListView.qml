import QtQuick


ListView{
    id: suggestionListView
    anchors.fill: parent
    model: _suggestionProxyModel
    delegate: suggestionDelegate
    focus: true
    clip: true   // pour que les items restent à l'interieur de la listview



    // le delegate pour afficher un item dans la ListView
    Component{
        id: suggestionDelegate

        Item{
            //            width: parent.width
            //            height: 40
                        required property string text
                       required property string target

            Chips {
                // Avec les required properties dans un delegate, on indique qu'il faut utiliser les roles du modèle
                id: suggestionChip
            //    required property string text
              //  required property string target
                content: text + " (" + target + ")"
                editable: false
                deletable: true
            }
            MouseArea {
                anchors.fill: parent
                // Gestion du clic sur un item
                onClicked: {
                    console.log("chipMouseArea:" + target);
                    // __lv.currentIndex = index             // Bouge le highlight dans la ListView

                    // On affecte le texte de la suggestion à la target
                    // window.setSelectedItemCoords(text, target);

                }
            }
        }
    }
}
