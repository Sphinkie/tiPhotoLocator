import QtQuick 2.4
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import "../Components"

Window {
    //id: settingsWindow
    width: 560
    height: 720

    GroupBox {
        id: groupBox1
        x: 10
        y: 26
        width: 520
        height: 160
        title: qsTr("Valeurs par défaut:")

        Text {
            id: element0
            x: 10
            y: 20
            width: 133
            height: 34
            text: qsTr("Nom du photographe")
            font.pixelSize: 14
        }
        TextField {
            id: textField1
            x: 160
            y: 20
            text: ""
            placeholderText: qsTr("Enter your name here")
        }
        Text {
            id: element1
            x: 360
            y: 20
            color: TiStyle.tertiaryTextColor
            text: qsTr("Artist (EXIF)")
            font.pixelSize: 14
            style: Text.Normal
        }


        Text {
            id: element4
            x: 10
            y: 60
            text: qsTr("Initiales du rédacteur des descriptions")
            font.pixelSize: 14
        }
        TextField {
            id: textField2
            x: 260
            y: 60
            width: 65
            height: 40
            placeholderText: qsTr("initiales")
        }
        Text {
            id: element5
            x: 360
            y: 60
            color: TiStyle.tertiaryTextColor
            text: qsTr("Description Writer (IPTC)")
            font.pixelSize: 14
            style: Text.Normal
        }

    }


    // ---------------- Group Box 2



    GroupBox {
        id: groupBox2
        x: 10
        y: 200
        width: 520
        height: 200
        title: qsTr("Tags dupliqués:")

        Text {
            id: element2
            x: 10
            y: 10
            text: qsTr("Tag utilisé pour enregistrer le nom du photographe:")
            font.pixelSize: 14
        }
        CheckBox {
            id: checkBox
            x: 100
            y: 40
            text: qsTr("Artist (EXIF)")
            enabled: false
            checkable: true
            checked: true
        }
        CheckBox {
            id: checkBox1
            x: 200
            y: 40
            text: qsTr("Creator (IPTC)")
        }


        Text {
            id: element3
            x: 10
            y: 60
            text: qsTr("Tag utilisé pour enregistrer la description de l'image:")
            font.pixelSize: 14
        }
        CheckBox {
            id: checkBox2
            x: 10
            y: 100
            text: qsTr("Description (EXIF)")
            enabled: false
            checked: true
        }
        CheckBox {
            id: checkBox4
            x: 200
            y: 100
            text: qsTr("Caption (IPTC)")
        }
        CheckBox {
            id: checkBox3
            x: 330
            y: 100
            text: qsTr("Image Description (EXIF)\nASCII only")
        }




    }


    GroupBox {
        id: groupBox3
        x: 10
        y: 420
        width: 520
        height: 80
        title: qsTr("Divers:")

        CheckBox {
            id: checkBox5
            x: 10
            y: 20
            text: qsTr("Debug mode")
        }

    }

    // ---------------- Buttons
    Button {
        id: button1
        x: 80
        y: 630
        text: qsTr("Annuler")
    }

    Button {
        id: button2
        x: 320
        y: 630
        text: qsTr("OK")
    }
}
