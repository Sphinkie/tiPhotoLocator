#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    app.setOrganizationName("Sphinkie");
    app.setOrganizationDomain("https://github.com/Sphinkie");
    app.setApplicationName("TiPhotoLocator");
    //app.setWindowIcon(QIcon(":/icons/flaticon/icon.png"));

    // Start QML engine
    QQmlApplicationEngine engine;

    // Start QML
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
