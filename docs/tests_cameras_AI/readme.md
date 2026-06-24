# Vignettes d'appareils photo — algorithme

## Vue d'ensemble

À chaque changement de photo, l'appli cherche une vignette illustrant le modèle d'APN.
La recherche suit trois niveaux, du plus rapide au plus lent.

```
Changement de photo
        │
        ▼
  1. Disque (Cameras_AI/) ──── trouvée ──► afficher (file:///)
        │ absente
        ▼
  2. QRC (/Cameras/*.png) ──── chargée ──► afficher
        │ Image.Error
        ▼
  3. API deepai text2img ──── POST ───► GET image ───► sauvegarde disque ───► signal ───► afficher
```

---

## Niveau 1 — cache disque (`CameraSet::diskUrl`)

Appelé de façon **synchrone** dans `onCamPngChanged` (avant toute évaluation de binding).

- Chemin : `%AppData%/TiPhotoLocator/Cameras_AI/<modèle_sans_espaces>.png`
- Si le fichier existe → retourne une URL `file:///...` → stockée dans `aiUrl`
- Sinon → `aiUrl = ""`

## Niveau 2 — ressources embarquées (QRC)

Si `aiUrl` est vide, `camThumb.source` utilise `camQrcPath` :

```
/Cameras/<modèle_sans_espaces>.png
```

Le nom est normalisé (espaces, `\`, `/` supprimés) pour correspondre aux fichiers `.png`
inclus dans le QRC (`Resources/Cameras/`).

Si le chargement réussit (`Image.Ready`) → terminé.

## Niveau 3 — génération par API (`CameraSet::append`)

Déclenché par `camThumb.onStatusChanged` quand `status === Image.Error`
(ni disque ni QRC n'ont fonctionné).

**Étape 1 — POST text2img**
```
POST https://api.deepai.org/api/text2img
body : { text: "Realistic front-view photo of camera <Make> <Model>...", width:320, height:320 }
→ réponse JSON : { "output_url": "https://..." }
```

**Étape 2 — GET image**
```
GET <output_url>
→ image binaire téléchargée
→ sauvegardée dans %AppData%/TiPhotoLocator/Cameras_AI/<modèle>.png
→ signal thumbnailReady(cam_model, fileUrl)
```

Le signal est capté par `Connections { target: _cameraSet }` dans `ZoneCamera.qml` :
si la photo courante est toujours la même, `aiUrl` est mis à jour et la vignette s'affiche.

---

## Cohérence des bindings QML

`camQrcPath` et `aiUrl` sont tous deux mis à jour **impérativement** dans `onCamPngChanged`,
dans cet ordre :

```js
onCamPngChanged: {
    camQrcPath = camPng ? "/Cameras/" + camPng.replace(/[\s\\\/]/g, '') + ".png" : ""
    aiUrl = (camPng !== "") ? _cameraSet.diskUrl(camPng) : ""
}
```

Cet ordre est important : quand la mise à jour d'`aiUrl` déclenche la réévaluation de
`camThumb.source`, `camQrcPath` a déjà la valeur correspondant au **nouveau** modèle.
Sans ça, `camQrcPath` (s'il était un binding déclaratif) pourrait encore contenir
l'ancienne valeur et afficher la vignette du modèle précédent.

---

## Fichiers concernés

| Fichier | Rôle |
|---|---|
| `Sources/Qml/Controllers/ZoneCamera.qml` | Logique de sélection de la source (`aiUrl`, `camQrcPath`, `camThumb`) |
| `Sources/cpp/Models/CameraSet.cpp/.h` | `diskUrl()`, `append()`, requêtes réseau, signal `thumbnailReady` |
| `Resources/Cameras/` | Vignettes embarquées (QRC) |
| `%AppData%/TiPhotoLocator/Cameras_AI/` | Cache disque des vignettes générées par l'API |
