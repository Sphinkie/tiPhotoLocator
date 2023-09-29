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
    bool scanFolder(QString folderPath);


private:
    bool writeFile(const QString& source, const QString& data);
    bool writeArgsFile();
    void processLine(QByteArray line);

    QString m_argFile;
    PhotoModel* m_photoModel;
    QByteArray m_rxLine;

};

#endif // EXIFWRAPPER_H
