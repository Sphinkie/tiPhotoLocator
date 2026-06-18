#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTranslator>
#include <QQuickView>
#include <QQmlContext>
#include <QQuickItem>
#include <QSettings>

#include "Models/PhotoModel.h"
#include "Models/OnTheMapProxyModel.h"
#include "Models/SelectedPhotoProxyModel.h"
#include "Models/SuggestionModel.h"
#include "Models/SuggestionProxyModel.h"
#include "Models/SuggestionCategoryProxyModel.h"
#include "Models/CameraSet.h"
#include "GeocodeWrapper.h"
#include "LandmarkWrapper.h"



/** **********************************************************************************************************
 * @brief Programme principal
 * @param argc: (argument count): nombre de paramètres pointés par argv +1
 * @param argv: (argument vector)
 *
 *   The ultimate Photo Locator.
 *       \li \l{TiPhotoLocator}{Les classes C++}
 *       \li les scripts QML
 *
 *   TiPhotoLocator est developpé en C++ et en QML (avec le framework Qt version 6). \br
 *   Il lit et écrit les tags EXIF et IPTC des photos JPEG avec \l{https://exiftool.org}{exifTool}. \br
 *   Il accède aux cartes géographiques via les modules QtLocation et QtPositioning.
 * ***********************************************************************************************************/
int main(int argc, char *argv[])
{
//    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    app.setApplicationName("TiPhotoLocator");
    app.setOrganizationName("Sphinkie");
    app.setOrganizationDomain("de-lorenzo.fr");
    app.setWindowIcon(QIcon(":Logos/logo_TPL.ico")); // Icon displayed in the top-left corner of the application's top-level window.


    // ----------------------------------------------------------------------------
    // On choisit une langue pour le GUI de l'application
    // ----------------------------------------------------------------------------
    QSettings settings;
    QTranslator traducteur;
    // Cas d'une ressource en paramètre
    QString lang = (settings.value("guiLanguage", 0).toInt() == 1) ? "fre" : "eng";
    bool trad_ok = traducteur.load(lang, ":/Translations/");
    // Puis on applique la traduction  (avant de lancer le moteur QML)
    if (trad_ok) app.installTranslator(&traducteur);

    // ----------------------------------------------------------------------------
    // On initialise nos Models
    // ----------------------------------------------------------------------------
    PhotoModel photoModel;
    OnTheMapProxyModel onTheMapProxyModel;
    onTheMapProxyModel.setSourceModel(&photoModel);
    SelectedPhotoProxyModel selectedPhotoProxyModel;
    selectedPhotoProxyModel.setSourceModel(&photoModel);

    SuggestionModel suggestionModel;
    SuggestionProxyModel suggestionProxyModel;
    suggestionProxyModel.setSourceModel(&suggestionModel);
    SuggestionCategoryProxyModel suggestionCategoryProxyModel;
    suggestionCategoryProxyModel.setSourceModel(&suggestionProxyModel);
    // ----------------------------------------------------------------------------
    // On initialise nos classes
    // ----------------------------------------------------------------------------
    GeocodeWrapper geocodeWrapper(&suggestionModel); // on lui passe le modèle qui mémorisera les suggestions
    LandmarkWrapper landmarkWrapper;
    CameraSet cameraSet;

    // ----------------------------------------------------------------------------
    // Initialisation du moteur QML:
    // ----------------------------------------------------------------------------
    qputenv("QML_XHR_ALLOW_FILE_READ", "1");  // needed to read qrc:// files via XMLHttpRequest
    // Au choix
    QQmlApplicationEngine engine;
    QQmlContext* context = engine.rootContext();
//    QQuickView view;
//    QQmlContext* context = view.rootContext();

    // ----------------------------------------------------------------------------
    // On ajoute au contexte les classes qui ont des property QML
    // ----------------------------------------------------------------------------
    context->setContextProperty("_photoModel", &photoModel);
    context->setContextProperty("_onTheMapProxyModel", &onTheMapProxyModel);
    context->setContextProperty("_suggestionModel", &suggestionModel);  // Pour le dump de debug
    context->setContextProperty("_suggestionProxyModel", &suggestionProxyModel);
    context->setContextProperty("_suggestionCategoryProxyModel", &suggestionCategoryProxyModel);
    context->setContextProperty("_selectedPhotoProxyModel", &selectedPhotoProxyModel);
    context->setContextProperty("_geocodeWrapper", &geocodeWrapper);
    context->setContextProperty("_landmarkWrapper", &landmarkWrapper);
    context->setContextProperty("_cameraSet", &cameraSet);

    // ----------------------------------------------------------------------------
    // Connexion des signaux
    // ----------------------------------------------------------------------------
    // Sortie en cas de bug.
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed, &app,[]()
        { QCoreApplication::exit(-1); }, Qt::QueuedConnection);

    // ----------------------------------------------------------------------------
    // Démarrage (au choix)
    // ----------------------------------------------------------------------------
    // Charge la page Main.qml du projet
    engine.loadFromModule("QT_TiPhotoLocator", "Main");
    //const QUrl url(QStringLiteral("qrc:/Main.qml"));
    //view.setSource(QUrl("qrc:/main.qml"));    //engine.load(url);
    //view.show();

    // ----------------------------------------------------------------------------
    // Au lancement, on initialise les HomeCoords sur Paris (sauf si existe déjà).
    // ----------------------------------------------------------------------------
    if (!settings.value("homeLatitude").isValid())
    {
        settings.setValue("homecity",      "Notre-Dame de Paris");
        settings.setValue("homeLatitude",  48.8529);
        settings.setValue("homeLongitude", 2.35005);
    }


    // ----------------------------------------------------------------------------
    // Connexions
    // ----------------------------------------------------------------------------
    //QObject *item = view.rootObject();
    // Le firstRootItem est la première balise du QML, cad "window".
    QObject *firstRootItem = engine.rootObjects().first();
    // ----------------------------------------------------------------------------
    // Connexions QML vers objet C++
    // ----------------------------------------------------------------------------
    QObject::connect(firstRootItem, SIGNAL(append(QString,QString)),               &photoModel, SLOT(append(QString,QString)));
    QObject::connect(firstRootItem, SIGNAL(fetchSingleExifMetadata(int)),          &photoModel, SLOT(fetchExifMetadata(int)));
    QObject::connect(firstRootItem, SIGNAL(fetchExifMetadata()),                   &photoModel, SLOT(fetchExifMetadata()));
    QObject::connect(firstRootItem, SIGNAL(saveMetadata()),                        &photoModel, SLOT(saveMetadata()));
    QObject::connect(firstRootItem, SIGNAL(savePosition()),                        &photoModel, SLOT(appendSavedPosition()));
    QObject::connect(firstRootItem, SIGNAL(clearSavedPosition()),                  &photoModel, SLOT(removeSavedPosition()));
    QObject::connect(firstRootItem, SIGNAL(applyCreatorToAll()),                   &photoModel, SLOT(applyCreatorToAll()));
    QObject::connect(firstRootItem, SIGNAL(applyCreatorToSelection()),             &photoModel, SLOT(applyCreatorToSelection()));
    QObject::connect(firstRootItem, SIGNAL(setPhotoProperty(int,QString,QString)), &photoModel, SLOT(setPhotoProperty(int,QString,QString)));

    QObject::connect(firstRootItem, SIGNAL(applySavedPositionToCoords()),         &onTheMapProxyModel,   SLOT(setAllItemsSavedCoords()));
    QObject::connect(firstRootItem, SIGNAL(setSuggestionFilter(int)),             &suggestionProxyModel, SLOT(setFilterValue(int)));
    QObject::connect(firstRootItem, SIGNAL(removePhotoFromSuggestion(int)),       &suggestionCategoryProxyModel, SLOT(removePhotoFromSuggestion(int)));

    QObject::connect(firstRootItem, SIGNAL(requestReverseGeocode(double, double)),&geocodeWrapper,  SLOT(requestReverseGeocode(double, double)));
    QObject::connect(firstRootItem, SIGNAL(requestCoords(QString, bool)),         &geocodeWrapper,  SLOT(requestCoordinates(QString, bool)));
    QObject::connect(firstRootItem, SIGNAL(showNextCoords()),                     &geocodeWrapper,  SLOT(onShowNextCoords()));

    // ----------------------------------------------------------------------------
    // Connexions entre objets C++
    // ----------------------------------------------------------------------------
    QObject::connect(&photoModel, SIGNAL(currentItemRowChanged(int)),                  &suggestionModel, SLOT(onCurrentPhotoChanged(int)));
    QObject::connect(&photoModel, SIGNAL(sendSuggestion(QString,QString,QString,int)), &suggestionModel, SLOT(append(QString,QString,QString,int)));

    // ----------------------------------------------------------------------------
    // Exécution de QML
    // ----------------------------------------------------------------------------
    return app.exec();
}
