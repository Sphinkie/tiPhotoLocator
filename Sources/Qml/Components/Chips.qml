import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Material
import ".."

/** **********************************************************************************************************
 * @brief Ce composant reproduit un MaterialDesign::Chip en se basant sur un Qt Rectangle.
 * A noter que l'ombre doit être définie avant le rectangle, de façon à être dessinée avant, donc dessous.
 * A noter que le Rectangle contient un texte, mais ne s'adapte pas automatiquement à la longueur du texte.
 * C'est plutot le texte qui s'adapte au rectangle parent.
 * @see {https://doc.qt.io/qt-5/qml-qtquick-controls2-label.html}
 * @note sur les properties
 * - target : nom technique du champ EXIF/IPTC tel qu'il est passé à ExifTool ("city", "latitude", "keywords"…). Sert aussi à router la valeur vers le bon champ dans PhotoModel.
 * - targetName : label purement visuel affiché dans le chip ("brand:", "content description:", "artist:"…). Calculé automatiquement depuis target,  ou surchargé si le nom ExifTool n'est pas userfriendly (ex : target="make" → targetName="brand:").
 * - chipCategory : notion UI uniquement, sans lien avec ExifTool. Regroupe des targets de même domaine pour leur attribuer une couleur ("geo" = tout ce qui localise, "camera" = tout ce  que le boîtier génère, "photo" = IPTC éditables, "keyword" = mots-clés). Nécessaire pour les chips qui n'ont pas de target (ils utilisent targetName directement).
 * ***********************************************************************************************************/
Item {
    id: chipRoot
    property bool canSave: false ///< type:bool Fait apparaitre le mini-bouton Save.
    property bool editable: false ///< type:bool Fait apparaitre le mini-bouton Edit.
    property bool deletable: false ///< type:bool Fait apparaitre le mini-bouton Delete.
    /// type:string le texte du Chips
    property string content
    /// type:signal Emis après l'animation de suppression, pour déclencher la suppression réelle.
    signal deleteClicked
    /// type:string Le nom technique du tag (ex: "city", "location"). Dérive targetName automatiquement.
    property string target: ""
    /// type:string Le label affiché dans le Chips. Calculé depuis target, ou surchargeable directement.
    property string targetName: target !== "" ? target + ":" : ""
    // property string targetName
    property alias editArea: editArea ///< type:MouseArea Zone cliquable du mini-bouton Edit.
    property alias saveArea: saveArea ///< type:MouseArea Zone cliquable du mini-bouton Save.
    property alias revertArea: revertArea ///< type:MouseArea Zone cliquable du mini-bouton Revert.
    property alias deleteArea: deleteArea ///< type:MouseArea Zone cliquable du mini-bouton Delete.
    property alias swapArea: swapArea ///< type:MouseArea Zone cliquable du mini-bouton Swap (city↔location).
    property bool swappable: false ///< type:bool Active le bouton swap (city↔location). A positionner à true uniquement sur chipCity et chipLocation.
    /// Pour le controle inviduel des items
    property alias chipText: chipText
    property bool hideTargetWhenFilled: false ///< type:bool Si true, le targetName disparait dès que content est renseigné (pour FatChip).
    /// Catégorie explicite du chip : "geo", "photo", "camera", "keyword". Vide = auto-détection depuis target.
    property string chipCategory: ""
    /// Si true, utilise la couleur pastel (Shade200) — pour les chips de suggestion (valeur proposée, non encore appliquée).
    property bool isSuggestion: false

    /// Couleur de fond calculée selon la catégorie (ou target si chipCategory est vide).
    readonly property color chipColor: {
        var cat = chipCategory !== "" ? chipCategory : target;
        if (cat === "")
            return Style.chipBackgroundColor;
        switch (cat) {
        case "geo":
        case "latitude":
        case "longitude":
        case "country":
        case "city":
        case "location":
            return isSuggestion ? Style.chipGeoSuggestionColor : Style.chipGeoColor;
        case "keyword":
        case "keywords":
            return isSuggestion ? Style.chipKeywordSuggestionColor : Style.chipKeywordColor;
        case "camera":
        case "make":
        case "model":
        case "software":
        case "aperture":
        case "speed":
        case "metadata":
            return isSuggestion ? Style.chipCameraSuggestionColor : Style.chipCameraColor;
        default:
            return isSuggestion ? Style.chipPhotoSuggestionColor : Style.chipPhotoColor;
        }
    }

    /// true si le chip a une couleur de catégorie, false si fond gris neutre.
    readonly property bool _isColored: chipCategory !== "" || target !== ""

    readonly property color _chipLabelColor: {
        if (canSave)
            return Qt.rgba(1, 1, 1, 0.7); // blanc semi-transparent à 70%
        if (isSuggestion)
            return Qt.rgba(0, 0, 0, 0.55); // noir semi-transparent
        return _isColored ? Qt.rgba(1, 1, 1, 0.7) : Qt.rgba(0, 0, 0, 0.55);
    }
    readonly property color _chipValueColor: {
        if (canSave)
            return "white";
        if (isSuggestion)
            return Style.primaryTextColor;
        return _isColored ? "white" : Style.primaryTextColor;
    }
    // Les différents Chips doivent être dans un ColumLayout. On peut ainsi les aligner tous de la même façon.
    // visible sur le root (et non sur chipRectangle) pour que le ColumnLayout n'alloue pas d'espace aux chips vides.
    visible: !!content
    Layout.topMargin: 10 ///< marge haut (outside the item)
    Layout.leftMargin: 20 ///< marge gauche (outside the item)
    implicitHeight: 32 ///< Hauteur préférée si height n'est pas spécifiée.
    implicitWidth: 280 ///< Largeur préférée si width n'est pas spécifiée.

    /** ************************************************************************************
     * Ombre sous le Chip. (Avec Material, on pourrait utiliser 'elevation').
     * *************************************************************************************/
    RectangularShadow {
        id: chipShadow
        anchors.fill: chipRectangle
        offset.x: 10
        offset.y: 10
        radius: 8
        blur: 20
        spread: 0
        color: Qt.darker(chipRectangle.color, 1.6)
        visible: chipRectangle.visible
        cached: false // false pour ne pas bloquer les animations sur le chip parent.
    }

    /** ************************************************************************************
     * Rectangle du Chip.
     * *************************************************************************************/
    Rectangle {
        id: chipRectangle
        radius: 16
        color: canSave ? Style.chipDirtyColor : chipColor
        anchors.fill: parent

        /** ************************************************************************************
         * Icone "crayon" pour modifier la valeur du tag.
         * *************************************************************************************/
        Image {
            id: chipEdit
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            height: 26
            width: 26
            source: "qrc:/Images/chip-edit.png"
            visible: editable
            /// Clic sur l'icone EDIT: A gérer dans le controleur de la Zone parente avec chipXXX.editArea.onClicked:{...}
            MouseArea {
                id: editArea
                anchors.fill: parent
            }
        }

        /** ************************************************************************************
         * Icone "save" pour mémoriser la valeur du tag.
         * Cette image se superpose à la précédente (Edit).
         * Il faut donc faire attention à ce qu'elles ne soient pas à 'visible' en même temps.
         * *************************************************************************************/
        Image {
            id: chipSave
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            height: 26
            width: 26
            source: "qrc:/Images/chip-save.png"
            visible: canSave
            /// Clic sur l'icone SAVE: A gérer dans le controlleur de la Zone parente avec chipXXX.saveArea.onClicked:{...}
            MouseArea {
                id: saveArea
                anchors.fill: parent
            }
        }

        /** ************************************************************************************
         * Libellé "Target", cad le nom du tag à attribuer.
         * Couleur automatique du thème Material: foreground
         * On décale un peu le texte s'il y a un bouton.
         * *************************************************************************************/
        Label {
            id: chipTarget
            anchors.left: parent.left // Pas de bouton quand on affiche la target
            anchors.leftMargin: (editable || canSave) ? 36 : 12
            anchors.verticalCenter: parent.verticalCenter
            visible: !(hideTargetWhenFilled && content.trim() !== "")
            width: (hideTargetWhenFilled && content.trim() !== "") ? 0 : implicitWidth
            text: targetName === "" ? target + ":" : targetName
            color: _chipLabelColor
            font.pixelSize: 12
            // Positionnement du texte
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.NoWrap
            clip: true // Le texte peut être tronqué
        }

        /** ************************************************************************************
         * Texte du chip, cad la valeur du tag à attribuer.
         * Couleur automatique du thème Material: noir
         * *************************************************************************************/
        TextInput {
            id: chipText
            anchors.left: targetName ? chipTarget.right : chipEdit.right
            anchors.right: chipSwapTarget.left
            anchors.leftMargin: 4
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            text: content
            color: _chipValueColor
            readOnly: true
            font.pixelSize: 14
            font.bold: canSave
            // Positionnement du texte
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            // Retour à la ligne si le texte est plus long que le Rectangle
            wrapMode: Text.Wrap
            clip: false // Le texte n'est pas tronqué
            //  La taille max du texte pouvant être saisi (24 pour le Chips, 180 pour les FatChips).
            maximumLength: 24
            // Avec inputMask, Suppr efface le caractère mais ne déplace pas le curseur.
            // On force l'avance d'une position pour que chaque Suppr efface un digit différent.
            Keys.onDeletePressed: function (event) {
                event.accepted = false;  // laisser TextInput effacer le caractère
                if (inputMask !== "")
                    Qt.callLater(function () {
                        cursorPosition = cursorPosition + 1;
                    });
            }
        }

        /** ************************************************************************************
         * Icone "swap" pour basculer entre les targets "city" et "location".
         * *************************************************************************************/
        Image {
            id: chipSwapTarget
            anchors.right: chipDel.left
            anchors.rightMargin: 2
            anchors.verticalCenter: parent.verticalCenter
            height: 26
            width: visible ? 26 : 0
            source: target === "city" ? "qrc:/Images/chip-loc.png" : "qrc:/Images/chip-city.png"
            visible: swappable && content.trim() !== "" && !canSave
            MouseArea {
                id: swapArea
                anchors.fill: parent
            }
        }

        /** ************************************************************************************
         * Icone "corbeille" pour enlever le tag.
         * *************************************************************************************/
        Image {
            id: chipDel
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            height: 26
            width: 26
            source: "qrc:/Images/chip-del.png"
            visible: deletable
            /// Clic sur l'icone DELETE: déclenche l'animation, puis émet le signal chipXXX.onDeleteClicked.
            MouseArea {
                id: deleteArea
                anchors.fill: parent
            }
        }

        /** ************************************************************************************
         * Icone "revert" pour remettre la valeur précédente du tag.
         * *************************************************************************************/
        Image {
            id: chipRevert
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            height: 26
            width: 26
            source: "qrc:/Images/chip-revert.png"
            visible: canSave
            /// Clic sur l'icone REVERT: A gérer dans le controlleur de la Zone parente avec chipXXX.revertArea.onClicked:{...}
            MouseArea {
                id: revertArea
                anchors.fill: parent
            }
        }
    }

    /** ************************************************************************************
     * Interception du clic sur l'icone DELETE pour lancer l'animation avant suppression.
     * *************************************************************************************/
    Connections {
        target: deleteArea
        function onClicked() {
            chipRoot.state = "deleting";
        }
    }

    /** ************************************************************************************
     * Etat "deleting" : le chip se réduit et disparait.
     * *************************************************************************************/
    states: State {
        name: "deleting"
        PropertyChanges {
            target: chipRoot
            opacity: 0
            scale: 0.6
        }
    }

    transitions: Transition {
        from: ""
        to: "deleting"
        SequentialAnimation {
            ParallelAnimation {
                NumberAnimation {
                    target: chipRoot
                    property: "opacity"
                    duration: 250
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: chipRoot
                    property: "scale"
                    duration: 250
                    easing.type: Easing.OutQuad
                }
            }
            ScriptAction {
                script: {
                    chipRoot.deleteClicked();
                    chipRoot.state = "";
                }
            }
        }
    }
}
