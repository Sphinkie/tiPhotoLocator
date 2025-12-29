import QtQuick
import QtQuick.Layouts
import "../Components"

Item {
    width: 400
    property alias pictureZone: pictureZone
    property alias chipDate: chipDate
    property alias chipTime: chipTime
    property alias chipCreator: chipCreator
    property alias chipDescription: chipDescription
    property alias chipWriter: chipWriter

    Zone {
        id: pictureZone
        anchors.fill: parent
        iconZone: "qrc:/Images/icon-photo.png"
        txtZone: qsTr("Tags relatifs à la photo")

        ColumnLayout {
            Chips {
                id: chipDate
                editable: true
                deletable: false
                /*
                chipText.validator: RegularExpressionValidator {
                    regularExpression: /^(0[1-9]|[12][0-9]|3[01])[\/](0[1-9]|1[012])[\/](18|19|20)\d\d$/
                }
                */
            }
            Chips {
                id: chipTime
                editable: true
                deletable: false
                /*
                chipText.validator: RegularExpressionValidator {
                    regularExpression: /^(0[0-9]|1[0-9]|2[0-3])[\:][0-5][0-9]$/
                }
                */
            }
            Chips {
                id: chipCreator
                editable: true
                deletable: true
            }
            FatChip {
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
