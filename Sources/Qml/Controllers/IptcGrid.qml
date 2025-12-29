import QtQuick
import QtCore
import "../Vues"

IptcGridForm {
    id: iptcGrid
    property string creator
    property string writer
    property string city : tabbedPage.selectedData.city
    property string country : tabbedPage.selectedData.country

    bt_applyCreator.onClicked: {
        window.applyCreatorToAll();
    }

    bt_applyCountry.onClicked: {
        window.setPhotoProperty(-1, country, "country");  // -1 = all
    }

    bt_applyCity.onClicked: {
        window.setPhotoProperty(-1, city, "city");       // -1 = all
    }

    // ----------------------------------------------------------------
    // Lecture des Settings
    // ----------------------------------------------------------------
    Settings {
        id: settings
        property alias photographe: iptcGrid.creator
        property alias initiales: iptcGrid.writer
    }




}
