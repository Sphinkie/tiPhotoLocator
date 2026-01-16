#include "utilities.h"
#include "qdatetime.h"
#include "qregularexpression.h"


/** **********************************************************************************************************
 @brief Constructeur vide.
 * ***********************************************************************************************************/
Utilities::Utilities() 
{
//    Utilities::normalizedLetters << "S"<<"OE"<<"Z"<<"s"<<"oe"<<"z"<<"Y"<<"Y"<<"u"<<"A"<<"A"<<"A"<<"A"<<"A"<<"A"<<"AE"<<"C"<<"E"<<"E"<<"E"<<"E"<<"I"<<"I"<<"I"<<"I"<<"D"<<"N"<<"O"<<"O"<<"O"<<"O"<<"O"<<"O"<<"U"<<"U"<<"U"<<"U"<<"Y"<<"s"<<"a"<<"a"<<"a"<<"a"<<"a"<<"a"<<"ae"<<"c"<<"e"<<"e"<<"e"<<"e"<<"i"<<"i"<<"i"<<"i"<<"o"<<"n"<<"o"<<"o"<<"o"<<"o"<<"o"<<"o"<<"u"<<"u"<<"u"<<"u"<<"y"<<"y";
//    Utilities::diacriticLetters = QString::fromUtf8("ŠŒŽšœžŸ¥µÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýÿ");
}


/** **********************************************************************************************************
 * @brief Convertit une chaine du type "25/08/2017 08:03" au format "2017:08:25 08:03:00".
 * @param value : Le QVariant contenant la nouvelle date.
 * @return la date pouvant être écrite dans un tag Exif.
 * ***********************************************************************************************************/
QString Utilities::toExifDate(const QVariant value)
{
    QString dtValue = value.toString();
    QString result = dtValue.mid(6,4) + ':' + dtValue.mid(3,2) + ':' + dtValue.left(2) + dtValue.mid(10,6) + ":00";
    qDebug() << dtValue << "->" << result;
    return result;
}


/** **********************************************************************************************************
 * @brief Convertit une date saisie manuellement en une date correctement formatée, compatible Exif.
 * @param value : Une string au format "..\..\.... ..:.."
 * @return une string au format "9999:99:99 99:99:00"
 *
 * On est sûr de la présence des séparateurs / et : et ESP. Par contre, il peut y avoir 0 ou 1 ou 2 chiffres entre chaque.
 * ***********************************************************************************************************/
QString Utilities::toStandardDateTime(const QVariant value)
{
    QString result;
    QDate today = QDate::currentDate();

    QRegularExpression regexDateTime("(\\d*)\\/(\\d*)\\/(\\d*) (\\d*):(\\d*)");
    // QRegularExpression regexDateTime(R"(\d*)\/(\d*)\/(\d*) (\d*):(\d*)");  // Raw string

    QRegularExpressionMatch match = regexDateTime.match(value.toString());
    if (match.hasMatch()) {
        // qDebug() << "matched";
        QString day = match.captured(1);
        QString month = match.captured(2);
        QString year = match.captured(3);
        QString hours = match.captured(4);
        QString minutes = match.captured(5);
        // qDebug() << day << "/" << month<< "/" << year << " T " << hours << ":" << minutes;

        day    = fixDigits(day, today.day(), 1, 31);
        month  = fixDigits(month, today.month(), 1, 12);
        year   = fixYear(year, today.year());
        hours  = fixDigits(hours,  0, 0, 23);
        minutes= fixDigits(minutes,  0, 0, 59);
        result = year + ":" + month + ":" + day + " " + hours + ":" + minutes + ":00";
        qDebug() << result;
    }
    else {
        qDebug() << "datetime does not match the pattern";
        result = today.toString("yyyy:MM:dd") + " 12:00:00";
    }
    return (result);
}


/** **********************************************************************************************************
 * @brief Convertit une chaine du type "2017:08:25 08:03:16" au format naturel "25/05/2017 08:03".
 * @param value : Le QVariant contenant la date issue d'un tag Exif.
 * @return la date pouvant être affichée dans un Chip.
 * ***********************************************************************************************************/
QString Utilities::toReadableDateTime(const QVariant value)
{
    QString date = value.toString();
    QString result = date.mid(8,2) + '/' + date.mid(5,2) + '/' + date.left(4) + ' ' + date.mid(11,5);
    return result;
}


/** **********************************************************************************************************
 * @brief Reformate correctement l'année saisie par l'utilisateur.
 * @param sYear : L'année à corriger
 * @param defaultYear : La valeur par défaut. Par exemple: l'année couurante.
 * @return l'année au format "YYYY"
 *
 * Si l'année reçue est sur 2 chiffres, on ajoute 2000.
 * L'année minimale est 1800 (avant: pas de photos)
 * L'année maximale est l'année courante (pas de photos du futur).
 * ***********************************************************************************************************/
QString Utilities::fixYear(QString sYear, int defaultYear)
{
    // qDebug() << "fixYear[str,empty,null,len]" << sYear << sYear.isEmpty() << sYear.isNull() << sYear.length();
    int nYear = sYear.toInt();
    if (sYear.isEmpty() || sYear.isNull()) nYear = defaultYear;
    else if (nYear < 100) nYear += 2000;
    else if (nYear < 1800) nYear = 1800;
    else if (nYear > defaultYear) nYear = defaultYear;
    return QString("%1").arg(nYear, 4, 10, QLatin1Char('0'));  // taille 4, base 10, fillchar
}


/** **********************************************************************************************************
 * @brief Reformate correctement des digits saisis par l'utilisateur (jour, mois, heure, minutes).
 * @param sDigits : La valeur à formater.
 * @param defaultValue : La valeur par défaut, en cas de chaine vide ou non conforme.
 * @param min : La valeur minimale autorisée.
 * @param max : La valeur maximale autorisée.
 * @return les deux digits au format "XX".
 * ***********************************************************************************************************/
QString Utilities::fixDigits(QString sDigits, int defaultValue, int min, int max)
{
    // qDebug() << "fixDigits[str,empty,null,len]" << sDigits << sDigits.isEmpty() << sDigits.isNull() << sDigits.length();
    int nDigits = sDigits.toInt();
    if (sDigits.isEmpty() || sDigits.isNull()) nDigits =defaultValue;
    else if (nDigits < min) nDigits = min;
    else if (nDigits > max) nDigits = max;
    return QString("%1").arg(nDigits, 2, 10, QLatin1Char('0'));
}


/** **********************************************************************************************************
 * @brief Remplace les éventuelles lettres diacritiques d'un texte par leur équivalent normalisé.
 *        Par exemple, on remplace 'à' par 'a'.
 * @param texte: le texte à scanner.
 * @return le texte normalisé.
 * ***********************************************************************************************************/
QString Utilities::normalise(QString texte)
{
    QString output = "";

    for (int i=0; i<texte.length(); i++)
    {
        QChar lettre = texte[i];
        int diaIndex = Utilities::diacriticLetters.indexOf(lettre);

        if (diaIndex < 0)
        {
            // lettre normale
            output.append(lettre);
        }
        else
        {
            // lettre diacritique
            QString replacement = Utilities::normalizedLetters[diaIndex];
            output.append(replacement);
        }
    }

    return output;
}
