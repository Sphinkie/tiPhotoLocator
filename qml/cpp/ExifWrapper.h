#ifndef EXIFWRAPPER_H
#define EXIFWRAPPER_H

#include <QString>

class ExifWrapper
{
public:
    ExifWrapper();
    bool scanFolder();


private:
    bool write(const QString& source, const QString& data);
    bool writeConfigFile();

};

#endif // EXIFWRAPPER_H
