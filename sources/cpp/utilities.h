#ifndef UTILITIES_H
#define UTILITIES_H

#include <QString>
#include <QVariant>


/*!
 * \brief The Utilities class contains a set of usefull static functions.
 */
class Utilities
{
public:
    Utilities();
    //static QString toExifDate(const QVariant value, const QString old_value="");
    static QString toExifDate(const QVariant value);
    static QString toReadableDate(const QVariant value);

};

#endif // UTILITIES_H
