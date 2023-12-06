import QtQuick
import "../Components"
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities


// Controlleur de la zone avec les informations sur la photo
ZonePhotoForm {

    // ------------------------------- DATE
    chipDate.editArea.onClicked:
    {
        // Avec mask  : on peut saisir 99/99/9999 : pas de controle sur les chiffres mais les / sont imposés
        // Avec RegEx : les chiffres sont controlés, on ne peut pas saisir n'importe quoi, mais les / ne sont pas là pour aider
        // Gérer la saisie d'un texte de type DATE
        chipDate.chipText.inputMethodHints = Qt.ImhDate;
        chipDate.chipText.inputMask = "99/99/9999";
        enableEdit(chipDate);
        // FIXME On ne peut sauver que si c'est au bon format
        chipDate.canSave = true // chipDate.chipText.acceptableInput;
    }
    chipDate.saveArea.onClicked:
    {
        var newDateTime = chipDate.chipText.text + " " + chipTime.chipText.text;
        window.setPhotoProperty(tabbedPage.selectedData.row, newDateTime , "dateTimeOriginal");
        //chipDate.chipText.text = fixDate(chipDate)
        resetChipButtons(chipDate);
    }

    // ------------------------------- TIME
    chipTime.editArea.onClicked:
    {
        // Gérer la saisie d'un texte de type TIME
        chipTime.chipText.inputMethodHints = Qt.ImhTime;
        chipTime.chipText.inputMask = "99:99";
        enableEdit(chipTime);
        // TODO: On ne peut sauver que si c'est au bon format
        chipTime.canSave = true // chipTime.chipText.acceptableInput;
    }
    chipTime.saveArea.onClicked:
    {
        var newDateTime = chipDate.chipText.text + " " + chipTime.chipText.text;
        window.setPhotoProperty(tabbedPage.selectedData.row, newDateTime , "dateTimeOriginal");
        // chipTime.chipText.text = fixTime(chipTime)
        resetChipButtons(chipTime);
    }


    // ------------------------------- CREATOR
    chipCreator.editArea.onClicked:
    {
        enableEdit(chipCreator);
        // On active le bouton SAVE
        chipCreator.canSave = true;
    }
    chipCreator.saveArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, chipCreator.chipText.text, "creator");
        // tabbedPage.refreshSelectedData();
        resetChipButtons(chipCreator);
    }
    chipCreator.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "creator");
        // tabbedPage.refreshSelectedData();
        resetChipButtons(chipCreator);
    }

    // ------------------------------- DESCRIPTION
    chipDescription.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "description");
        // tabbedPage.refreshSelectedData();
    }

    chipWriter.deleteArea.onClicked:
    {
        window.setPhotoProperty(tabbedPage.selectedData.row, "", "descriptionWriter");
        // tabbedPage.refreshSelectedData();
    }

    // -----------------------------------------------------------------------------------
    // Connexions
    // -----------------------------------------------------------------------------------
    // On raffraichit la zone si SelectedData est modifiée
    Connections{
        target: tabbedPage
        function onSelectedDataChanged()
        {
            console.log("onSelectedDataChanged->ZonePhoto");
            chipDate.content = Utilities.toStandardDate(tabbedPage.selectedData.dateTimeOriginal)
            chipTime.content = Utilities.toStandardTime(tabbedPage.selectedData.dateTimeOriginal)
            chipCreator.content = tabbedPage.selectedData.creator
            chipDescription.content = tabbedPage.selectedData.description
            chipWriter.content = tabbedPage.selectedData.descriptionWriter
        }
    }

    // -----------------------------------------------------------------------------------
    // Fonctions
    // -----------------------------------------------------------------------------------
    /*!
     * Reactive le bouton Edit (en cas d'édition interrompue par un SUPPR).
     */
    function resetChipButtons(chip)
    {
        // On résactive le bouton EDIT
        chip.editable = true;
        // On désactive le bouton SAVE
        chip.canSave = false;
        // Terminer la saisie du texte
        chip.chipText.readOnly = true;
        chip.chipText.color = TiStyle.chipTextColor;
        chip.chipText.focus = false;
    }

    /*!
     * Active l'édition df'un chip
     */
    function enableEdit(chip)
    {
        // On désactive le bouton EDIT
        chip.editable = false;
        // On gère la saisie d'un texte
        chip.chipText.readOnly = false;
        chip.chipText.color = "white";
        chip.chipText.focus = true;
    }
    /*!
     * Corrige l'heure si besoin (max: 23:59)
     */
    function fixTime(chip)
    {
        var timeValue = chip.chipText.text
        var isValid = /^([0-1][0-9]|2[0-3]):([0-5][0-9])$/.test(timeValue);

        if (isValid) {
          return timeValue;
        }
        else {
            var hours = timeValue.split(':')[0];
            var minutes = timeValue.split(':')[1];

            if (hours.length   < 2) hours = hours.padStart(2,"0");
            if (minutes.length < 2) minutes = minutes.padStart(2,"0");
            if (parseInt(hours)  >23) hours = "23";
            if (parseInt(minutes)>59) minutes = "59";

            return (hours + ":" + minutes)
        }
    }
    /*!
     * Corrige la date si besoin (min: 01/01/1800 - max: 31/12/2239)
     */
    function fixDate(chip)
    {
        var dateValue = chip.chipText.text
        var isValid = /^(0[1-9]|[12][0-9]|3[01])[\/](0[1-9]|1[012])[\/](18|19|20)\d\d$/.test(dateValue);

        if (isValid) {
          return dateValue;
        }
        else {
            var day   = dateValue.split('/')[0];
            var month = dateValue.split('/')[1];
            var year  = dateValue.split('/')[2];

            if (day.length   < 2) day = day.padStart(2,"0");
            if (month.length < 2) month = month.padStart(2,"0");
            if (year.length  < 4) year = year.padStart(4,"0");

            if (parseInt(day)  < 1)  day = "01";
            if (parseInt(day)  > 31) day = "30";
            if (parseInt(month) < 1)  month = "01";
            if (parseInt(month) > 12) month = "12";
            if (parseInt(year) < 1800) year = "1800";
            if (parseInt(year) > 2222) year = "2239";

            return (day + "/" + month + "/" + year)
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
