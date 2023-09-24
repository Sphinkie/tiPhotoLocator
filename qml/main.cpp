#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>
#include <QQuickItem>
#include "Models/PhotoModel.h"
#include "Models/SelectedFilterProxyModel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    app.setOrganizationName("Sphinkie");
    app.setOrganizationDomain("https://github.com/Sphinkie");
    app.setApplicationName("TiPhotoLocator");
    //app.setWindowIcon(QIcon(":/icons/flaticon/icon.png"));  // TODO : ajouter une icone

    PhotoModel photoListModel;
    SelectedFilterProxyModel selectedPhotoModel;
    selectedPhotoModel.setSourceModel(&photoListModel);

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
    // Slots customisés
    //QObject *item = view.rootObject();
    //QObject::connect(mapitemView, SIGNAL(qmlSignal(double)), &selectedPhotoModel, SLOT(cppSlot(double)));


    // Démarrage (au choix)
    engine.load(url);
    //view.show();

    // Exécution de QML
    return app.exec();
}
