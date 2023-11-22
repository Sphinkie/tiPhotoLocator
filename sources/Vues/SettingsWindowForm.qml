import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtCore      // Qt.labs.settings
import "../Components"

Window {
    width: 560
    height: 720
    property alias buttonClose: buttonClose

    // ------------------------------------------------------------------
    // ---------------- Group Box 1 "Default values"
    // ------------------------------------------------------------------
    GroupBox {
        id: groupBox1
        anchors.left: parent.left
        anchors.top : parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 20
        width: parent.width-20
        height: 160
        title: qsTr("Valeurs par défaut")

        // ------------------------------------------------------------------
        // Valeur par défaut pour CREATOR
        // ------------------------------------------------------------------
        Text {
            id: element0
            x: 0;
            y: 10;
            text: qsTr("Nom du photographe:")
            font.pixelSize: 12
        }
        TextField {
            id: textFieldName
            anchors.left: element0.right
            anchors.bottom: element0.bottom
            anchors.bottomMargin: -10
            anchors.leftMargin: 10
            width: 200; height: 30
            placeholderText: qsTr("Enter your name here")
        }
        Text {
            id: element1
            anchors.left: textFieldName.right
            anchors.bottom: element0.bottom
            anchors.leftMargin: 10
            color: TiStyle.tertiaryTextColor
            text: "Creator (IPTC)"
            font.pixelSize: 12
            style: Text.Normal
        }

        // ------------------------------------------------------------------
        // Valeur par défaut pour DESCRIPTION WRITER
        // ------------------------------------------------------------------
        Text {
            id: element4
            // positionnement par rapport à Element0
            anchors.left: element0.left
            anchors.top: element0.bottom
            anchors.topMargin: 20
            text: qsTr("Initiales du rédacteur des descriptions:")
            font.pixelSize: 12
        }
        TextField {
            id: textFieldInitials
            anchors.left: element4.right
            anchors.bottom: element4.bottom
            anchors.bottomMargin: -10
            anchors.leftMargin: 20
            width: 90; height: 30;
            placeholderText: qsTr("initiales")
        }
        Text {
            id: element5
            anchors.left: textFieldInitials.right
            anchors.bottom: element4.bottom
            anchors.leftMargin: 10
            color: TiStyle.tertiaryTextColor
            text: "Description Writer (IPTC)"
            font.pixelSize: 12
            style: Text.Normal
        }

        // ------------------------------------------------------------------
        // Valeur par défaut pour SOFTWARE
        // ------------------------------------------------------------------
        Text {
            id: element6
            anchors.left: element0.left
            anchors.top: element4.bottom
            anchors.topMargin: 20
            text: qsTr("Signature application:")
            font.pixelSize: 12
        }
        TextField {
            id: textFieldSoftware
            anchors.left: element6.right
            anchors.bottom: element6.bottom
            anchors.bottomMargin: -10
            anchors.leftMargin: 10
            width: 200; height: 30;
            text: "TiPhotoLocator"
            enabled: false
        }
        Text {
            id: element7
            anchors.left: textFieldSoftware.right
            anchors.bottom: element6.bottom
            anchors.leftMargin: 10
            color: TiStyle.tertiaryTextColor
            text: "Software (Exif)"
            font.pixelSize: 12
            style: Text.Normal
        }
    }


    // ------------------------------------------------------------------
    // ---------------- Group Box 2 "Duplicated Tags"
    // ------------------------------------------------------------------
    GroupBox {
        id: groupBox2
        anchors.left: parent.left
        anchors.top : groupBox1.bottom
        anchors.leftMargin: 10
        anchors.topMargin: 20
        width: parent.width-20
        height: 200
        title: qsTr("Tags dupliqués:")

        // ------------------------------------------------------------------
        // CheckBox Artist/Creator
        // ------------------------------------------------------------------
        Text {
            id: element2
            x: 0
            y: 0
            text: qsTr("Tag utilisé pour enregistrer le nom du photographe:")
            font.pixelSize: 12
        }
        CheckBox {
            id: checkBoxCreator
            anchors.left: element2.left
            anchors.top: element2.bottom
            anchors.topMargin: 6
            text: "Creator (IPTC)"
            enabled: false
            checkable: true
            checked: true
        }
        CheckBox {
            id: checkBoxArtist
            anchors.left: checkBoxCreator.right
            anchors.bottom: checkBoxCreator.bottom
            anchors.leftMargin: 10
            text: "Artist (EXIF)"
            checkable: true
            checked: true
        }

        // ------------------------------------------------------------------
        // CheckBox Description/Caption
        // ------------------------------------------------------------------
        Text {
            id: element3
            anchors.left: element2.left
            anchors.top: element2.bottom
            anchors.topMargin: 40
            text: qsTr("Tag utilisé pour enregistrer la description de l'image:")
            font.pixelSize: 12
        }
        CheckBox {
            id: checkBoxDescription
            anchors.left: element3.left
            anchors.top: element3.bottom
            anchors.topMargin: 6
            text: "Description (IPTC)"
            enabled: false
            checked: true
        }
        CheckBox {
            id: checkBoxCaption
            anchors.left: checkBoxDescription.right
            anchors.bottom: checkBoxDescription.bottom
            anchors.leftMargin: 10
            text: "Caption (IPTC)"
        }
        CheckBox {
            id: checkBoxImgDesc
            anchors.left: checkBoxCaption.right
            anchors.bottom: checkBoxCaption.bottom
            anchors.leftMargin: 10
            text: "Image Description (EXIF)\nASCII only"
        }
    }

    // ------------------------------------------------------------------
    // ---------------- Group Box 3 "Misc"
    // ------------------------------------------------------------------
    GroupBox {
        id: groupBox3
        anchors.left: parent.left
        anchors.top : groupBox2.bottom
        anchors.leftMargin: 10
        anchors.topMargin: 20
        width: parent.width - 20
        height: 120
        title: qsTr("Divers:")

        CheckBox {
            id: checkBoxDebug
            x: 0
            y: 0
            text: "Debug mode"
        }
        Text {
            id: element8
            anchors.left: checkBoxDebug.right
            // anchors.right: textFieldHomecity.left
            anchors.margins: 10
            anchors.verticalCenter: checkBoxDebug.verticalCenter
            text: qsTr("Centrage carte:")
            font.pixelSize: 12
        }
        TextField {
            id: textFieldHomecity
            anchors.left: element8.right
            //anchors.right: groupBox3.right
            anchors.verticalCenter: checkBoxDebug.verticalCenter
            anchors.margins: 10
            width: 200; height: 30;
            placeholderText :qsTr("Votre ville la plus photographiée")
        }
        Text {
            id: element10
            anchors.left: textFieldHomecity.right
            anchors.bottom: element8.bottom
            anchors.leftMargin: 10
            color: TiStyle.tertiaryTextColor
            text: "(Needs restart)"
            font.pixelSize: 12
            style: Text.Normal
        }

        Text {
            id: element9
            anchors.left: checkBoxDebug.left
            anchors.top: checkBoxDebug.bottom
            anchors.margins: 10
            text: qsTr("Langue des tags:")
            font.pixelSize: 12
        }
        ComboBox{
            id: tagLanguages
            anchors.left: element9.right
            anchors.verticalCenter: element9.verticalCenter
            anchors.margins: 10
            model: ["English", "System language"]
        }
    }

    // ------------------------------------------------------------------
    // ---------------- "Descriptions"
    // ------------------------------------------------------------------
    Item {
        id: groupBox4
        anchors.left: parent.left
        anchors.top : groupBox3.bottom
        anchors.leftMargin: 10
        anchors.topMargin: 20
        width: parent.width-20
        clip: true
        height: 80
        Text { y:0;  clip: true; text: qsTr("Les tags EXIF contiennent principalement des informations techniques (Modèle d'appareil, objectif...)") }
        Text { y:20; clip: true; text: qsTr("Les données EXIF ne sont pas destinées à être modifiées.") }
        Text { y:40; clip: true; text: qsTr("Elle sont définies (normalement) au moment de la prise de vue.") }
        Text { y:60; clip: true; text: qsTr("Les tags IPTC contiennent principalement des informations éditoriales (Description de l'image...)    ") }
    }

    // ------------------------------------------------------------------
    // ---------------- Buttons
    // ------------------------------------------------------------------
    Button {
        id: buttonClose
        anchors.top: groupBox4.bottom; anchors.topMargin: 20
        anchors.right: groupBox4.right; anchors.rightMargin: 60
        width: 100
        text: qsTr("Fermer")
        onClicked: {
        console.log("onClicked -> request coords " + reglages.homecity);
        window.requestCoords(reglages.homecity);
            close();
        }
    }


    // ----------------------------------------------------------------
    // On mémorise la configuration dans les settings
    // ----------------------------------------------------------------
    Settings {
        id: reglages
        //category: "configuration"
        property alias photographe: textFieldName.text
        property alias initiales: textFieldInitials.text
        property alias software : textFieldSoftware.text
        property alias homecity : textFieldHomecity.text
        property alias artistEnabled: checkBoxArtist.checked
        property alias captionEnabled: checkBoxCaption.checked
        property alias imgDescEnabled: checkBoxImgDesc.checked
        property alias debugModeEnabled: checkBoxDebug.checked
        property alias tagLanguage: tagLanguages.currentIndex
    }

}
