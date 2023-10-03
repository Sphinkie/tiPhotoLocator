#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>
#include <QQuickItem>
#include "Models/PhotoModel.h"
#include "Models/SelectedFilterProxyModel.h"
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
    SelectedFilterProxyModel selectedPhotoModel;
    selectedPhotoModel.setSourceModel(&photoListModel);
    // On initialise nos classes
    ExifWrapper exifWrapper(&photoListModel);

    // Initialisation du moteur:
    // Au choix
    QQmlApplicationEngine engine;
    QQmlContext* context = engine.rootContext();
//    QQuickView view;
//    QQmlContext* context = view.rootContext();

    context->setContextProperty("_photoListModel", &photoListModel);
    context->setContextProperty("_selectedPhotoModel", &selectedPhotoModel);

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
    QObject::connect(firstRootItem, SIGNAL(qmlSignal(double)), &selectedPhotoModel, SLOT(cppSlot(double)));
    QObject::connect(firstRootItem, SIGNAL(scanFolder(QString)), &exifWrapper, SLOT(scanFolder(QString)));
    QObject::connect(firstRootItem, SIGNAL(append(QString,QString)), &photoListModel, SLOT(append(QString,QString)));
    QObject::connect(firstRootItem, SIGNAL(fetchExifMetadata()), &photoListModel, SLOT(fetchExifMetadata()));

    // Exécution de QML
    return app.exec();
}
