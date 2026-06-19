import QtQuick
import QtQuick.Layouts
import "../Components"


/** **********************************************************************************************************
 * @brief Cette Zone "Tags" affiche les Chips des Keywords (Userdata).
 * ***********************************************************************************************************/
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

    /// La Zone peut comprendre jusqu'à 8 keywords, disposés en colonne.
    Zone {
        id: userDataZone
        anchors.fill: parent
        txtZone: qsTr("Tags")
        iconZone: "qrc:/Images/icon-tag.png"

        ColumnLayout {
            /// Chip du keyword 0
            Chips {
                id: chipKeyword0
                editable: true
                deletable: true
                chipCategory: "keyword"
                targetName: "keyword:"
            }
            /// Chip du keyword 1
            Chips {
                id: chipKeyword1
                editable: true
                deletable: true
                chipCategory: "keyword"
                targetName: "keyword:"
            }
            /// Chip du keyword 2
            Chips {
                id: chipKeyword2
                editable: true
                deletable: true
                chipCategory: "keyword"
                targetName: "keyword:"
            }
            /// Chip du keyword 3
            Chips {
                id: chipKeyword3
                editable: true
                deletable: true
                chipCategory: "keyword"
                targetName: "keyword:"
            }
            /// Chip du keyword 4
            Chips {
                id: chipKeyword4
                editable: true
                deletable: true
                chipCategory: "keyword"
                targetName: "keyword:"
            }
            /// Chip du keyword 5
            Chips {
                id: chipKeyword5
                editable: true
                deletable: true
                chipCategory: "keyword"
                targetName: "keyword:"
            }
            /// Chip du keyword 6
            Chips {
                id: chipKeyword6
                editable: true
                deletable: true
                chipCategory: "keyword"
                targetName: "keyword:"
            }
            /// Chip du keyword 7
            Chips {
                id: chipKeyword7
                editable: true
                deletable: true
                chipCategory: "keyword"
                targetName: "keyword:"
            }
        }
    }
}
