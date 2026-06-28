# Transformer un JPEG fond blanc en PNG fond transparent (Qt/C++)

L'approche consiste à parcourir les pixels de l'image et remplacer les pixels blancs
(ou proches du blanc) par des pixels transparents.

---

## Méthode principale avec `QImage`

```cpp
#include <QImage>
#include <QColor>

QImage convertWhiteToTransparent(const QString &inputPath, int threshold = 240)
{
    QImage src(inputPath);
    if (src.isNull())
        return {};

    // Convertir en ARGB32 pour supporter la transparence
    QImage result = src.convertToFormat(QImage::Format_ARGB32);

    for (int y = 0; y < result.height(); ++y) {
        for (int x = 0; x < result.width(); ++x) {
            QColor color = result.pixelColor(x, y);

            // Si le pixel est "blanc" (tous les canaux > threshold)
            if (color.red()   >= threshold &&
                color.green() >= threshold &&
                color.blue()  >= threshold)
            {
                result.setPixelColor(x, y, Qt::transparent);
            }
        }
    }

    return result;
}
```

### Utilisation et sauvegarde en PNG

```cpp
QImage transparent = convertWhiteToTransparent("/path/to/image.jpg", 240);

if (!transparent.isNull())
    transparent.save("/path/to/output.png", "PNG");
```

---

## Variante avec alpha progressif (anti-aliasing)

Pour éviter les bords crénelés, on peut rendre le pixel semi-transparent
en fonction de sa luminosité :

```cpp
QImage convertWithSoftEdges(const QImage &src)
{
    QImage result = src.convertToFormat(QImage::Format_ARGB32);

    for (int y = 0; y < result.height(); ++y) {
        for (int x = 0; x < result.width(); ++x) {
            QColor c = result.pixelColor(x, y);

            // Luminosité perceptuelle (0.0 = noir, 1.0 = blanc)
            double luminance = 0.299 * c.red()
                             + 0.587 * c.green()
                             + 0.114 * c.blue();

            // Alpha inversement proportionnel à la luminosité
            int alpha = qBound(0, 255 - static_cast<int>(luminance), 255);
            c.setAlpha(alpha);
            result.setPixelColor(x, y, c);
        }
    }

    return result;
}
```

---

## Intégration côté QML

### Exposition de la fonction au QML

**imageprocessor.h**

```cpp
class ImageProcessor : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE QString processImage(const QString &inputUrl);
};
```

**imageprocessor.cpp**

```cpp
QString ImageProcessor::processImage(const QString &inputUrl)
{
    QString inputPath = QUrl(inputUrl).toLocalFile();
    QImage result     = convertWhiteToTransparent(inputPath);

    QString outputPath = inputPath.section('.', 0, -2) + "_transparent.png";
    result.save(outputPath);

    return QUrl::fromLocalFile(outputPath).toString(); // URL utilisable par QML
}
```

### Utilisation dans un fichier QML

```qml
// main.qml
Image {
    id: myImage
    source: processor.processImage("file:///path/to/image.jpg")
}
```

---

## Points clés

| Paramètre | Conseil |
|---|---|
| **threshold** | `240` est un bon défaut ; baisser à `~200` si le fond est légèrement grisé |
| **Format** | Toujours convertir en `Format_ARGB32` avant de modifier l'alpha |
| **Sauvegarde** | `save()` infère le format depuis l'extension — `.png` suffit |
| **Performance** | Pour de grandes images, préférer `scanLine()` (accès direct mémoire) plutôt que `pixelColor()` |
