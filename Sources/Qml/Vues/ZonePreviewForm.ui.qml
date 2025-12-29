import QtQuick
import QtQuick.Layouts
import "../Components"


Zone {

    property alias chipName: chipName
    property alias chipSize: chipSize
    property alias chipDate: chipDate
    property alias chipTime: chipTime
    property alias chipMake: chipMake
    property alias chipCamModel: chipCamModel
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
        color : TiStyle.primaryTextColor
        textFormat: Text.StyledText
    }

    ColumnLayout {
        Chips {
            id: chipName
            Layout.topMargin: 20
            Layout.leftMargin: 20
            editable: false
            deletable: false
        }
        Chips {
            id: chipSize
            Layout.leftMargin: 20
            editable: false
            deletable: false
        }
        Chips {
            id: chipDate
            Layout.leftMargin: 20
            editable: false
            deletable: false
        }
        Chips {
            id: chipTime
            Layout.leftMargin: 20
            //content: "HH:MM"
            editable: false
            deletable: false
        }
        Chips {
            id: chipMake
            Layout.topMargin: 30  // on laisse un espace
            Layout.leftMargin: 20
            editable: false
            deletable: false
        }
        Chips {
            id: chipCamModel
            Layout.leftMargin: 20
            editable: false
            deletable: false
        }
        Chips {
            id: chipCountry
            Layout.leftMargin: 20
            editable: false
            deletable: false
        }
    }
}

