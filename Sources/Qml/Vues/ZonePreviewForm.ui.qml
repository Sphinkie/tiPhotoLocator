import QtQuick
import QtQuick.Layouts
import "../Components"


/** **********************************************************************************************************
 * @brief QML: Zone des informations de Preview.
 * Cette zone comporte les Chips principaux, non éditables: Filename, Dimensions, Date de la prise de vue,
 * Appareil photo, et Pays.
 * ***********************************************************************************************************/
Zone {

    property alias chipName: chipName
    property alias chipSize: chipSize
    property alias chipDate: chipDate
    property alias chipTime: chipTime
    property alias chipMake: chipMake
    property alias chipCamModel: chipCamModel
    property alias chipSpeed: chipSpeed
    property alias chipAperture: chipAperture
    property alias chipCountry: chipCountry
    property string welcomeText

    txtZone: qsTr("Summary")
    iconZone: "qrc:/Images/icon-preview.png"

    Text {
        width: zonePreview.width
        text: welcomeText
        font.pointSize: 14
        wrapMode: Text.WordWrap
        // anchors.centerIn: zonePreview // A mettre si on veut positionner le texte à mi-hauteur.
        horizontalAlignment: Text.AlignHCenter
        textFormat: Text.StyledText
    }

    ColumnLayout {
        /// Ce chip affiche le filename de la photo.
        Chips {
            id: chipName
            Layout.topMargin: 20
            Layout.leftMargin: 20
            editable: false
            deletable: false
        }
        /// Ce chip affiche les dimensions de la photo.
        Chips {
            id: chipSize
            Layout.leftMargin: 20
            editable: false
            deletable: false
        }
        /// Ce chip affiche la date de la photo.
        Chips {
            id: chipDate
            Layout.leftMargin: 20
            editable: false
            deletable: false
        }
        /// Ce chip affiche l'heure de la photo.
        Chips {
            id: chipTime
            Layout.leftMargin: 20
            //content: "HH:MM"
            editable: false
            deletable: false
        }
        /// Ce chip affiche la marque de l'appareil photo.
        Chips {
            id: chipMake
            Layout.topMargin: 30 // on laisse un espace
            Layout.leftMargin: 20
            editable: false
            deletable: false
        }
        /// Ce chip affiche le modèle de l'appareil photo.
        Chips {
            id: chipCamModel
            Layout.leftMargin: 20
            editable: false
            deletable: false
        }
        /// Ce chip affiche la vitesse de déclenchement
        Chips {
            id: chipSpeed
            Layout.leftMargin: 20
            editable: false
            deletable: false
        }
        /// Ce chip affiche l'ouverture de l'objectif
        Chips {
            id: chipAperture
            Layout.leftMargin: 20
            editable: false
            deletable: false
        }
        /// Ce chip affiche le pays où a été prise la photo.
        Chips {
            id: chipCountry
            Layout.leftMargin: 20
            editable: false
            deletable: false
        }
    }
}
