import QtQuick 2.4
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import "../Components"

Rectangle {
    id: settingsWindow
    width: 560
    height: 720

    Text {
        id: element
        x: 20
        y: 64
        width: 133
        height: 34
        text: qsTr("Nom du photographe")
        font.pixelSize: 12

        Text {
            id: element1
            x: 369
            y: 4
            color: TiStyle.tertiaryTextColor
            text: qsTr("'Artist'")
            font.pixelSize: 12
            style: Text.Normal
        }
    }

    Text {
        id: element2
        x: 23
        y: 232
        text: qsTr("Tag utilisé pour enregistrer le nom du photographe:")
        font.pixelSize: 12
    }

    CheckBox {
        id: checkBox
        x: 23
        y: 252
        text: qsTr("Artist")
        enabled: false
        checkable: true
        checked: true
    }

    CheckBox {
        id: checkBox1
        x: 200
        y: 252
        text: qsTr("Creator (IPTC)")
    }

    Text {
        id: element3
        x: 26
        y: 300
        text: qsTr("Tag utilisé pour enregistrer la description de l'image:")
        font.pixelSize: 12
    }

    CheckBox {
        id: checkBox2
        x: 21
        y: 320
        text: qsTr("Description (EXIF)")
        enabled: false
        checked: true
    }

    CheckBox {
        id: checkBox3
        x: 329
        y: 318
        text: qsTr("Image Description (IPTC)")
    }

    CheckBox {
        id: checkBox4
        x: 204
        y: 320
        text: qsTr("Headline ")
    }

    CheckBox {
        id: checkBox5
        x: 18
        y: 529
        text: qsTr("Debug mode")
    }

    Text {
        id: element4
        x: 21
        y: 125
        text: qsTr("Initiales du rédacteur des descriptions")
        font.pixelSize: 12
    }

    Text {
        id: element5
        x: 383
        y: 126
        color: TiStyle.tertiaryTextColor
        text: qsTr("'TextRedactor' (IPTC)")
        font.pixelSize: 12
        style: Text.Normal
    }

    TextField {
        id: textField
        x: 164
        y: 58
        text: ""
        placeholderText: qsTr("Enter your name here")
    }

    TextField {
        id: textField1
        x: 236
        y: 112
        width: 65
        height: 40
        placeholderText: qsTr("initiales")
    }

    GroupBox {
        id: groupBox
        x: 14
        y: 26
        width: 517
        height: 149
        title: qsTr("Valeurs par défaut:")
    }

    GroupBox {
        id: groupBox1
        x: 12
        y: 194
        width: 514
        height: 201
        title: qsTr("Tags dupliqués:")
    }

    GroupBox {
        id: groupBox2
        x: 10
        y: 414
        width: 513
        height: 162
        title: qsTr("Divers:")
    }

    Button {
        id: button
        x: 76
        y: 630
        text: qsTr("Annuler")
    }

    Button {
        id: button1
        x: 329
        y: 630
        text: qsTr("OK")
    }
}
