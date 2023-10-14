#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>
#include <QQuickItem>
#include "Models/PhotoModel.h"
#include "Models/OnTheMapProxyModel.h"
#include "cpp/ExifWrapper.h"


/** ********************************************************************************
 * Programme principal
 * *********************************************************************************/
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    app.setOrganizationName("Sphinkie");
    app.setOrganizationDomain("https://github.com/Sphinkie");
    app.setApplicationName("TiPhotoLocator");
    //app.setWindowIcon(QIcon(":/icons/flaticon/icon.png"));  // TODO : ajouter une icone

    // On initialise nos Models
    PhotoModel photoListModel;
    OnTheMapProxyModel onTheMapProxyModel;
    onTheMapProxyModel.setSourceModel(&photoListModel);
    // On initialise nos classes
    ExifWrapper exifWrapper(&photoListModel);

    // Initialisation du moteur:
    // Au choix
    QQmlApplicationEngine engine;
    QQmlContext* context = engine.rootContext();
//    QQuickView view;
//    QQmlContext* context = view.rootContext();

    context->setContextProperty("_photoListModel", &photoListModel);
    context->setContextProperty("_onTheMapProxyModel", &onTheMapProxyModel);

    // Chargement du QMl. Au choix:
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    //view.setSource(QUrl("qrc:/main.qml"));

    // Connexion des signaux
    // Bouton QUIT
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl)
    {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    // Démarrage (au choix)
    engine.load(url);
    //view.show();

    // Slots customisés
    //QObject *item = view.rootObject();
    // Le firstRootItem est la première balise du QML, cad "window".
    QObject *firstRootItem = engine.rootObjects().first();
    QObject::connect(firstRootItem,   SIGNAL(append(QString,QString)),      &photoListModel, SLOT(append(QString,QString)));
    QObject::connect(firstRootItem,   SIGNAL(fetchExifMetadata()),          &photoListModel, SLOT(fetchExifMetadata()));
    QObject::connect(firstRootItem,   SIGNAL(saveExifMetadata()),           &photoListModel, SLOT(saveExifMetadata()));
    QObject::connect(firstRootItem,   SIGNAL(savePosition(double, double)), &photoListModel, SLOT(appendSavedPosition(double, double)));
    QObject::connect(firstRootItem,   SIGNAL(clearSavedPosition()),         &photoListModel, SLOT(removeSavedPosition()));
//  QObject::connect(firstRootItem,   SIGNAL(setSelectedItemCoords(double,double)), &photoListModel, SLOT(setInCircleItemCoords(double,double)));
    QObject::connect(firstRootItem,   SIGNAL(setSelectedItemCoords(double,double)), &onTheMapProxyModel, SLOT(setAllItemsCoords(double,double)));
    QObject::connect(firstRootItem,   SIGNAL(applySavedPositionToCoords()),         &onTheMapProxyModel, SLOT(setAllItemsSavedCoords()));
    QObject::connect(&photoListModel, SIGNAL(scanFile(QString)),          &exifWrapper, SLOT(scanFile(QString)));
    QObject::connect(&photoListModel, SIGNAL(writeMetadata(QVariantMap)), &exifWrapper, SLOT(writeMetadata(QVariantMap)));

    // Exécution de QML
    return app.exec();
}
