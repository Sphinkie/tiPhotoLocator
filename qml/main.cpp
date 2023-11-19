#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>
#include <QQuickItem>
#include "Models/PhotoModel.h"
#include "Models/SuggestionModel.h"
#include "Models/OnTheMapProxyModel.h"
#include "Models/SuggestionProxyModel.h"
#include "Models/UnlocalizedProxyModel.h"
#include "cpp/GeocodeWrapper.h"


/*!
    \page index.html

    \indexpage Index
    \startpage TiPhotoLocator
    \title Index

    \list
        \li \l{TiPhotoLocator}
    \endlist
*/

/*!
    \module TiPhotoLocator

    \title TiPhotoLocator

    \brief The ultimate Photo Locator.

    TiPhotoLocator est developpé en C++ et en QML (avec le framework Qt version 6). \br
    Il lit et écrit les tags EXIF et IPTC des photos JPEG avec \l{https://exiftool.org}{exifTool}. \br
    Il accède aux cartes géographiques via les modules QtLocation et QtPositioning.
*/

/** ********************************************************************************
 * Programme principal
 * *********************************************************************************/
int main(int argc, char *argv[])
{
//    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    app.setApplicationName("TiPhotoLocator");
    app.setOrganizationName("Sphinkie");
    app.setOrganizationDomain("de-lorenzo.fr");
    app.setWindowIcon(QIcon(":Images/logo_TPL.png"));

    // --------------------------------------
    // On initialise nos Models
    // --------------------------------------
    PhotoModel photoListModel;
    OnTheMapProxyModel onTheMapProxyModel;
    onTheMapProxyModel.setSourceModel(&photoListModel);
    UnlocalizedProxyModel unlocalizedProxyModel;
    unlocalizedProxyModel.setSourceModel(&photoListModel);
    SuggestionModel suggestionModel;
    SuggestionProxyModel suggestionProxyModel;
    suggestionProxyModel.setSourceModel(&suggestionModel);
    // --------------------------------------
    // On initialise nos classes
    // --------------------------------------
    GeocodeWrapper geocodeWrapper(&suggestionModel); // on lui passe le modèle qui mémorisera les suggestions

    // --------------------------------------
    // Initialisation du moteur:
    // --------------------------------------
    // Au choix
    QQmlApplicationEngine engine;
    QQmlContext* context = engine.rootContext();
//    QQuickView view;
//    QQmlContext* context = view.rootContext();

    // --------------------------------------
    // On ajoute au contexte les classes  qui ont des property QML
    // --------------------------------------
    context->setContextProperty("_photoListModel", &photoListModel);
    context->setContextProperty("_onTheMapProxyModel", &onTheMapProxyModel);
    context->setContextProperty("_suggestionProxyModel", &suggestionProxyModel);
    context->setContextProperty("_unlocalizedProxyModel", &unlocalizedProxyModel);

    // Chargement du QMl. Au choix:
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    //view.setSource(QUrl("qrc:/main.qml"));

    // --------------------------------------
    // Connexion des signaux
    // --------------------------------------
    // Bouton QUIT
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl)
    {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    // --------------------------------------
    // Démarrage (au choix)
    // --------------------------------------
    engine.load(url);
    //view.show();

    // --------------------------------------
    // Connexions
    // --------------------------------------
    //QObject *item = view.rootObject();
    // Le firstRootItem est la première balise du QML, cad "window".
    QObject *firstRootItem = engine.rootObjects().first();
    // --------------------------------------
    // Connexions QML vers classe C++
    // --------------------------------------
    QObject::connect(firstRootItem,   SIGNAL(append(QString,QString)),         &photoListModel, SLOT(append(QString,QString)));
    QObject::connect(firstRootItem,   SIGNAL(fetchSingleExifMetadata(int)),    &photoListModel, SLOT(fetchExifMetadata(int)));
    QObject::connect(firstRootItem,   SIGNAL(fetchExifMetadata()),             &photoListModel, SLOT(fetchExifMetadata()));
    QObject::connect(firstRootItem,   SIGNAL(saveMetadata()),                  &photoListModel, SLOT(saveMetadata()));
    QObject::connect(firstRootItem,   SIGNAL(savePosition(double,double)),     &photoListModel, SLOT(appendSavedPosition(double,double)));
    QObject::connect(firstRootItem,   SIGNAL(clearSavedPosition()),            &photoListModel, SLOT(removeSavedPosition()));
    QObject::connect(firstRootItem,   SIGNAL(setPhotoProperty(int,QString,QString)), &photoListModel, SLOT(setData(int,QString,QString)));

    QObject::connect(firstRootItem,   SIGNAL(setSelectedItemCoords(double,double)), &onTheMapProxyModel,   SLOT(setAllItemsCoords(double,double)));
    QObject::connect(firstRootItem,   SIGNAL(applySavedPositionToCoords()),         &onTheMapProxyModel,   SLOT(setAllItemsSavedCoords()));
    QObject::connect(firstRootItem,   SIGNAL(removePhotoFrom(int)),                 &suggestionProxyModel, SLOT(removePhotoFromSuggestion(int)));
    QObject::connect(firstRootItem,   SIGNAL(setSuggestionFilter(int)),             &suggestionProxyModel, SLOT(setFilterValue(int)));

    QObject::connect(firstRootItem,   SIGNAL(requestReverseGeocode(double,double)), &geocodeWrapper,       SLOT(requestReverseGeocode(double,double)));

    // --------------------------------------
    // Connexions entre classes C++
    // --------------------------------------
    QObject::connect(&photoListModel, SIGNAL(selectedRowChanged(int)),    &suggestionModel, SLOT(onSelectedPhotoChanged(int)));

    // --------------------------------------
    // Exécution de QML
    // --------------------------------------
    return app.exec();
}
