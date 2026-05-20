import QtQuick
import QtQuick.Controls.Material


/** **********************************************************************************************************
 * @brief TextField standard pour le popup de Settings.
 * Modifier ce composant pour changer l'apparence de tous les champs de saisie des Settings.
 * ***********************************************************************************************************/
TextField {
    implicitHeight: 36 // Hauteur totale du champ (écrase la valeur Material par défaut ~56px)
    topPadding: 4 // Espace entre le bord supérieur du cadre et le texte saisi
    bottomPadding: 4 // Espace entre le bord inférieur du cadre et le texte saisi
}
