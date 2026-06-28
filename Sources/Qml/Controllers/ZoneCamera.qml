import QtQuick
import "../Vues"
import "../Javascript/TiUtilities.js" as Utilities

/** **********************************************************************************************************
 * @brief Controlleur de la zone avec les informations sur l'appareil ayant fabriqué l'image
 *        (appareil photo ou scanner ou IA).
 * ***********************************************************************************************************/
ZoneCameraForm {

    // On determine le contenu des chips ici, mais ça marche aussi si on le fait dans la vue.
    chipModel.content: tabbedPage.currentPhoto.camModel
    chipMaker.content: tabbedPage.currentPhoto.make
    chipAperture.content: Utilities.toReadableAperture(tabbedPage.currentPhoto.fNumber)
    chipSpeed.content: Utilities.toReadableSpeed(tabbedPage.currentPhoto.shutterSpeed)
    chipSoftware.content: tabbedPage.currentPhoto.software
    chipMetadata.content: tabbedPage.currentPhoto.metadata

    chipSpeed.visible: (tabbedPage.currentPhoto.shutterSpeed > 0)
    chipAperture.visible: (tabbedPage.currentPhoto.fNumber > 0)

    property string camPng: tabbedPage.currentPhoto.camModel
    // URL file:/// de la vignette IA pour le modèle courant ("" si non disponible).
    property string aiUrl: ""

    // -------------------------------------------------------------------
    // Algo : QRC d'abord, puis Cameras_AI sur disque, puis requête API.
    // -------------------------------------------------------------------
    // On interroge le disque de façon proactive (synchrone) à chaque changement de photo,
    // ce qui évite tout "binding loop" : aiUrl est fixé avant que camThumb.source soit évalué.

    /// Renseigne aiUrl avec le filename de la vignette si elle existe (vide sinon).
    // Chemin QRC : nom du modèle sans espaces ni slashes, sous /Cameras/.
    // Géré impérativement dans onCamPngChanged (pas de binding déclaratif),
    // pour garantir que camQrcPath est à jour avant qu'aiUrl déclenche camThumb.source.
    property string camQrcPath: ""

    onCamPngChanged: {
        const normalized = camPng ? camPng.replace(/[\s\\\/]/g, '') : "";
        const qrcCandidate = normalized ? "/Cameras/" + normalized + ".png" : "";
        // On ne charge le QRC que s'il existe réellement, pour éviter le warning Image.Error.
        camQrcPath = (qrcCandidate && _cameraSet.qrcExists(qrcCandidate)) ? qrcCandidate : "";
        aiUrl = (camPng !== "") ? _cameraSet.diskUrl(camPng) : "";
        // Si ni QRC ni cache disque, déclencher directement l'API (évite le passage par Image.Error).
        if (camPng !== "" && camQrcPath === "" && aiUrl === "")
            _cameraSet.append(tabbedPage.currentPhoto.make, camPng);
    }

    // Source : vignette IA (disque ou API) si disponible, sinon QRC.
    camThumb.source: aiUrl !== "" ? aiUrl : camQrcPath

    // Fallback de sécurité : si le chargement échoue malgré tout (fichier corrompu, etc.).
    camThumb.onStatusChanged: {
        if (camThumb.status === Image.Error && camPng !== "" && aiUrl === "")
            _cameraSet.append(tabbedPage.currentPhoto.make, camPng);
    }

    // Mise à jour live si l'utilisateur est encore sur la même photo quand l'API répond.
    Connections {
        target: _cameraSet
        function onThumbnailReady(cam_model, fileUrl) {
            if (cam_model === camPng)
                aiUrl = fileUrl;
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

