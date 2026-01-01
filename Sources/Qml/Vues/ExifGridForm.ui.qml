import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"

GridLayout {
    // uniformCellHeights: true
    rowSpacing: 10
    columns: 3
    rows: 5

	/// Tag "Make"
    TinyChip {
        content: "Make"
    }
    CheckBox {
        checked: true
        enabled: false
    }
    Text {
        text: qsTr("Fabriquant de l'appareil photo")
        font.pixelSize: 14
        // DDL color: Style.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

	/// Tag "Camera model"
    TinyChip {
        content: "Model"
    }
    CheckBox {
        checked: true
        enabled: false
    }
    Text {
        text: qsTr("Modèle de l'appareil photo")
        font.pixelSize: 14
        // DDL color: Style.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }
	/// Tag for Speed and Aperture
    TinyChip {
        content: "Speed & Fnumber"
    }
    CheckBox {
        checked: true
        enabled: false
    }
    Text {
        text: qsTr("Camera Aperture and Speed of the shot")
        font.pixelSize: 14
        // DDL color: Style.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

	/// Tag for Photographer name
    TinyChip {
        content: "Artist"
    }
    CheckBox {
        checked: true
        enabled: false
    }
    Text {
        text: qsTr("Nom du photographe")
        font.pixelSize: 14
        // DDL color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

	/// Tag for GPS coordinates
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
        // DDL color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }
}
