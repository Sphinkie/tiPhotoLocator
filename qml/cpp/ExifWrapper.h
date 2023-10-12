#ifndef EXIFWRAPPER_H
#define EXIFWRAPPER_H

#include <QObject>
#include <QString>
#include "Models/PhotoModel.h"

class ExifWrapper : public QObject
{
    Q_OBJECT

public:
    explicit ExifWrapper(PhotoModel* photomodel);

public slots:
    bool scanFile(QString filePath);
    void writeMetadata(QString filePath);

private:
    bool writeArgsFile();
    void processLine(QByteArray line);

    QString m_argFile;
    PhotoModel* m_photoModel;
    QByteArray m_rxLine;

};

#endif // EXIFWRAPPER_H
