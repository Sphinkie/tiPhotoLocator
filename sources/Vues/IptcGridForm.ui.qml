import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../Components"

GridLayout {
    uniformCellHeights: true
    rowSpacing: 10
    columns: 3

    // rows: 6
    TinyChip {
        content: "Creator"
    }
    TiButton {
        text: qsTr("Appliquer à tous")
    }
    Text {
        text: qsTr("Le nom du photographe (Settings).")
        font.pixelSize: 14
        color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

    TinyChip {
        content: "City"
    }
    CheckBox {
        checked: true
        enabled: false
    }
    Text {
        text: qsTr("Le nom de la ville repésentée sur la photo, ou la ville proche du lieu photographié.")
        font.pixelSize: 14
        color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

    TinyChip {
        content: "Country"
    }
    CheckBox {
        checked: true
        enabled: false
    }
    Text {
        text: qsTr("Le pays où a été pris la photo.")
        font.pixelSize: 14
        color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

    TinyChip {
        content: "Description"
    }
    CheckBox {
        checked: true
        enabled: false
    }
    Text {
        text: qsTr("Description du contenu de la photo. En quelques mots : qui, quoi, comment, pourquoi.")
        font.pixelSize: 14
        color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

    TinyChip {
        content: "DescriptionWriter"
    }
    CheckBox {
        checked: true
        enabled: false
    }
    Text {
        text: qsTr("Les initiales de la personne ayant rédigé la description (Settings)")
        font.pixelSize: 14
        color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

    TinyChip {
        content: "Keywords"
    }
    CheckBox {
        checked: true
        enabled: false
    }
    Text {
        text: qsTr("Une liste de mots clefs relatifs à la photo, et utilisés pour les recheches.")
        font.pixelSize: 14
        color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }
}
