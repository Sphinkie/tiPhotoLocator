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

    photoKeywords: tabbedPage.currentPhoto ? tabbedPage.currentPhoto.keywords : []

    // Surveillance du changement de photo : remise à zéro des flags.
    property string watchedFilename: tabbedPage.currentPhoto.filename
    onWatchedFilenameChanged: {
        creatorApplied     = false
        countryApplied     = false
        cityApplied        = false
        locationApplied    = false
        descriptionApplied = false
        appliedKeywords    = []
    }

    bt_applyCreator.onClicked: {
        window.applyCreatorToAll()
        creatorApplied = true
    }

    bt_applyCountry.onClicked: {
        window.setPhotoProperty(-1, country, "country") // -1 = all
        countryApplied = true
    }

    bt_applyCity.onClicked: {
        window.setPhotoProperty(-1, city, "city") // -1 = all
        cityApplied = true
    }

    bt_applyLocation.onClicked: {
        window.setPhotoProperty(-1, location, "location") // -1 = all
        locationApplied = true
    }

    bt_applyDescription.onClicked: {
        window.setPhotoProperty(-1, description, "description") // -1 = all
        descriptionApplied = true
    }

    onApplyKeyword: function(keyword) {
        _photoModel.addKeywordToAll(keyword)
        appliedKeywords = appliedKeywords.concat([keyword])
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
