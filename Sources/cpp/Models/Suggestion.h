#ifndef SUGGESTION_H
#define SUGGESTION_H

#include <QSet>
#include <QString>

/** **********************************************************************************************************
 * @brief A data structure containing a tag suggestion, for one or several Photo.
 * ***********************************************************************************************************/
struct Suggestion
{
    //! Default constructor
    Suggestion() {};

    //! Constructeur avec valeurs
    Suggestion(const QString &suggestion_text,
               const QString &suggestion_target,
               const QString suggestion_category,
               const int first_photo
               )
    {
        text = suggestion_text;
        target = suggestion_target;
        category = suggestion_category;
        photos << first_photo;
    };

    // Elements de la structure
    QString text;              //!< Le contenu textuel de la suggestion. Exemple: "COSTA RICA".
    QString target;            //!< Le nom de la metadata compatible avec ce texte. Exemple: "country".
    QString category;          //!< Permet aux zones d'afficher ou non la suggestion. Exemple: "geo", "tag"...
    QSet<int> photos;          //!< List of Photo matching this suggestion.

    // Surcharges d'opérateur
    bool operator== (const Suggestion &suggestion) const;
};


#endif // SUGGESTION_H
