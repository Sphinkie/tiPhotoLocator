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
    enum Roles {
        TextRole  = Qt::UserRole,  // The first role that can be used for application-specific purposes.
        TargetRole,
        TypeRole,
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
    void append(const QString text, const QString target, const Suggestion::ItemType item_type);
    void addPhoto(const QModelIndex &index, const int photo_row);
    void removePhoto(const QModelIndex &index, const int photo_row);

public slots:
    void selectedPhoto(const int row);

private:
    // -----------------------------------------------------
    // Methodes privées
    // -----------------------------------------------------
    void addSelectedPhoto(Suggestion* suggestion);

    // -----------------------------------------------------
    // Membres
    // -----------------------------------------------------
    QVector<Suggestion> m_suggestions;
    int m_selectedPhotoRow = -1;

};

#endif // SUGGESTIONMODEL_H
