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

    RowLayout {
        Layout.columnSpan: 4
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 0

        ZoneSuggestedTags {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 10
            txtZone: qsTr("Suggestions")
        }
        ZoneSuggestedTags {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 10
            Layout.rightMargin: 40
            onlyKeywords: true
            txtZone: qsTr("Keywords Suggestions")
        }
    }
}
