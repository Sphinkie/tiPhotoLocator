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
- Démo : https://huggingface.co/spaces/yunusserhat/Location_Predictor  (pin on map +/- 30km)
- Démo : https://huggingface.co/spaces/geolocation87/geolocation (donne 5 coords par ordre de probabilité)
- API Option: Call the Space directly via API ⭐ (Easiest). Most Spaces expose an API endpoint. You can make API calls directly to it:
```python
import requests

response = requests.post(
  "https://huggingface.co/spaces/geolocation87/geolocation/api/predict",
  json={"data": ["your_image_url"]}
)
result = response.json()
```
- API : https://huggingface.co/nlpconnect/vit-gpt2-image-captioning
- Démo : https://huggingface.co/openai/clip-vit-base-patch32



### Imagga
- **2 000 appels/mois** gratuits
- Spécialisé dans l'auto-tagging : retourne des mots-clés avec scores de confiance
- Idéal pour alimenter directement `SuggestionModel` avec des keywords IPTC
- Doc : https://imagga.com/api-docs/
- Démo : https://demo.imagga.com/tagging-v2 (fonctionne assez bien pour les 3 premiers keywords, mais me parait redondant avec LibrePhotos)

### Clarifai
- **1 000 appels/mois** gratuits
- Retourne des concepts/tags avec probabilités (scènes, lieux, objets)
- Doc : https://docs.clarifai.com/
- Démo : https://demo-embed.clarifai.com/  (invalid key !)

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
