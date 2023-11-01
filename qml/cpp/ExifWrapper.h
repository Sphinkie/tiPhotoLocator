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
    // -----------------------------------
    // Méthodes
    // -----------------------------------
    explicit ExifWrapper(PhotoModel* photo_model);

public slots:
    // -----------------------------------
    // Slots
    // -----------------------------------
    void scanFile(QString filePath);
    void writeMetadata(const QVariantMap exifData);

private:
    // -----------------------------------
    // Méthodes privées
    // -----------------------------------
    bool writeArgsFile();
    void processLine(QByteArray line);

    // -----------------------------------
    // Membres
    // -----------------------------------
    QString m_argFile;          /// Nom du fichier contenant les argements de ExifTool
    QByteArray m_rxLine;        /// Ligne ExifTool en cours de réception
    bool m_generateBackup;      /// Accessible par QML
    PhotoModel* m_photoModel;   /// Modèle contenant les photos et leurs tags

};

#endif // EXIFWRAPPER_H


// Partage de la Property avec QML:
// Ce site dit qu'il faut ajouter la ligne suivante dans le main.cpp pour éviter la "ReferenceError: exifWrapper is not defined"
// context->setContextProperty("_exifWrapper", &exifWrapper);
// https://scythe-studio.com/en/blog/how-to-integrate-qml-and-c-expose-object-and-register-c-class-to-qml
