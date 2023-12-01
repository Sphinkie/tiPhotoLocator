#ifndef SUGGESTIONMODEL_H
#define SUGGESTIONMODEL_H

#include <QAbstractListModel>


/* ********************************************************************************** */
/*!
   @brief A data structure containing a tag suggestion, for one or several Photo.
*/
/* ********************************************************************************** */
struct Suggestion
{
    // Default constructor
    Suggestion() {}

    // Constructeur avec valeurs
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
    }

    // Elements de la structure
    QString text;              //!< Example: "COSTA RICA"
    QString target;            //!< Example: "Country"
    QString category;          //!< Example: "Geo", "Photo"
    QSet<int> photos;          //!< List of Photo matching this Suggestion

    // Surcharges d'operateurs
    bool operator== (const Suggestion &data) const;
};



/* ********************************************************************************** */
/*!
 * @class SuggestionModel
 * @brief The SuggestionModel class manages a list of Suggestion.
 */
/* ********************************************************************************** */
class SuggestionModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        TextRole  = Qt::UserRole,  // The first role that can be used for application-specific purposes.
        TargetRole,
        CategoryRole,
        PhotosRole
    };
    QHash<int, QByteArray> roleNames() const override;

    // -----------------------------------------------------
    // Surcharges obligatoires
    // -----------------------------------------------------
    explicit SuggestionModel(QObject *parent = nullptr);
    int      rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

    // -----------------------------------------------------
    // Methodes publiques
    // -----------------------------------------------------
//    void append(const QString text, const QString target, const QString category);
    void removeCurrentPhotoFromSuggestion(const QModelIndex index);

public slots:
    void onSelectedPhotoChanged(const int row);
    void append(const QString text, const QString target, const QString category, int photo_row = -2);

private:
    // -----------------------------------------------------
    // Methodes privées
    // -----------------------------------------------------
    void addCurrentPhotoToSuggestion(int row);

    // -----------------------------------------------------
    // Membres
    // -----------------------------------------------------
    QVector<Suggestion> m_suggestions;
    int m_selectedPhotoRow = -3;    // La valeur par defaut -3 ne correspond à aucune photo

};

#endif // SUGGESTIONMODEL_H
