#ifndef SUGGESTIONMODEL_H
#define SUGGESTIONMODEL_H

#include <QAbstractListModel>


/* ********************************************************************************** */
/*!
   \brief A data structure containing a tag suggestion, for one or several Photo.
*/
/* ********************************************************************************** */
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
    QString text;              //!< Le contenu textuel de la suggestion. Example: "COSTA RICA".
    QString target;            //!< Le nom de la metadata compatible avec ce texte. Example: "Country".
    QString category;          //!< Permet aux zones d'afficher ou non la suggestion. Example: "geo", "tag"...
    QSet<int> photos;          //!< List of Photo matching this suggestion.

    // Surcharges d'operateur
    bool operator== (const Suggestion &suggestion) const;
};



/* ********************************************************************************** */
/*!
 * \class SuggestionModel
 * \brief The SuggestionModel class manages a list of Suggestion.
 */
/* ********************************************************************************** */
class SuggestionModel : public QAbstractListModel
{
    Q_OBJECT

public:
    /*!
     * \brief The Roles enum lists the roles associated to each attribute of a Suggestion
     */
    enum Roles {
        TextRole  = Qt::UserRole,  // The first role that can be used for application-specific purposes.
        TargetRole,
        CategoryRole,
        PhotosRole
    };

    // -----------------------------------------------------
    // Surcharges obligatoires
    // -----------------------------------------------------
    explicit SuggestionModel(QObject *parent = nullptr);
    int      rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QHash<int, QByteArray> roleNames() const override;

    // -----------------------------------------------------
    // Methodes publiques
    // -----------------------------------------------------
    void removeCurrentPhotoFromSuggestion(const QModelIndex index);
    Q_INVOKABLE void dumpData();

public slots:
    void onSelectedPhotoChanged(const int row);
    void append(const QString text, const QString target, const QString category, int photo_row = -2);

private:
    // -----------------------------------------------------
    // Methodes privées
    // -----------------------------------------------------
    void addPhotoToSuggestion(const int suggestion_row, int photo_row);
    void addCategoryToSuggestion(const int suggestion_row, const QString category);

    // -----------------------------------------------------
    // Membres
    // -----------------------------------------------------
    QVector<Suggestion> m_suggestions;  //!< La liste des Suggestion
    int m_selectedPhotoRow = -4;        //!< La valeur par defaut -4 ne correspond à aucune photo
    int m_dumpedRow;                    //!< La dernière ligne affichée dans le dump de debug.

};

#endif // SUGGESTIONMODEL_H
