import QtQuick
import QtQuick.Layouts
import "../Components"



Item {
    width: 400
    property alias pictureZone: pictureZone
    property alias chipDate: chipDate
    property alias chipCreator: chipCreator
    property alias chipDescription: chipDescription
    property alias chipWriter: chipWriter

    Zone {
        id: pictureZone
        anchors.fill: parent
        iconZone: "qrc:/Images/photo.png"
        txtZone: qsTr("Photo")

        ColumnLayout {
            Chips {
                id: chipDate
                editable: true
                deletable: false
            }
            Chips {
                id: chipCreator
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


