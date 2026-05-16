import QtQuick
import QtCore
import "../Vues"


/** *************************************************************************************
 * @brief Zone avec les tags IPTC pouvant être appliqués à toutes les photos du dossier.
 * *************************************************************************************/
ZoneIptcForm {
    id: iptcZone
    property string creator
    property string writer
    property string city: tabbedPage.currentPhoto.city
    property string country: tabbedPage.currentPhoto.country
    property string location: tabbedPage.currentPhoto.location
    property string description: tabbedPage.currentPhoto.description

    bt_applyCreator.onClicked: {
        window.applyCreatorToAll()
    }

    bt_applyCountry.onClicked: {
        window.setPhotoProperty(-1, country, "country") // -1 = all
    }

    bt_applyCity.onClicked: {
        window.setPhotoProperty(-1, city, "city") // -1 = all
    }

    bt_applyLocation.onClicked: {
        window.setPhotoProperty(-1, location, "location") // -1 = all
    }

    bt_applyDescription.onClicked: {
        window.setPhotoProperty(-1, description, "description") // -1 = all
    }

    bt_applyKeyword.onClicked: {
        window.setPhotoProperty(-1, keywords, "keyword") // -1 = all
    }

    // ----------------------------------------------------------------
    /// Lecture des Settings
    // ----------------------------------------------------------------
    Settings {
        id: settings
        property alias photographe: iptcZone.creator
        property alias initiales: iptcZone.writer
    }
}
