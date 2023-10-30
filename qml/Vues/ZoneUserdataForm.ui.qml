import QtQuick 2.4
import QtQuick.Layouts 1.3
import "../Components"

Item {
    width: 400
    //height: 600
    property alias chipArtist: chipArtist
    property alias chipDescription: chipDescription
    property alias chipWriter: chipWriter
    property string txtPreviewZone

    Zone {
        txtZone: txtPreviewZone

        ColumnLayout {
            Chips {
                id: chipArtist
                Layout.leftMargin: 20
                editable: false
                deletable: false
            }
            Chips {
                id: chipDescription
                Layout.leftMargin: 20
                editable: false
                deletable: false
            }
            Chips {
                id: chipWriter
                Layout.leftMargin: 20
                editable: false
                deletable: false
            }
        }
    }
}


