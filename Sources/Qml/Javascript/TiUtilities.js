.pragma library


/** ***************************************************************************************
 * @page Library of misc javascript utilities usable in QML.
 * ****************************************************************************************/


/** ***************************************************************************************
 * @brief Normalise une URL de dossier pour que Qt.labs.folderlistmodel puisse la lire.
 * Pour les chemins UNC, Qt.labs.platform.FolderDialog retourne "file://serveur/chemin"
 * (serveur dans la partie host), que FolderListModel rejette (isLocalFile() = false).
 * On la convertit en "file:////serveur/chemin" (host vide, chemin UNC dans le path).
 * @param url: URL de type "file://serveur/chemin" ou "file:///C:/chemin"
 * @return URL normalisée utilisable par FolderListModel
 * ****************************************************************************************/
function normalizeUrl(url) {
    let str = url.toString()
    if (/^file:\/\/[^\/]/.test(str))
        str = "file:////" + str.substring(7)
    return str
}


/** ***************************************************************************************
 * @brief Transforme un chemin en format Windows "C:\Users\David\Pictures".
 * Par exemple: `file:///E:/TiPhotos` ou `file://nas/photo/1997/1997 Sicile`
 * @param objet: un chemin au format "file:///C:/Users/David/Pictures"
 * @return un chemin au format "C:\Users\David\Pictures"
 * ****************************************************************************************/
function toStandardPath(objet) {
    let texte = objet.toString()
    if (texte.length > 8) {
        texte = texte.replace("file:", "") // retire "file:"
        texte = texte.replace(
                    /^\/\/\/\//,
                    "//") // file:////server → //server (UNC 4 slashes → 2)
        texte = texte.replace(/^\/\/\/([^\/])/,
                              "$1") // file:///C:/ → C:/ (chemin local)
        texte = texte.replace(/\//g, "\\") // remplace tous les / par des \
    }
    // console.log(texte);
    return texte
}


/** ***************************************************************************************
 * @brief Transforme un chemin en un texte court (24 char max) pour qu'on puisse lire le
 * début (lecteur) et la fin dans le popup qui est assez étroit.
 * Par exemple: `file:///E:/photo/1997/1997-09 Sicile` devient `E:...1997-09 Sicile`
 * @param objet: un chemin au format "file:///C:/Users/David/Pictures"
 * @return un chemin court au format "C:\...id\Pictures"
 * ****************************************************************************************/
function toShortPath(objet) {
    // On passe le texte au format Windows
    let texte = toStandardPath(objet)
    // on raccourcit le texte
    let len = texte.length
    let result = texte
    if (len > 21) {
        if (texte.startsWith("\\\\")) {
            // Chemin UNC: on garde \\serveur jusqu'au premier \ suivant
            let serverEnd = texte.indexOf("\\", 2)
            let prefix = serverEnd > 0 ? texte.slice(
                                             0, serverEnd) : texte.slice(0, 10)
            result = prefix + "..." + texte.slice(len - 17)
        } else {
            result = texte.slice(0, 3) + "..." + texte.slice(len - 17)
        }
    }
    return result
}


/** ***************************************************************************************
 * @brief Transforme une date du type "YYYY-MM-DD HH:MM:SS" en "DD/MM/YYYY"
 * @param objet: une date du type "YYYY-MM-DD HH:MM:SS"
 * @param sep: (optionel) Le séparateur à utiliser dans le résultat
 * @return une date au format "DD<sep>MM<sep>YYYY"
 * ****************************************************************************************/
function toReadableDate(objet, sep = "/") {
    let texte = objet.toString()
    if (texte.length > 10) {
        let groups = texte.split(/-|\:|\s|\+/)
        // 4 séparateurs: '-', ':', 'space' et '+'
        texte = groups[2] + sep + groups[1] + sep + groups[0]
        // console.log(groups);
    }
    // console.log(texte);
    return texte
}


/** ***************************************************************************************
 * @brief Transforme une date du type "YYYY-MM-DD HH:MM:SS" en "HH:MM"
 * @param objet: une date du type "YYYY-MM-DD HH:MM:SS"
 * @return une heure au format "HH:MM"
 * ****************************************************************************************/
function toReadableTime(objet) {
    let texte = objet.toString()
    if (texte.length > 16) {
        let groups = texte.split(/-|\:|\s|\+/)
        // 4 séparateurs: '-', ':', 'space' et '+'
        texte = groups[3] + ":" + groups[4]
    }
    return texte
}


/** ***************************************************************************************
 * @brief Arrondit la vitesse de déclenchement à une valeur lisible standard.
 * Pour la vitesse, on veut une valeur plus lisible.
 * @param valeur: la metadata shutterspeed de l'image (par ex: 0.019999999552965164 ou 0.3333333432674408)
 * @return Une valeur lisible (par ex: "1/50 s" ou "1/3 s")
 * ****************************************************************************************/
function toReadableSpeed(valeur) {
    if (valeur === undefined)
        return ""
    else if (valeur === 0)
        return ""
    else if (valeur > 1)
        return Math.floor(valeur)
    else if (valeur < 0.01)
        // au dela de 100, on arrondit au centième.
        valeur = 100 * Math.round(1 / (valeur * 100))
    else if (valeur < 0.1)
        // au dela de 10, on arrondit au dizième.
        valeur = 10 * Math.round(1 / (valeur * 10))
    else if (valeur < 1)
        // au dela de 10, on arrondit.
        valeur = Math.round(1 / (valeur))
    // Sécurité: si résultat undefined ou infinite, on ne renvoie rien
    if (valeur === undefined || !isFinite(valeur)) {
        return ""
    }
    return ("1 / " + valeur + " s")
}


/** ***************************************************************************************
 * @brief Arrondit l'ouverture focale à une valeur lisible standard.
 * @param valeur: la metadata fNumber de l'image (par ex: 3.587)
 * @return Une valeur lisible (par ex: "ƒ 3.5")
 * ****************************************************************************************/
function toReadableAperture(valeur) {
    if (valeur === undefined)
        return ""
    else if (valeur === 0)
        return ""
    else if (!isFinite(valeur))
        return ""
    else
        return "ƒ " + valeur.toFixed(1)
}


/** ***************************************************************************************
 * @brief Evite les valeus abbérentes.
 * @param width: largeur de l'image remontée par l'OS
 * @param height: hauteur de l'image remontée par l'OS
 * @return Une valeur lisible (par ex: "3200 x 4000")
 * ****************************************************************************************/
function toReadableSize(width, height) {
    if ((width === undefined) || (height === undefined))
        return ""
    else if ((width === 0) || (height === 0))
        return ""
    else if (!isFinite(width) || !isFinite(height))
        return ""
    else
        return width + " x " + height
}
