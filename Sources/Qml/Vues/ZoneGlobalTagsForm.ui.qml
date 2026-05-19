import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"


/** *************************************************************************************************
 * @brief Vue de l'onglet avec les tags pouvant être appliquées à toutes les photos du dossier.
 * *************************************************************************************************/
Zone {
    // Boutons "Apply to All"
    property alias bt_applyDescription: bt_applyDescription
    property alias bt_applyLocation: bt_applyLocation
    property alias bt_applyCreator: bt_applyCreator
    property alias bt_applyCountry: bt_applyCountry
    property alias bt_applyCity: bt_applyCity
    property alias bt_applyDateTime: bt_applyDateTime
    property var photoKeywords: []
    // Latches pour mémoriser si le bouton a été cliqué
    property var appliedKeywords: []
    property string dateTimeFormatted: ""
    property bool creatorApplied: false
    property bool countryApplied: false
    property bool cityApplied: false
    property bool locationApplied: false
    property bool descriptionApplied: false
    property bool dateTimeApplied: false
    // Signal
    signal applyKeyword(string keyword)

    iconZone: "qrc:/Images/icon-tag.png"
    // iconZone: "qrc:/Images/icon-camera1" (icone alternative)
    txtZone: title + br + brief + br + usage1 + br + note1 + br + usage2 + br + note2 + br
    color: Style.suggestionBackgroundColor

    readonly property string br: "<br>"
    readonly property string title: "<b>EXIF and IPTC tags</b> "
    readonly property string brief: "<i>EXchangeable Image Fileformat</i> & <i>International Press Telecom Council</i>"
    readonly property string usage1: qsTr("IPTC tags mainly contain editorial information, usually manually filled:")
    readonly property string note1: qsTr("(image description, etc)")
    readonly property string usage2: qsTr("EXIF tags are defined at the moment of the shot.")
    readonly property string note2: qsTr("They mainly contain technical information: camera model, lens...")

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
            // Note: !!creator est la notation compacte pour creator? true:false.
            enabled: !!creator && !creatorApplied
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
            enabled: !!country && !countryApplied
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
            enabled: !!city && !cityApplied
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
            enabled: !!location && !locationApplied
        }
        Label {
            text: qsTr("Additionnal geographical information.")
        }

        // -- --------------------------------------------------------
        /// Tag "dateTimeOriginal"
        // -- --------------------------------------------------------
        Chips {
            targetName: "date:"
            content: dateTimeFormatted ? dateTimeFormatted : " "
        }
        Button {
            id: bt_applyDateTime
            text: qsTr("Apply to all")
            enabled: !!dateTimeFormatted && !dateTimeApplied
        }
        Label {
            text: qsTr("Date and time when the photo was taken.")
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

            enabled: !!description && !descriptionApplied
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
            KeywordsRepeater {
                id: keywordsRepeater
            }
        }
        Label {
            id: lb_keywords
            visible: photoKeywords.length > 0
            text: qsTr("A list of keywords, related to the photo and used for searches.")
        }
    }
}
