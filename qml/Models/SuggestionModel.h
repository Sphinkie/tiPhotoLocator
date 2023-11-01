#ifndef SUGGESTIONMODEL_H
#define SUGGESTIONMODEL_H

#include <QAbstractListModel>


/**
 * @brief A data structure containing a tag suggestion, for one or several photos.
 */
struct Suggestion
{
    enum ItemType {geo, ia, other};

    // Default constructor
    Suggestion() {}

    // Constructeur avec valeurs
    Suggestion(const QString &suggestion_text,
               const QString &suggestion_target,
               const Suggestion::ItemType suggestion_type
               )
    {
        text = suggestion_text;
        target = suggestion_target;
        itemType = suggestion_type;
    }

    // Elements de la structure
    QString text;              // Example: "COSTA RICA"
    QString target;            // Example: "Country"
    ItemType itemType;         // Example: "geo"
    QList<int> photos;         // List of photo matching this suggestion

};


/**
 * @brief The SuggestionModel class manages a list of Suggestions.
 */
class SuggestionModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit SuggestionModel(QObject *parent = nullptr);


private: //members
    QVector<Suggestion> m_suggestions;


};

#endif // SUGGESTIONMODEL_H
