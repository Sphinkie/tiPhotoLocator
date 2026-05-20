import QtQuick
import QtQuick.Layouts
import ".."


/** **********************************************************************************************************
 * @brief QML: Liste des filenames des photos, associée au modèle filtré SelectedPhotoProxyModel.
 * Ce modèle est basé sur PhotoModel, filtré pour afficher toutes photos, ou uniquement celles sélectionnées.
 * @sa https://www.youtube.com/watch?v=ZArpJDRJxcI
 * ***********************************************************************************************************/
ListView {
    anchors.fill: parent
    model: _selectedPhotoProxyModel
    delegate: listDelegate
    focus: true
    clip: true // pour que les items restent à l'intérieur de la listview
    // Déplacement rapide du highlight: en 0.5 secondes max
    highlightMoveDuration: 500
    highlightMoveVelocity: -1


    /** ******************************************************************************************************
     * Une ligne en bas de la listview
     * *******************************************************************************************************/
    footer: Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "darkgrey"
    }


    /** ******************************************************************************************************
     * Background de l'item courant. (@see property ListView.highlightFollowsCurrentItem).
     * *******************************************************************************************************/
    highlight: Rectangle {
        Layout.fillWidth: true
        color: Style.highlightBackgroundColor
        radius: 6
    }


    /** ******************************************************************************************************
     * Timer de 4 secondes avant envoi d'une request pour récupérer des infos à partir des coordonnées GPS
     * de la photo courante.
     * Ce timer est déclenché par le clic sur un item de la liste.
     * *******************************************************************************************************/
    Timer {
        id: geoTimer
        interval: 4000
        running: false
        repeat: false
        onTriggered: {
            // console.debug(">>>>> timer triggered")
            window.requestReverseGeocode(
                        _photoModel.currentItemCoords.latitude,
                        _photoModel.currentItemCoords.longitude)
        }
    }


    /** ******************************************************************************************************
     * Navigation clavier dans la liste.
     * *******************************************************************************************************/
    Keys.onPressed: event => {
                        let target = currentIndex
                        if (event.key === Qt.Key_Up)
                        target = Math.max(0, currentIndex - 1)
                        else if (event.key === Qt.Key_Down)
                        target = Math.min(count - 1, currentIndex + 1)
                        else if (event.key === Qt.Key_Home)
                        target = 0
                        else if (event.key === Qt.Key_End)
                        target = count - 1
                        else
                        return

                        event.accepted = true
                        navigateTo(target)
                    }

    function navigatePrev() {
        navigateTo(Math.max(0, currentIndex - 1))
    }
    function navigateNext() {
        navigateTo(Math.min(count - 1, currentIndex + 1))
    }

    function navigateTo(target) {
        currentIndex = target
        positionViewAtIndex(target, ListView.Contain)
        var sourceIdx = model.getSourceIndex(target)
        var photo = _photoModel.get(sourceIdx)
        if (photo && !photo.isMarker)
            activatePhoto(target, photo.hasGPS, photo.city, photo.country,
                          photo.latitude, photo.longitude)
    }


    /** ******************************************************************************************************
     * Le delegate pour afficher la ListModel dans la ListView.
     * *******************************************************************************************************/
    Component {
        id: listDelegate
        Item {
            id: wrapper
            height: 30
            width: photoListView.width
            // Avec les required properties dans un delegate, on indique qu'il faut utiliser les roles du modèle
            required property string filename
            required property string city
            required property string country
            required property double latitude
            required property double longitude
            required property bool hasGPS
            required property bool insideCircle
            required property bool toBeSaved
            required property bool isMarker
            required property bool isSelected
            required property int index
            // index is a special role available in the delegate: the row of the item in the model.
            readonly property ListView __lv: ListView.view

            visible: !isMarker // On n'affiche pas la "Saved Position"


            /** **********************************************************************************************
             * icone "In Circle".
             * ***********************************************************************************************/
            Image {
                id: circleIcon
                anchors.left: parent.left
                visible: insideCircle
                source: "qrc:///Images/circle-red.png"
                height: 24
                width: 24
            }


            /** **********************************************************************************************
             * icone "Has GPS".
             * ***********************************************************************************************/
            Image {
                id: gpsIcon
                anchors.left: circleIcon.right
                visible: hasGPS
                source: "qrc:///Images/mappin-red.png"
                height: 24
                width: 24
            }


            /** **********************************************************************************************
             * Filename de l'image.
             * ***********************************************************************************************/
            Text {
                id: nameText
                anchors.left: gpsIcon.right
                text: filename
                font.pixelSize: 16
                font.bold: isSelected ? true : false
                color: toBeSaved ? Style.accentTextColor : Style.primaryTextColor
            }


            /** **********************************************************************************************
             * Tag City avec le nom de la ville associée.
             * ***********************************************************************************************/
            TinyChip {
                id: cityText
                anchors.left: nameText.right
                anchors.leftMargin: 8
                content: city
                editable: false
                deletable: false
                height: 20
            }


            /** **********************************************************************************************
             * Gestion du clic sur un item de la liste.
             * ***********************************************************************************************/
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouse => {
                               if (mouse.button === Qt.LeftButton) {
                                   __lv.forceActiveFocus()
                                   // Définit l'item courant de la ListView et positionne le highlight.
                                   __lv.currentIndex = index
                                   activatePhoto(index, hasGPS, city, country,
                                                 latitude, longitude)
                                   // On relance une demande d'infos ReverseGeo,
                                   // si onglet MAP et COORDS GPS et s'il n'y a pas déjà de City ni Country:
                                   if ((tabbedPage.currentIndex === 1) && hasGPS
                                       && city === "" && country === "") {
                                       // console.debug(">>>> restart geoTimer")
                                       geoTimer.restart()
                                   } else
                                   geoTimer.stop()
                               } // CLICK DROIT:
                               else {
                                   var sourceindex = model.getSourceIndex(index)
                                   // Si la photo est déjà sélectionnée, on la désélectionne.
                                   if (isSelected) {
                                       _photoModel.removeFromSelection(
                                           sourceindex)
                                   } // Sinon,on la sélectionne:
                                   else {
                                       _photoModel.addToSelection(sourceindex)
                                       // et on ajoute ses tags aux suggestions courantes.
                                       _photoModel.suggestFromPhoto(sourceindex)
                                   }
                               }
                           }
            }
        }
    }


    /** **********************************************************************************************************
     * @brief Active la photo sélectionnée (Preview, imagette, tags, et pinpoint géographique).
     * Cette fonction est appelée quand on clique sur un item de listView,
     * @param pos : La position de la photo dans la listView.
     * @param hasGPS : La propriété hasGPS de la photo.
     * @param city : La propriété city de la photo.
     * @param country : La propriété country de la photo.
     * @param latitude : La propriété latitude de la photo.
     * @param longitude : La propriété longitude de la photo.
     * ***********************************************************************************************************/
    function activatePhoto(pos, hasGPS, city, country, latitude, longitude) {
        var sourceindex = model.getSourceIndex(pos)
        _photoModel.currentItemRow = sourceindex // Actualise le PhotoModel
        // La photo courante est forcement sélectionée, mais de façon exclusive.
        _photoModel.addToSelection(sourceindex, true)

        // On mémorise dans currentPhoto les data de l'item selectionné du modèle.
        // Cela permet de se passer de ProxyModel dans les onglets qui n'utilisent les data que d'un seul item.
        tabbedPage.currentPhoto = _photoModel.get(sourceindex)

        // On envoie les coordonnées pour centrer la carte et le cercle sur le point sélectionné,
        // sinon (if not has GPS) la position de la carte reste inchangée.
        if (hasGPS) {
            var coords = _photoModel.currentItemCoords
            if (!mapTab.mapView.visibleRegion.contains(coords)) {
                mapTab.mapView.center = coords
            }
            mapTab.mapView.mapCircle.center = coords
        }

        // On change le filtrage des suggestions pour filtrer uniquement sur la photo active
        window.setSuggestionFilter(sourceindex)

        // On réactualise le contenu du cercle rouge
        // TODO : C'est consommateur car on parcourt toutes les photos du modèle à chaque clic!
        _photoModel.findInCirclePhotos()
    }
}
