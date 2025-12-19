#ifndef UTILITIES_H
#define UTILITIES_H

#include <QString>
#include <QVariant>


/* **********************************************************************************************************
 * @brief The Utilities class contains a set of usefull static functions.
 */
class Utilities
{
public:

    Utilities();
    static QString toExifDate(const QVariant value);
    static QString toReadableDateTime(const QVariant value);
    static QString toStandardDateTime(const QVariant value);

    static QString fixYear(QString sYear, int defaultYear);
    static QString fixDigits(QString sMonth, int defaultValue, int min, int max);

    static QString normalise(QString texte);

private:
    //! Liste des lettres diacritiques (accentuées) d'Europe.
    static const inline QString diacriticLetters = QString::fromUtf8("ŠŒŽšœžŸ¥µÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýÿ");

    //! Liste des lettres normalisées équivalentes aux lettres diacritiques (dans le même ordre).
    static const inline QStringList normalizedLetters = {"S", "OE", "Z","s","oe","z","Y","Y","u","A","A","A","A","A","A","AE","C","E","E","E","E",
                                                         "I","I","I","I","D","N","O","O","O","O","O","O","U","U","U","U","Y","s","a","a","a","a",
                                                         "a","a","ae","c","e","e","e","e","i","i","i","i","o","n","o","o","o","o","o","o","u","u",
                                                         "u","u","y","y"};
};

#endif // UTILITIES_H
