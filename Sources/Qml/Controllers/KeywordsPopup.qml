import QtQuick
import "../Vues"


/** **********************************************************************************************************
 * @brief Controller du popup de gestion des keywords utilisateur.
 * *********************************************************************************************************** */
KeywordsPopupForm {
    id: keywordsPopup

    /// Chargement des infos à l'ouverture du popup
    onOpened: {
        loadPredefinedKeywords()
        customModel.clear()
        newChip.visible = false
        var parts = settings.customKeywords.split(",")
        for (var i = 0; i < parts.length; i++) {
            var k = parts[i].trim()
            if (k !== "")
                customModel.append({
                                       "kw": k,
                                       "editing": false
                                   })
        }
    }

    /// Lecture des keywords prédéfinis depuis le fichier de ressources
    function loadPredefinedKeywords() {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE)
                predefinedKeywords = xhr.responseText.split("\n").map(
                            k => k.trim()).filter(k => k !== "")
        }
        var lang = settings.tagLanguage === 0 ? "eng" : "fre"
        xhr.open("GET", "qrc:/Keywords/keywords." + lang)
        xhr.send()
        console.log("xhr", xhr.toString())
    }

    /// Gestion des chips existants
    onEditRequested: index => customModel.setProperty(index, "editing", true)
    onRevertRequested: index => customModel.setProperty(index, "editing", false)

    /// Reception du signal saveRequested
    onSaveRequested: function (index, value) {
        var v = value.trim()
        if (v !== "")
            customModel.setProperty(index, "kw", v)
        customModel.setProperty(index, "editing", false)
        persistCustomKeywords()
    }

    // Réception du signal deleteRequested
    onDeleteRequested: function (index) {
        customModel.remove(index)
        persistCustomKeywords()
    }

    /// Gestion du bouton "Ajoute nouveau keyword"
    addButton.onClicked: {
        newChip.chipText.text = ""
        newChip.visible = true
        newChip.chipText.forceActiveFocus()
    }

    /// Réception du signal addConfirmed
    onAddConfirmed: function (value) {
        if (value.trim() !== "" && customModel.count < 12) {
            customModel.append({
                                   "kw": value.trim(),
                                   "editing": false
                               })
            persistCustomKeywords()
        }
        newChip.visible = false
    }

    /// Réception du signal addCancelled
    onAddCancelled: newChip.visible = false

    /// Fermeture du popup
    closeButton.onClicked: close()

    /// Persistance: fonction pour conserver les nouveaux keywords dans les settings.
    function persistCustomKeywords() {
        var list = []
        for (var i = 0; i < customModel.count; i++)
            list.push(customModel.get(i).kw)
        settings.customKeywords = list.join(",")
    }
}
