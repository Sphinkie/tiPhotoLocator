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
    property alias bt_applyKeyword: bt_applyKeyword
    property alias bt_applyCity: bt_applyCity

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
            targetName: "Creator"
            content: creator ? creator : " "
        }
        Button {
            id: bt_applyCreator
            text: qsTr("Apply to all")
        }
        Label {
            text: qsTr("Photographer name.")
        }

        // -- --------------------------------------------------------
        /// Tag "Country"
        // -- --------------------------------------------------------
        Chips {
            targetName: "Country"
            content: country ? country : " "
        }
        Button {
            id: bt_applyCountry
            text: qsTr("Apply to all")
        }
        Label {
            text: qsTr("The country where the photo was taken.")
        }

        // -- --------------------------------------------------------
        /// Tag "City"
        // -- --------------------------------------------------------
        Chips {
            targetName: "City"
            content: city ? city : " "
        }
        Button {
            id: bt_applyCity
            text: qsTr("Apply to all")
        }
        Label {
            text: qsTr("Le nom de la ville repésentée sur la photo, ou la ville proche du lieu photographié.")
        }

        // -- --------------------------------------------------------
        /// Tag "Location"
        // -- --------------------------------------------------------
        Chips {
            targetName: "Location"
            content: location ? location : " "
        }
        Button {
            id: bt_applyLocation
            text: qsTr("Apply to all")
        }
        Label {
            text: qsTr("Additionnal geographical information.")
        }

        // -- --------------------------------------------------------
        /// Tag "Description"
        // -- --------------------------------------------------------
        Chips {
            targetName: "Description"
            content: description ? description : " "
        }
        Button {
            id: bt_applyDescription
            text: qsTr("Apply to all")
        }
        Label {
            text: qsTr("Description du contenu de la photo. En quelques mots : qui, quoi, comment, pourquoi.")
        }

        // -- --------------------------------------------------------
        /// Tags "keywords"
        // -- --------------------------------------------------------
        Chips {
            targetName: "Keywords"
            content: "..."
        }
        Button {
            id: bt_applyKeyword
            text: qsTr("Apply to all")
            enabled: false
        }
        Label {
            text: qsTr("Une liste de mots clefs relatifs à la photo, et utilisés pour les recheches.")
        }
    }
}
