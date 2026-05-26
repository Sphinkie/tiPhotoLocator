import QtQuick
import QtCore
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities


/** *************************************************************************************
 * @brief Zone avec les tags pouvant être appliqués globalement à toutes les photos du dossier.
 * *************************************************************************************/
ZoneGlobalTagsForm {
    id: globalTagsZone
    property string creator
    property string writer
    property string city:        tabbedPage.currentPhoto.city
    property string country:     tabbedPage.currentPhoto.country
    property string location:    tabbedPage.currentPhoto.location
    property string description: tabbedPage.currentPhoto.description
    property string dateTimeOriginal: tabbedPage.currentPhoto.dateTimeOriginal

    dateTimeFormatted: dateTimeOriginal ? Utilities.toReadableDate(dateTimeOriginal) + " " + Utilities.toReadableTime(dateTimeOriginal) : ""

    photoKeywords: tabbedPage.currentPhoto ? tabbedPage.currentPhoto.keywords : []
    selectionCount: _photoModel.selectionCount

    // Surveillance du changement de photo : remise à zéro des flags.
    property string watchedFilename: tabbedPage.currentPhoto.filename
    onWatchedFilenameChanged: {
        creatorApplied     = false
        countryApplied     = false
        cityApplied        = false
        locationApplied    = false
        descriptionApplied = false
        dateTimeApplied    = false
        appliedKeywords    = []
    }

    // -----------------------------------------------------------------------------------
    // APPLY TO ALL
    // -----------------------------------------------------------------------------------
    tagCreator.onApplyAll: {
        window.applyCreatorToAll()
        creatorApplied = true
    }
    tagCountry.onApplyAll: {
        window.setPhotoProperty(-1, country, "country")
        countryApplied = true
    }
    tagCity.onApplyAll: {
        window.setPhotoProperty(-1, city, "city")
        cityApplied = true
    }
    tagLocation.onApplyAll: {
        window.setPhotoProperty(-1, location, "location")
        locationApplied = true
    }
    tagDateTime.onApplyAll: {
        window.setPhotoProperty(-1, dateTimeFormatted, "dateTimeOriginal")
        dateTimeApplied = true
    }
    tagDescription.onApplyAll: {
        window.setPhotoProperty(-1, description, "description")
        descriptionApplied = true
    }

    // -----------------------------------------------------------------------------------
    // APPLY TO SELECTION
    // -----------------------------------------------------------------------------------
    tagCreator.onApplyToSelection: {
        window.applyCreatorToSelection()
    }
    tagCountry.onApplyToSelection: {
        window.setPhotoProperty(-4, country, "country")
    }
    tagCity.onApplyToSelection: {
        window.setPhotoProperty(-4, city, "city")
    }
    tagLocation.onApplyToSelection: {
        window.setPhotoProperty(-4, location, "location")
    }
    tagDateTime.onApplyToSelection: {
        window.setPhotoProperty(-4, dateTimeFormatted, "dateTimeOriginal")
    }
    tagDescription.onApplyToSelection: {
        window.setPhotoProperty(-4, description, "description")
    }

    // -----------------------------------------------------------------------------------
    // KEYWORDS
    // -----------------------------------------------------------------------------------
    onApplyKeyword: function (keyword) {
        _photoModel.addKeywordToAll(keyword)
        appliedKeywords = appliedKeywords.concat([keyword])
    }

    // ----------------------------------------------------------------
    /// Lecture des Settings
    // ----------------------------------------------------------------
    Settings {
        id: settings
        property alias photographe: globalTagsZone.creator
        property alias initiales:   globalTagsZone.writer
    }
}
