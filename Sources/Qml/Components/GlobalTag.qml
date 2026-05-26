import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import ".."


/** **********************************************************************************************************
 * @brief Composant représentant une ligne complète dans la zone GlobalTags :
 *        un Chip (valeur du tag) + bouton "Apply to all" + bouton "Apply to selection" + description.
 * ***********************************************************************************************************/
RowLayout {
    id: root

    property string tagName: ""         ///< Préfixe affiché dans le Chip (ex: "artist:", "city:").
    property string content: ""         ///< Valeur courante du tag.
    property string tagDescription: ""  ///< Texte explicatif affiché à droite.
    property bool   applied: false      ///< Si true, "Apply to all" est désactivé (car déjà appliqué).
    property int    selectionCount: 1   ///< Nombre de photos sélectionnées (pour activer "Apply to selection").

    signal applyAll()           ///< Emis quand l'utilisateur clique sur "Apply to all".
    signal applyToSelection()   ///< Emis quand l'utilisateur clique sur "Apply to selection".

    Layout.fillWidth: true
    spacing: 16


    Chips {
        targetName: root.tagName
        content: root.content ? root.content : " "
    }

    RowLayout {
        spacing: 4
        Button {
            text: qsTr("Apply to all")
            enabled: !!root.content && !root.applied
            onClicked: root.applyAll()
        }
        Button {
            text: qsTr("Apply to selection")
            enabled: !!root.content && (root.selectionCount > 1) && !root.applied
            onClicked: root.applyToSelection()
        }
    }

    Label {
        Layout.fillWidth: true
        text: root.tagDescription
        wrapMode: Text.Wrap
    }
}
