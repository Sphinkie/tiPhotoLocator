# APIs de reconnaissance de contenu d'image

Intégration dans TiPhotoLocator d'une API d'IA liée au bouton **"More tags..."** (`bt_getinfo` dans `ZoneSuggestedTags`) pour suggérer automatiquement
des keywords, ou liée à un bouton **"ask where..."** pour essayer de reconnaitre le lieu de la photo.


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
- Démo : https://huggingface.co/spaces/yunusserhat/Location_Predictor  (donne des coordonnées mais peu précises: +/- 30km)
- Démo : https://huggingface.co/spaces/geolocation87/geolocation (donne 5 coords par ordre de probabilité)
- Démo : https://huggingface.co/openai/clip-vit-base-patch32
- API : https://huggingface.co/nlpconnect/vit-gpt2-image-captioning
- API : https://huggingface.co/akjen/GeoLocations_5 : A model to predict the latitude and longitude of an image (peu d'infos sur leur site sur l'API)

- API: call the *Space* directly via API (most *Spaces* expose an API endpoint).
  Example of API POST call:
```python
import requests

response = requests.post(
  "https://huggingface.co/spaces/geolocation87/geolocation/api/predict",
  json={"data": ["your_image_url"]}
)
result = response.json()
```


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


