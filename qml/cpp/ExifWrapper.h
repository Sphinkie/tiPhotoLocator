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
    bool scanFolder(QString folder);


private:
    bool write(const QString& source, const QString& data);
    bool writeArgsFile();

    QString m_argFile;
    PhotoModel* m_photoModel;

};

#endif // EXIFWRAPPER_H
