import QtQuick
import QtQuick.Layouts
import "../Components"

Item {
    width: 400
    height: 400
    property alias userDataZone: userDataZone
    property alias chipKeyword1: chipKeyword1
    property alias chipKeyword2: chipKeyword2
    property alias chipKeyword3: chipKeyword3

    Zone {
        id: userDataZone
        anchors.fill: parent
        txtZone: qsTr("Tags")
        iconZone: "qrc:/Images/icon-tag.png"

        ColumnLayout {
            Chips {
                id: chipKeyword1
                editable: true
                deletable: true
            }
            Chips {
                id: chipKeyword2
                editable: true
                deletable: true
            }
            Chips {
                id: chipKeyword3
                editable: true
                deletable: true
            }
        }
    }
}
