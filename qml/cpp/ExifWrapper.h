#ifndef EXIFWRAPPER_H
#define EXIFWRAPPER_H

#include <QObject>
#include <QString>
#include "Models/PhotoModel.h"

class ExifWrapper : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool generateBackup MEMBER m_generateBackup)

public:
    explicit ExifWrapper(PhotoModel* photomodel);

public slots:
    void scanFile(QString filePath);
    void writeMetadata(const QVariantMap exifData);

private:
    bool writeArgsFile();
    void processLine(QByteArray line);

    QString m_argFile;          // Nom du fichier contenant les argements de ExifTool
    PhotoModel* m_photoModel;
    QByteArray m_rxLine;        // Ligene ExifTool en cours de réception
    bool m_generateBackup;      // Accessible par QML

};

#endif // EXIFWRAPPER_H



// https://scythe-studio.com/en/blog/how-to-integrate-qml-and-c-expose-object-and-register-c-class-to-qml
// dit qu'il faut ajouter la ligen suivante dan le main pour éviter la ReferenceError: exifWrapper is not defined
// context->setContextProperty("_exifWrapper", &exifWrapper);
