#ifndef EXIFWRAPPER_H
#define EXIFWRAPPER_H

#include <QObject>
#include <QString>

class ExifWrapper : public QObject
{
    Q_OBJECT

public:
    explicit ExifWrapper();

public slots:
    bool scanFolder(QString folder);


private:
    bool write(const QString& source, const QString& data);
    bool writeArgsFile();

    QString m_ArgFile;

};

#endif // EXIFWRAPPER_H
