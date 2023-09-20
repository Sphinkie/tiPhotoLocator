import QtQuick 2.15

// ----------------------------------------------------------------
// Modèles de donnees
// ----------------------------------------------------------------

// ----------------------------------------------------------------
// Ce modele contient la liste des éléments de la listView
// ----------------------------------------------------------------
ListModel {

    // Initialisation des roles
    ListElement {
        name: qsTr("Select your photo folder")
        imageUrl: "qrc:///Images/ibiza.png"
        isDirty: false      // true if one of the following fields has been modified
        latitude: 38.980    // GPS coordinates
        longitude: 1.433    // (Ibiza)
        hasGPS: false       // has GPS coordinates
        nearSelected: false // inside the radius of nearby photos
    }

}
