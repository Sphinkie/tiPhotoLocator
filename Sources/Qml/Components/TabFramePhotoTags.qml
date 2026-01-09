import QtQuick
import QtQuick.Layouts
import "../Controllers"


/** *************************************************************************************
 * @brief Onglets avec les tags de la photo sélectionnée, regroupés par catégorie.
 * *************************************************************************************/
GridLayout {
    columns: 4

    ZoneGeoloc {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
        chipLocation.editable: true
        chipCity.editable: true
        chipCountry.editable: true
    }

    ZoneCamera {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
    }

    ZonePhoto {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
    }

    ZoneUserdata {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
        Layout.rightMargin: 40
    }

    ZoneSuggestedTags {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.columnSpan: 4
        Layout.margins: 10
        Layout.rightMargin: 40
        iconZone: "qrc:/Images/icon-suggestion.png"
        txtZone: qsTr("Suggestions")
    }
}
