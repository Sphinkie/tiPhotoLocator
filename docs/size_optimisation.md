# Techniques d'optimisation de la taille des programmes en QML

## Option `--exclude-plugins` expliquée en détail

### Syntaxe

L'option `--exclude-plugins` accepte une liste (séparée par des virgules) de plugins individuels qui ne seront pas déployés. Par exemple : `--exclude-plugins qsvg,qpdf`

```bash
windeployqt.exe --qmldir <path-to-qml> --exclude-plugins qsvg,qpdf,qico MyApp.exe
```

### Comment ça fonctionne

Normalement, `windeployqt` scanne votre application et déploie **tous** les plugins qu'il pense être nécessaires. 
L'option `--exclude-plugins` vous permet d'exclure certains plugins que vous êtes sûr de **ne pas utiliser**.

### Exemples de plugins à exclure

Voici les plugins les plus courants que vous pouvez potentiellement exclure :

**Formats d'image** (dossier `imageformats/`) :
- `qsvg` - Support SVG (exclure si vous n'utilisez pas d'images SVG)
- `qpdf` - Support PDF (exclure si vous ne lisez pas de PDF)
- `qtiff` - Support TIFF (exclure si vous n'utilisez pas ce format)
- `qwebp` - Support WebP (exclure si vous n'en avez pas besoin)
- `qico`, `qicns` - Icônes (généralement sûr à exclure)
- `qtga`, `qwbmp` - Formats rares (généralement sûrs à exclure)

**Moteurs d'icônes** (dossier `iconengines/`) :
- `qsvgicon` - Icons SVG (exclure si vous n'utilisez que PNG)

**Important** : Pour chaque type d'image que vous utilisez dans votre app, vous avez besoin du plugin correspondant. 
Par exemple, si vous utilisez des JPG, gardez `qjpeg`.

### Stratégie de suppression sûre

1. Identifiez ce que vous utilisez **réellement** dans votre app QML
   - Images PNG/JPG → `qjpeg`, `qgif` (garder)
   - Images SVG → `qsvg` (garder si vous les utilisez)
   - PDF → `qpdf` (exclure si vous ne lisez pas de PDF)
   - D'autres formats → À évaluer

2. Testez progressivement:
```bash
# Test 1 : exclure les formats rares
windeployqt.exe --qmldir qml --exclude-plugins qtga,qwbmp,qico,qicns MyApp.exe

# Test 2 : si OK, exclure plus
windeployqt.exe --qmldir qml --exclude-plugins qtga,qwbmp,qico,qicns,qsvgicon MyApp.exe

# Test 3 : si vous n'utilisez pas SVG
windeployqt.exe --qmldir qml --exclude-plugins qtga,qwbmp,qico,qicns,qsvg,qsvgicon MyApp.exe
```

3. Vérifiez que votre app fonctionne à chaque étape


### Autres options complémentaires

Pour une meilleure réduction de taille, combinez avec d'autres options :

```bash
windeployqt.exe ^
  --qmldir <path-to-qml> ^
  --release ^
  --no-translations ^
  --no-compiler-runtime ^
  --exclude-plugins qtga,qwbmp,qico,qicns,qsvgicon ^
  MyApp.exe
```

- `--no-translations` : évite les fichiers de langue
- `--no-compiler-runtime` : évite les DLL du compilateur (vous les fournissez via un redistributable)


### Gains attendus

Si vous éliminez intelligemment les plugins inutiles, vous pouvez économiser **10-20 MB** sur les 80 MB.  
C'est modeste mais utile si chaque MB compte.