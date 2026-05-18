import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"


/** *************************************************************************************************
 * @brief Vue des tags EXIF gérés par le logiciel.
 * *************************************************************************************************/
Zone {
    id: exifZone
    iconZone: "qrc:/Images/icon-camera1"
    txtZone: title + br + brief + br + usage + br + note + br

    readonly property string title: "<b>EXIF tags</b> "
    readonly property string brief: "<i>EXchangeable Image Fileformat</i>"
    readonly property string usage: qsTr("EXIF tags are defined at the moment of the shot.")
    readonly property string note: qsTr("They mainly contain technical information: camera model, lens...")
    readonly property string br: "<br>"

    /// Tableau des Chips avec leur description
    GridLayout {
        columns: 2
        columnSpacing: 24

        /// Tag for Speed and Aperture
        Chips {
            targetName: "Speed & Fnumber"
            content: "..."
            editable: false
            deletable: false
        }
        /// Label Speed and Aperture
        Label {
            text: qsTr("Camera Aperture and Speed of the shot")
        }
        /// Tag for Photographer name
        Chips {
            targetName: "Artist"
            content: "..."
            editable: false
            deletable: false
        }
        /// Label for Photographer name
        Label {
            text: qsTr("Photographer name")
        }
        /// Tag for GPS coordinates
        Chips {
            targetName: "GPS longitude / latitude"
            content: "..."
            editable: false
            deletable: false
        }
        /// Label for GPS coordinates
        Label {
            text: qsTr("GPS coordinates when the photo was taken.")
        }
    }
}
