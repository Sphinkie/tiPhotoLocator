# APIs de reconnaissance de contenu d'image

Pour une future version de TiPhotoLocator, on pourrait brancher une API d'IA sur le bouton
**"More tags..."** (`bt_getinfo` dans `ZoneSuggestedTags`) afin de suggérer automatiquement
des keywords à partir du contenu de la photo.

## Options gratuites

### Hugging Face Inference API
- **Gratuit** sans limite stricte avec un compte gratuit (token d'API requis)
- Modèles utiles :
  - `Salesforce/blip-image-captioning-base` — génère une légende descriptive
  - `openai/clip-vit-base-patch32` — classification
  - `nlpconnect/vit-gpt2-image-captioning` — description en langage naturel
- API REST simple : HTTP POST avec l'image en binaire, réponse JSON
- Compatible avec `Networking.js` existant
- Doc : https://huggingface.co/docs/api-inference/

### Imagga
- **2 000 appels/mois** gratuits
- Spécialisé dans l'auto-tagging : retourne des mots-clés avec scores de confiance
- Idéal pour alimenter directement `SuggestionModel` avec des keywords IPTC
- Doc : https://imagga.com/api-docs/

### Clarifai
- **1 000 appels/mois** gratuits
- Retourne des concepts/tags avec probabilités (scènes, lieux, objets)
- Doc : https://docs.clarifai.com/

### Google Cloud Vision
- **1 000 requêtes/mois** gratuites
- Très complet : labels, OCR, landmarks, faces
- Nécessite une carte bancaire pour l'inscription
- Doc : https://cloud.google.com/vision/docs

## Intégration envisagée

Le point d'entrée naturel est `ZoneSuggestedTags.qml` :

```qml
bt_getinfo.onClicked: {
    /// TODO: appel API reconnaissance image
    /// → résultats injectés dans SuggestionModel via append()
}
```

Les résultats (liste de mots-clés) seraient injectés dans le `SuggestionModel`
avec `target = "keywords"` et `category = "tag"`.
