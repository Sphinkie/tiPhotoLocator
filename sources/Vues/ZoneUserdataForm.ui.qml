import QtQuick
import QtQuick.Layouts
import "../Components"

Item {
    width: 400
    height: 400
    property alias userDataZone: userDataZone
    property alias chipKeyword0: chipKeyword0
    property alias chipKeyword1: chipKeyword1
    property alias chipKeyword2: chipKeyword2
    property alias chipKeyword3: chipKeyword3
    property alias chipKeyword4: chipKeyword4
    property alias chipKeyword5: chipKeyword5
    property alias chipKeyword6: chipKeyword6
    property alias chipKeyword7: chipKeyword7

    Zone {
        id: userDataZone
        anchors.fill: parent
        txtZone: qsTr("Tags")
        iconZone: "qrc:/Images/icon-tag.png"

        ColumnLayout {
            Chips {
                id: chipKeyword0
                editable: true
                deletable: true
            }
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
            Chips {
                id: chipKeyword4
                editable: true
                deletable: true
            }
            Chips {
                id: chipKeyword5
                editable: true
                deletable: true
            }
            Chips {
                id: chipKeyword6
                editable: true
                deletable: true
            }
            Chips {
                id: chipKeyword7
                editable: true
                deletable: true
            }
        }
    }
}
