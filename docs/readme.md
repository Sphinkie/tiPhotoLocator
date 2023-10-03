# Usefull Documentation for QML programming

## Qt Official Documentation

https://wiki.qt.io/Category:HowTo

[QML Applications | Qt 5.15](https://doc.qt.io/qt-5.15/qmlapplications.html)
[QML Basic Types | Qt 5.15](https://doc.qt.io/qt-5/qtqml-typesystem-basictypes.html)

### Vues, Models, Delegates

[Les modèles de données QML](https://qt.developpez.com/doc/4.7/qdeclarativemodels)  
[Models and Views in Qt Quick](https://doc.qt.io/qt-5.15/qtquick-modelviewsdata-modelview.html)
[ListView QML Type | Qt 5.15](https://doc.qt.io/qt-5.15/qml-qtquick-listview.html)
[ListModel QML Type | Qt 5.15](https://doc.qt.io/qt-5/qml-qtqml-models-listmodel.html)
[DelegateModel QML Type | Qt 5.15](https://doc.qt.io/qt-5.15/qml-qtqml-models-delegatemodel.html)
[DelegateModelGroup QML Type | Qt 5.15](https://doc.qt.io/qt-5.15/qml-qtqml-models-delegatemodelgroup.html)

https://stackoverflow.com/questions/20398646/qml-model-data-by-index

### Layouts

[Layout QML Type | Qt 5.15](https://doc.qt.io/qt-5/qml-qtquick-layouts-layout.html)
[Qt Quick - Layouts Overview](https://doc.qt.io/qt-5.15/qtquicklayouts-overview.html)
[Qt Quick - Layouts Overview | Qt 5.15](https://qthub.com/static/doc/qt5/qtquick/qtquicklayouts-overview.html)
[Qt Quick - Stack Layouts](https://docs.w3cub.com/qt~5.15/qml-qtquick-layouts-stacklayout.html)

# Specific samples and docs

## MenuBar

There are 2 libraires offering a **MenuBar**: **Qt Quick Controls** and **Qt Labs Platform**:  
[MenuBar QML Type | Qt Quick Controls 2 5.10](https://doc.qt.io/archives/qt-5.10/qml-qtquick-controls2-menubar.html)  
[MenuBar QML Type | Qt Labs Platform 5.15.15](https://doc.qt.io/qt-5/qml-qt-labs-platform-menubar.html)

## System commands

[Running a system command through qml](https://forum.qt.io/topic/55522/running-a-system-command-through-qml-for-qt-5-4)  

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
