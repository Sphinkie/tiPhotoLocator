# Docs

## QML tutorials

[7. Model-View-Delegate Qt5 Book](https://qmlbook.github.io/ch07-modelview/modelview.html)

[QML designer in Qt Creator tutorial - April 2023 - eefbfcde - YouTube](https://www.youtube.com/watch?v=ePcJ2lbyVKs)

[QML - Tutoriel 3 - Les attributs - YouTube](https://www.youtube.com/watch?v=tDSVlrsQJU0)

[DMC Info - Resizing UIs with QML layouts](https://www.dmcinfo.com/latest-thinking/blog/id/10393/resizing-uis-with-qml-layouts)

### KDAB Academy (Youtube):

[Introduction to Qt / QML (Part 01) - Introduction to Qt Quick](https://www.youtube.com/watch?v=JxyTkXLbcV4)  
[Introduction to Qt / QML (Part 19) - Sizing components](https://www.youtube.com/watch?v=Lt-8fYWOVx8)  
[Introduction to Qt / QML (Part 30) - Customizing ListView](https://www.youtube.com/watch?v=ZArpJDRJxcI)  
[Introduction to Qt / QML (Part 37) - Qt Quick Layouts](https://www.youtube.com/watch?v=FwzQQ6YPlxE)  

[GitHub - KDAB/kdabtv: This repository contains the code of the examples showcased in the KDAB TV video series.](https://github.com/KDAB/kdabtv/tree/master/qml-intro)

### Qt Docs

https://wiki.qt.io/Category:HowTo

[QML Basic Types | Qt 5.15](https://doc.qt.io/qt-5/qtqml-typesystem-basictypes.html)

[ListView QML Type | Qt 5.15](https://doc.qt.io/qt-5.15/qml-qtquick-listview.html)

[QML Applications | Qt 5.15](https://doc.qt.io/qt-5.15/qmlapplications.html)

#### 2 types of menuBar:

[MenuBar QML Type | Qt Quick Controls 2 5.10](https://doc.qt.io/archives/qt-5.10/qml-qtquick-controls2-menubar.html)

[MenuBar QML Type | Qt Labs Platform 5.15.15](https://doc.qt.io/qt-5/qml-qt-labs-platform-menubar.html)

#### Vues, Models, Delegates

[Les modèles de données QML](https://qt.developpez.com/doc/4.7/qdeclarativemodels)  
[ListModel QML Type | Qt 5.15](https://doc.qt.io/qt-5/qml-qtqml-models-listmodel.html)  
[Models and Views in Qt Quick](https://doc.qt.io/qt-5.15/qtquick-modelviewsdata-modelview.html)  
[DelegateModel QML Type | Qt 5.15](https://doc.qt.io/qt-5.15/qml-qtqml-models-delegatemodel.html)  
[DelegateModelGroup QML Type | Qt 5.15](https://doc.qt.io/qt-5.15/qml-qtqml-models-delegatemodelgroup.html)  

https://stackoverflow.com/questions/20398646/qml-model-data-by-index

#### Layouts

[Qt quick - Layouts overview](https://doc.qt.io/qt-5.15/qtquicklayouts-overview.html)  
[Qt Quick Layouts Overview | Qt 5.15](https://qthub.com/static/doc/qt5/qtquick/qtquicklayouts-overview.html)  
[Layout QML Type | Qt 5.15](https://doc.qt.io/qt-5/qml-qtquick-layouts-layout.html)  
[Qt quick - Stack Layouts](https://docs.w3cub.com/qt~5.15/qml-qtquick-layouts-stacklayout.html)  

### Developper.com

[Les bases de la syntaxe Qt QML](https://runebook.dev/fr/docs/qt/qtqml-syntax-basics)  

[Introduction au langage QML](https://qt.developpez.com/doc/4.7/qdeclarativeintroduction/)  

[Ecrire des composants QML : propriétés, méthodes et signaux](https://qt.developpez.com/doc/4.7/qml-extending-types/)  

https://runebook.dev/fr/docs/qt/qml-qt-labs-platform-folderdialog  

[QExifImageHeader Class Reference](https://qt.developpez.com/doc/qtextended4.4/qexifimageheader/)  

## Qt Location

[Places Map (QML) | Qt Location 5.7](https://stuff.mit.edu/afs/athena/software/texmaker_v5.0.2/qt57/doc/qtlocation/qtlocation-places-map-example.html)  
https://stackoverflow.com/questions/61689939/qtlocation-osm-api-key-required  
https://doc.qt.io/qt-5/location-plugin-osm.html  
https://doc.qt.io/qt-5/qtlocation-minimal-map-example.html  
https://www.mapbox.com/  

## System commands

[Running a system command through qml](https://forum.qt.io/topic/55522/running-a-system-command-through-qml-for-qt-5-4)  

## EXIF Librairies

Il existe deux standards concurrents pour la création, l’affichage et la  modification de métadonnées dans les fichiers d’images. Il y a d’un côté les métadonnées [EXIF](https://www.ionos.fr/digitalguide/sites-internet/web-design/que-sont-les-donnees-exif/) qui compilent les caractéristiques techniques des images comme le modèle de l’appareil photo, le temps de pose ou la résolution et de l’autre, les  données **IPTC** qui compilent les données de contenu comme la localisation, l’avis de droit d’auteur ou les données de contact. 

Les données **EXIF** sont générées automatiquement lors de la création d’un fichier JPG. Les données **IPTC** en revanche doivent être entrées ultérieurement par l’utilisateur dans les métadonnées.

* **Exiv2**
  
  * EXIF and IPTC
  
  * Nécessite Expat et Zlib
  
  * [Exiv2 - Image metadata library and tools](https://exiv2.org/getting-started.html)
  
  * [Success: sharing the process of compiling Exiv2 on Qt](https://dev.exiv2.org/boards/3/topics/1259)

* **QExifImageHeader** : semble obsolète depuis 2009
  
  * [Read exif metadata of images in Qt - Stack Overflow](https://stackoverflow.com/questions/15128656/read-exif-metadata-of-images-in-qt)

* **EasyExif**
  
  * Fast and easy to use. 2 files to include only. Third-party dependency free.
  
  * EXIF only (no IPTC)
  
  * [GitHub - mayanklahiri/easyexif: Tiny C++ EXIF parsing library](https://github.com/mayanklahiri/easyexif)

* **ArcGIS**
  
  * EXIF only
  
  * https://developers.arcgis.com/appstudio/api-reference/qml-arcgis-appframework-exifinfo#details

* **Tiny Exif**
  
  * [GitHub - cdcseacave/TinyEXIF: Tiny C++ EXIF and XMP parsing library](https://github.com/cdcseacave/TinyEXIF)
  
  * EXIF et XMP (adobe)
  
  * Pour la partie EXIF, c'est le même code que EasyExif

* **Lib IPTC data** 
  
  * https://libiptcdata.sourceforge.net/
  * Librairie en C  de 2009.

* **Exif Tools**
  
  * ExifTool is a platform-independent Perl library plus a [command-line application](https://exiftool.org/exiftool_pod.html) for reading, writing and editing meta information.
  
  * https://exiftool.org/
  
  * L'idée avec ExifTools n'est pas de l'incorporer dans le code (en tant que librairie) mais d'appeler la command line.

### IPTC metadata

[Guide to Photo Metadata Fields &#8211; CARL SEIBERT SOLUTIONS](https://www.carlseibert.com/guide-iptc-photo-metadata-fields/)

## IA and Deep Learning

https://www.qt.io/resources/videos/build-deep-learning-applications-with-qt-and-tensorflow-lite-dev-des-2021

## Cousin projects

https://github.com/Simon-12/tidy-images/blob/main/app/src/main.cpp

## How to read properties for the currenetly selected item in a ListView

https://forum.qt.io/topic/87242/how-to-read-properties-for-the-currenetly-selected-item-in-a-listview

You can do this by multiple ways.

1. Since you have access to the **currentItem** you could expose its context properties (that's how it can access to the model roles) as normal properties in your delegate: `property string title: model.title`,  then you could do `onCurrentItemChanged: { var title = currentItem.title; }`. This has the inconvenient that the item can possibly be destroyed (if it gets scrolled out of the viewport for example) and then you won't be able to reference it. Maybe there's a special case where `currentItem `don't get destroyed but I don't know, it's not really documented.

2. Another way is to access the `context` properties of the current item yourself without exposing them in the delegate. Sadly it's not possible from QML out of the box. You could write an attached object in c++ but this is fairly advanced. The API could be of the form: `onCurrentItemChanged: { var title = currentItem.Context.title; }`. This has the same limitation as above.

3. You could also access it from the model directly with the `currentIndex`. The model however has to provide an invokable method to expose this, like the `get()` method in **ListModel**. It's not standard in *QAbstractItemModel* so models have to implement that themselves. If you can modify your model, you can add a method like that, it's pretty straightforward.

4. A last solution would be a generic way to access data from a model in QML, like I said earlier there's no standardized way to get data out a of a model from QML but all QAbstractItemModel has to implement data(). The problem is that it's not callable from QML. I wrote a library to help with that : https://github.com/oKcerG/QmlModelHelper
   Just include the .pri in your .pro, in your qml file add import ModelHelper 0.1 and then you could use it like that : `onCurrentIndexChanged: { var title = myModel.ModelHelper.get(currentIndex).title; }`
   Here's the WIP readme : https://gist.github.com/oKcerG/eeea734bdacc51b3ae58650de5f05943
   

5. Another solution using [DelegateModel](https://doc.qt.io/qt-5/qml-qtqml-models-delegatemodel.html#details) to encapsulate the *QAbstractListModel* and let the user get any item at a certain index. 

```qml
import QtQml.Models 2.15 //need this for DelegateModel

ListView {
    id: list
    width: 180; height: 200

    model: DelegateModel{
        id:myDelegateModel
        model: myModel // QAbstractListModel
        delegate: Component {
            Item {
                width: 200
                height: 30
                Text {
                    id: text
                    text: title
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        list.currentIndex = index;
                    }
                }
            }
        }
    } 

    onCurrentItemChanged: {
        var currentModelItem = myDelegateModel.items.get(list.currentIndex).model
        console.log("Current Item title is: " + currentModelItem.title)

    }

}
```
