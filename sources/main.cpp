#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>
#include <QQuickItem>
#include <QSettings>

#include "Models/PhotoModel.h"
#include "Models/OnTheMapProxyModel.h"
#include "Models/UnlocalizedProxyModel.h"
#include "Models/UndatedPhotoProxyModel.h"
#include "Models/SuggestionModel.h"
#include "Models/SuggestionProxyModel.h"
#include "Models/SuggestionCategoryProxyModel.h"
#include "Models/CameraSet.h"
#include "cpp/GeocodeWrapper.h"


/* ********************************************************************************* */
/* Entête pour la QDOC (désactivé, car non-compatible doxygen)                       */
/* ********************************************************************************* */
/*
    \page index.html
    \title QML Index page
    \startpage TiPhotoLocator

    The ultimate Photo Locator.
        \li \l{TiPhotoLocator}{Les classes C++}
        \li les scripts QML

    \module TiPhotoLocator
    \title TiPhotoLocator
    \brief Les classes C++.

    TiPhotoLocator est developpé en C++ et en QML (avec le framework Qt version 6). \br
    Il lit et écrit les tags EXIF et IPTC des photos JPEG avec \l{https://exiftool.org}{exifTool}. \br
    Il accède aux cartes géographiques via les modules QtLocation et QtPositioning.
*/
/* ********************************************************************************* */


/* ********************************************************************************* */
/*!
 * \brief Programme principal
 * \param argc
 * \param argv
 * \return
 */
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
    PhotoModel photoModel;
    OnTheMapProxyModel onTheMapProxyModel;
    onTheMapProxyModel.setSourceModel(&photoModel);
    UndatedPhotoProxyModel undatedPhotoProxyModel;
    undatedPhotoProxyModel.setSourceModel(&photoModel);
    UnlocalizedProxyModel unlocalizedProxyModel;
    unlocalizedProxyModel.setSourceModel(&undatedPhotoProxyModel);

    SuggestionModel suggestionModel;
    SuggestionProxyModel suggestionProxyModel;
    suggestionProxyModel.setSourceModel(&suggestionModel);
    SuggestionCategoryProxyModel suggestionCategoryProxyModel;
    suggestionCategoryProxyModel.setSourceModel(&suggestionProxyModel);
    // --------------------------------------
    // On initialise nos classes
    // --------------------------------------
    GeocodeWrapper geocodeWrapper(&suggestionModel); // on lui passe le modèle qui mémorisera les suggestions
    CameraSet cameraSet;

    // --------------------------------------
    // Initialisation du moteur:
    // --------------------------------------
    // Au choix
    QQmlApplicationEngine engine;
    QQmlContext* context = engine.rootContext();
//    QQuickView view;
//    QQmlContext* context = view.rootContext();

    // --------------------------------------
    // On ajoute au contexte les classes qui ont des property QML
    // --------------------------------------
    context->setContextProperty("_photoListModel", &photoModel);
    context->setContextProperty("_onTheMapProxyModel", &onTheMapProxyModel);
    context->setContextProperty("_suggestionModel", &suggestionModel);  // Pour le dump de debug
    context->setContextProperty("_suggestionProxyModel", &suggestionProxyModel);
    context->setContextProperty("_suggestionCategoryProxyModel", &suggestionCategoryProxyModel);
    context->setContextProperty("_unlocalizedProxyModel", &unlocalizedProxyModel);
    context->setContextProperty("_undatedPhotoProxyModel", &undatedPhotoProxyModel);
    context->setContextProperty("_cameraSet", &cameraSet);

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

    QSettings settings;
    QVariant homeCoords = settings.value("homeCoords", QVariant());
    if (!homeCoords.isValid())
    {
        settings.setValue("homecity", "Notre-Dame de Paris");
        settings.setValue("homeCoords", QPointF(double(48.8529), double(2.35005)));
    }


    // --------------------------------------
    // Connexions
    // --------------------------------------
    //QObject *item = view.rootObject();
    // Le firstRootItem est la première balise du QML, cad "window".
    QObject *firstRootItem = engine.rootObjects().first();
    // --------------------------------------
    // Connexions QML vers classe C++
    // --------------------------------------
    QObject::connect(firstRootItem,   SIGNAL(append(QString,QString)),          &photoModel, SLOT(append(QString,QString)));
    QObject::connect(firstRootItem,   SIGNAL(fetchSingleExifMetadata(int)),     &photoModel, SLOT(fetchExifMetadata(int)));
    QObject::connect(firstRootItem,   SIGNAL(fetchExifMetadata()),              &photoModel, SLOT(fetchExifMetadata()));
    QObject::connect(firstRootItem,   SIGNAL(saveMetadata()),                   &photoModel, SLOT(saveMetadata()));
    QObject::connect(firstRootItem,   SIGNAL(savePosition(double,double)),      &photoModel, SLOT(appendSavedPosition(double,double)));
    QObject::connect(firstRootItem,   SIGNAL(clearSavedPosition()),             &photoModel, SLOT(removeSavedPosition()));
    QObject::connect(firstRootItem,   SIGNAL(applyCreatorToAll()),              &photoModel, SLOT(applyCreatorToAll()));
    QObject::connect(firstRootItem,   SIGNAL(setPhotoProperty(int,QString,QString)), &photoModel, SLOT(setData(int,QString,QString)));
    QObject::connect(firstRootItem,   SIGNAL(setSelectedItemCoords(double,double)),  &photoModel, SLOT(setSelectedItemCoords(double,double)));
    QObject::connect(firstRootItem,   SIGNAL(applySavedPositionToCoords()),         &onTheMapProxyModel,   SLOT(setAllItemsSavedCoords()));
    QObject::connect(firstRootItem,   SIGNAL(setSuggestionFilter(int)),             &suggestionProxyModel, SLOT(setFilterValue(int)));
    QObject::connect(firstRootItem,   SIGNAL(removePhotoFromSuggestion(int)),       &suggestionCategoryProxyModel, SLOT(removePhotoFromSuggestion(int)));

    QObject::connect(firstRootItem,   SIGNAL(requestReverseGeocode(double,double)), &geocodeWrapper,       SLOT(requestReverseGeocode(double,double)));
    QObject::connect(firstRootItem,   SIGNAL(requestCoords(QString)),               &geocodeWrapper,       SLOT(requestCoordinates(QString)));

    // --------------------------------------
    // Connexions entre classes C++
    // --------------------------------------
    QObject::connect(&photoModel, SIGNAL(selectedRowChanged(int)),                     &suggestionModel, SLOT(onSelectedPhotoChanged(int)));
    QObject::connect(&photoModel, SIGNAL(sendSuggestion(QString,QString,QString,int)), &suggestionModel, SLOT(append(QString,QString,QString,int)));

    // --------------------------------------
    // Exécution de QML
    // --------------------------------------
    return app.exec();
}
