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
    static QString toStandardDateTime(const QVariant value);

    static QString fixYear(QString sYear, int defaultYear);
    static QString fixDigits(QString sMonth, int defaultValue, int min, int max);

};

#endif // UTILITIES_H
