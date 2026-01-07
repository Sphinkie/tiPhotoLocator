import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"


/** *************************************************************************************************
 * @brief Vue de l'onglet avec les tags pouvant être appliquées à toutes les photos du dossier.
 * *************************************************************************************************/
Zone {
    property alias bt_applyCreator: bt_applyCreator
    property alias bt_applyLocation: bt_applyLocation
    property alias bt_applyCountry: bt_applyCountry
    property alias bt_applyCity: bt_applyCity

    iconZone: "qrc:/Images/icon-tag.png"
    txtZone: title + br + brief + br + usage + br + note + br

    readonly property string title: "<b>IPTC tags</b> "
    readonly property string brief: "<i>International Press Telecom Council</i>"
    readonly property string usage: qsTr("Les tags IPTC contiennent principalement des informations éditoriales renseignés manuellement")
    readonly property string note: qsTr("(description de l'image, etc)")
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
            text: qsTr("Appliquer à tous")
        }
        Label {
            text: qsTr("Le nom du photographe.")
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
            text: qsTr("Appliquer à tous")
        }
        Label {
            text: qsTr("Le pays où a été pris la photo.")
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
            text: qsTr("Appliquer à tous")
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
            text: qsTr("Appliquer à tous")
        }
        Label {
            text: qsTr("Additionnal geographical information.")
        }

        // -- --------------------------------------------------------
        /// Tag "Description"
        // -- --------------------------------------------------------
        Chips {
            targetName: "Description"
            content: "..."
        }
        Button {
            text: qsTr("Appliquer à tous")
            enabled: false
        }
        Label {
            text: qsTr("Description du contenu de la photo. En quelques mots : qui, quoi, comment, pourquoi.")
        }

        // -- --------------------------------------------------------
        /// Tag "Writer"
        // -- --------------------------------------------------------
        Chips {
            targetName: "Description Writer"
            content: writer ? writer : " "
        }
        Button {
            text: qsTr("Appliquer à tous")
            enabled: false
        }
        Label {
            text: qsTr("Les initiales de la personne ayant rédigé la description.")
        }

        // -- --------------------------------------------------------
        /// Tags "keywords"
        // -- --------------------------------------------------------
        Chips {
            targetName: "Keywords"
            content: "..."
        }
        Button {
            text: qsTr("Appliquer à tous")
            enabled: false
        }
        Label {
            text: qsTr("Une liste de mots clefs relatifs à la photo, et utilisés pour les recheches.")
        }
    }
}
