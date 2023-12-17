import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../Components"

GridLayout {
    uniformCellHeights: true
    rowSpacing: 10
    columns: 3
    rows: 5

    TinyChip {
        content: "Make"
    }
    CheckBox {
        checked: false
        enabled: false
    }
    Text {
        text: qsTr("Fabriquant de l'appareil photo")
        font.pixelSize: 14
        color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

    TinyChip {
        content: "Model"
    }
    CheckBox {
        checked: false
        enabled: false
    }
    Text {
        text: qsTr("Modèle de l'appareil photo")
        font.pixelSize: 14
        color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

    TinyChip {
        content: "Speed & Fnumber"
    }
    CheckBox {
        checked: false
        enabled: false
    }
    Text {
        text: qsTr("Camera Aperture and Speed of the shot")
        font.pixelSize: 14
        color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

    TinyChip {
        content: "Artist"
    }
    CheckBox {
        checked: !settings.preserveExif
        enabled: false
    }
    Text {
        text: qsTr("Nom du photographe")
        font.pixelSize: 14
        color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

    TinyChip {
        content: "GPS longitude/latitude"
    }
    CheckBox {
        checked: true
        enabled: false
    }
    Text {
        text: qsTr("Coordonnées GPS au moment de la prise de vue.")
        font.pixelSize: 14
        color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }
}
