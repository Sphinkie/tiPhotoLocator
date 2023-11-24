import QtQuick
import QtQuick.Layouts
import "../Components"

Item {
    width: 400
    height: 500
    property alias userDataZone: userDataZone
    property alias chipArtist: chipArtist
    property alias chipDescription: chipDescription
    property alias chipWriter: chipWriter

    Zone {
        id: userDataZone
        anchors.fill: parent
        txtZone: qsTr("Tags")

        ColumnLayout {
            Chips {
                id: chipArtist
                editable: true
                deletable: true
            }
            Chips {
                id: chipDescription
                editable: true
                deletable: true
            }
            Chips {
                id: chipWriter
                editable: true
                deletable: true
            }
        }
    }
}
