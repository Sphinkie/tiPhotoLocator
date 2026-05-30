import QtQuick
import QtQuick.Layouts
import "../Controllers"


/** *************************************************************************************
 * @brief Onglets avec les tags de la photo sélectionnée, regroupés par catégorie.
 * *************************************************************************************/
GridLayout {
    columns: 4

    ZoneGeoloc {
        id: zoneGeoloc
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
        chipLocation.editable: true
        chipCity.editable: true
        chipCountry.editable: true
    }

    ZoneCamera {
        id: zoneCamera
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
    }

    ZonePhoto {
        id: zonePhoto
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
    }

    ZoneUserdata {
        id: zoneUserdata
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
            /// Les chips de cette zone de suggestions ont pour destination le centre de l'une des trois zones du dessus.
            getCenterForTarget: function (t) {
                var zone
                if (["city", "country", "location", "latitude", "longitude"].indexOf(
                            t) >= 0)
                    zone = zoneGeoloc
                else if (t === "keywords")
                    zone = zoneUserdata
                else if (["make", "model"].indexOf(t) >= 0)
                    zone = zoneCamera
                else
                    zone = zonePhoto
                return zone.mapToItem(ghostLayer, zone.width / 2,
                                      zone.height / 2)
            }
        }
        ZoneSuggestedTags {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 10
            Layout.rightMargin: 40
            onlyKeywords: true
            txtZone: qsTr("Keywords Suggestions")
            /// Les chips de cette zone de Keywords ont pour destination le centre de zoneUserdata.
            getCenterForTarget: function (t) {
                return zoneUserdata.mapToItem(ghostLayer,
                                              zoneUserdata.width / 2,
                                              zoneUserdata.height / 2)
            }
        }
    }
}
