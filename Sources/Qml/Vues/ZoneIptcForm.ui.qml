import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"


/** *************************************************************************************************
 * @brief Vue de l'onglet avec les tags pouvant être appliquées à toutes les photos du dossier.
 * *************************************************************************************************/
Zone {
    property alias bt_applyDescription: bt_applyDescription
    property alias bt_applyLocation: bt_applyLocation
    property alias bt_applyCreator: bt_applyCreator
    property alias bt_applyCountry: bt_applyCountry
    property alias bt_applyCity: bt_applyCity
    property var photoKeywords: []
    signal applyKeyword(string keyword)

    iconZone: "qrc:/Images/icon-tag.png"
    txtZone: title + br + brief + br + usage + br + note + br
    color: Style.suggestionBackgroundColor

    readonly property string title: "<b>IPTC tags</b> "
    readonly property string brief: "<i>International Press Telecom Council</i>"
    readonly property string usage: qsTr("IPTC tags mainly contain editorial information, usually manually filled:")
    readonly property string note: qsTr("(image description, etc)")
    readonly property string br: "<br/>"

    /// Tableau des Chips avec leur description
    GridLayout {
        columns: 3
        columnSpacing: 24

        // -- --------------------------------------------------------
        /// Tag "Creator"
        // -- --------------------------------------------------------
        Chips {
            targetName: "artist:"
            content: creator ? creator : " "
        }
        Button {
            id: bt_applyCreator
            text: qsTr("Apply to all")
            enabled: creator ? true : false
        }
        Label {
            text: qsTr("Photographer name.")
        }

        // -- --------------------------------------------------------
        /// Tag "Country"
        // -- --------------------------------------------------------
        Chips {
            targetName: "country:"
            content: country ? country : " "
        }
        Button {
            id: bt_applyCountry
            text: qsTr("Apply to all")
            enabled: country ? true : false
        }
        Label {
            text: qsTr("The country where the photo was taken.")
        }

        // -- --------------------------------------------------------
        /// Tag "City"
        // -- --------------------------------------------------------
        Chips {
            targetName: "city:"
            content: city ? city : " "
        }
        Button {
            id: bt_applyCity
            text: qsTr("Apply to all")
            enabled: city ? true : false
        }
        Label {
            text: qsTr("City where the photo was taken or nearest city.")
        }

        // -- --------------------------------------------------------
        /// Tag "Location"
        // -- --------------------------------------------------------
        Chips {
            targetName: "location:"
            content: location ? location : " "
        }
        Button {
            id: bt_applyLocation
            text: qsTr("Apply to all")
            enabled: location ? true : false
        }
        Label {
            text: qsTr("Additionnal geographical information.")
        }

        // -- --------------------------------------------------------
        /// Tag "Description"
        // -- --------------------------------------------------------
        Chips {
            targetName: "description:"
            content: description ? description : " "
        }
        Button {
            id: bt_applyDescription
            text: qsTr("Apply to all")
            enabled: description ? true : false
        }
        Label {
            text: qsTr("Photo content description: who, where, how, why? (in a few words).")
        }

        // -- --------------------------------------------------------
        /// Tags "keywords" (avec Repeater)
        // -- --------------------------------------------------------
        ColumnLayout {
            spacing: 0
            Layout.columnSpan: 2
            Repeater {
                model: photoKeywords
                RowLayout {
                    spacing: 24
                    Chips {
                        targetName: "keywords:"
                        content: modelData ? modelData : ""
                    }
                    Button {
                        text: qsTr("Apply to all")
                        onClicked: applyKeyword(modelData)
                    }
                }
            }
        }
        Label {
            id: lb_keywords
            visible: photoKeywords.length > 0
            text: qsTr("A list of keywords, related to the photo and used for searches.")
        }
    }
}
