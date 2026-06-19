import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Components"


/** *************************************************************************************************
 * @brief Vue de l'onglet avec les tags pouvant être appliqués à toutes les photos du dossier.
 * *************************************************************************************************/
Zone {
    id: zoneRoot
    // Aliases vers les GlobalTag (pour branchement des signaux dans le contrôleur)
    property alias tagCreator:     tagCreator
    property alias tagCountry:     tagCountry
    property alias tagCity:        tagCity
    property alias tagLocation:    tagLocation
    property alias tagDateTime:    tagDateTime
    property alias tagDescription: tagDescription

    // Données keywords
    property var    photoKeywords:  []
    property var    appliedKeywords: []

    // Valeur formatée de la date (calculée dans le contrôleur)
    property string dateTimeFormatted: ""

    // Latches "Apply to all déjà cliqué" — remis à false par le contrôleur au changement de photo
    property bool creatorApplied:     false
    property bool countryApplied:     false
    property bool cityApplied:        false
    property bool locationApplied:    false
    property bool descriptionApplied: false
    property bool dateTimeApplied:    false

    // Nombre de photos sélectionnées — à alimenter depuis le contrôleur
    property int selectionCount: 1

    // Signal pour appliquer un keyword à toutes les photos / à la sélection
    signal applyKeyword(string keyword)
    signal applyKeywordToSelection(string keyword)

    iconZone: "qrc:/Images/icon-tag.png"
    txtZone: title + br + brief + br + usage1 + br + note1 + br + usage2 + br + note2 + br
    color: Style.suggestionBackgroundColor

    readonly property string br:     "<br>"
    readonly property string title:  qsTr("<b>EXIF and IPTC tags</b>")
    readonly property string brief:  "<i>EXchangeable Image Fileformat</i> & <i>International Press Telecom Council</i>"
    readonly property string usage1: qsTr("IPTC tags mainly contain editorial information, usually manually filled:")
    readonly property string note1:  qsTr("(image description, etc)")
    readonly property string usage2: qsTr("EXIF tags are defined at the moment of the shot.")
    readonly property string note2:  qsTr("They mainly contain technical information: camera model, lens...")


    ColumnLayout {
        width: parent.width
        spacing: 0

        GlobalTag {
            id: tagCreator
            tagName: "artist:"
            content: creator
            tagDescription: qsTr("Photographer name.")
            applied: creatorApplied
            selectionCount: zoneRoot.selectionCount
        }

        GlobalTag {
            id: tagCountry
            tagName: "country:"
            chipCategory: "geo"
            content: country
            tagDescription: qsTr("The country where the photo was taken.")
            applied: countryApplied
            selectionCount: zoneRoot.selectionCount
        }

        GlobalTag {
            id: tagCity
            tagName: "city:"
            chipCategory: "geo"
            content: city
            tagDescription: qsTr("City where the photo was taken or nearest city.")
            applied: cityApplied
            selectionCount: zoneRoot.selectionCount
        }

        GlobalTag {
            id: tagLocation
            tagName: "location:"
            chipCategory: "geo"
            content: location
            tagDescription: qsTr("Additionnal geographical information.")
            applied: locationApplied
            selectionCount: zoneRoot.selectionCount
        }

        GlobalTag {
            id: tagDateTime
            tagName: "date:"
            content: dateTimeFormatted
            tagDescription: qsTr("Date and time when the photo was taken.")
            applied: dateTimeApplied
            selectionCount: zoneRoot.selectionCount
        }

        GlobalTag {
            id: tagDescription
            tagName: "description:"
            content: description
            tagDescription: qsTr("Photo content description: who, where, how, why? (in a few words).")
            applied: descriptionApplied
            selectionCount: zoneRoot.selectionCount
        }

        // -- ---------------------------------------------------------------
        /// Tags "keywords" (avec Repeater) — une ligne par keyword existant
        // -- ---------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            ColumnLayout {
                spacing: 0
                KeywordsRepeater {
                    id: keywordsRepeater
                }
            }

            Label {
                id: lb_keywords
                Layout.fillWidth: true
                visible: photoKeywords.length > 0
                text: qsTr("A list of keywords, related to the photo and used for searches.")
                wrapMode: Text.Wrap
            }
        }
    }
}
