import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"


/** *************************************************************************************************
 * @brief Vue de l'onglet avec les tags pouvant être appliquées à toutes les photos du dossier.
 * *************************************************************************************************/
GridLayout {
    property alias bt_applyCreator: bt_applyCreator
    property alias bt_applyCountry: bt_applyCountry
    property alias bt_applyCity: bt_applyCity
    uniformCellHeights: true
    rowSpacing: 10
    columns: 3

    // -- --------------------------------------------------------
    /// Tag "Creator"
    // -- --------------------------------------------------------
    TinyChip {
        content: "Creator"
    }
    Button {
        id: bt_applyCreator
        text: qsTr("Appliquer à tous")
    }
    Text {
        property string creatorText: creator ? "(Configuré à: <b>" + creator + "</b> )" : ""
        text: qsTr("Le nom du photographe. ") + creatorText
        font.pixelSize: 14
        // DDL color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

    // -- --------------------------------------------------------
    /// Tag "City"
    // -- --------------------------------------------------------
    TinyChip {
        content: "City"
    }
    CheckBox {
        checked: true
        enabled: false
        visible: !city
    }
    Button {
        id: bt_applyCity
        text: qsTr("Appliquer à tous")
        visible: city
    }
    Text {
        property string cityText: city ? "( <b>" + city + "</b> )" : ""
        text: qsTr("Le nom de la ville repésentée sur la photo, ou la ville proche du lieu photographié. ") + cityText
        font.pixelSize: 14
        // DDL color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

    // -- --------------------------------------------------------
    /// Tag "Country"
    // -- --------------------------------------------------------
    TinyChip {
        content: "Country"
    }
    CheckBox {
        checked: true
        enabled: false
        visible: !country
    }
    Button {
        id: bt_applyCountry
        text: qsTr("Appliquer à tous")
        visible: country
    }
    Text {
        property string countryText: country ? "( <b>" + country + " </b> )" : ""
        text: qsTr("Le pays où a été pris la photo. ") + countryText
        font.pixelSize: 14
        // DDL color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

    // -- --------------------------------------------------------
    /// Tag "Description"
    // -- --------------------------------------------------------
    TinyChip {
        content: "Description"
    }
    CheckBox {
        checked: true
        enabled: false
    }
    Text {
        text: qsTr("Description du contenu de la photo. En quelques mots : qui, quoi, comment, pourquoi.")
        font.pixelSize: 14
        // DDL color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

    // -- --------------------------------------------------------
    /// Tag "Writer"
    // -- --------------------------------------------------------
    TinyChip {
        content: "Description Writer"
    }
    CheckBox {
        checked: true
        enabled: false
    }
    Text {
        property string writerText: writer ? "(Configuré à: <b>" + writer + " </b> )" : ""
        text: qsTr("Les initiales de la personne ayant rédigé la description. ") + writerText
        font.pixelSize: 14
        // DDL color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }

    // -- --------------------------------------------------------
    /// Tags "keywords"
    // -- --------------------------------------------------------
    TinyChip {
        content: "Keywords"
    }
    CheckBox {
        checked: true
        enabled: false
    }
    Text {
        text: qsTr("Une liste de mots clefs relatifs à la photo, et utilisés pour les recheches.")
        font.pixelSize: 14
        // DDL color: TiStyle.secondaryTextColor
        verticalAlignment: Text.AlignVCenter
    }
}
