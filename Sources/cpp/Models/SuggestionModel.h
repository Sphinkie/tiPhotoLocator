#ifndef SUGGESTIONMODEL_H
#define SUGGESTIONMODEL_H

#include <QAbstractListModel>
#include "Suggestion.h"

/** **********************************************************************************************************
 * @brief The SuggestionModel class manages a list of Suggestion.
 * ***********************************************************************************************************/
class SuggestionModel : public QAbstractListModel
{
    Q_OBJECT

public:
    /** ******************************************************************************************************
     * @brief The Roles enum lists the roles associated to each attribute of a Suggestion
     * *******************************************************************************************************/
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
    // Méthodes publiques
    // -----------------------------------------------------
    void removeCurrentPhotoFromSuggestion(const QModelIndex index);
    void removeFromSuggestion(const QString target);
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
    int m_selectedPhotoRow = -4;        //!< La valeur par défaut -4 ne correspond à aucune photo.
    int m_dumpedRow;                    //!< La dernière ligne affichée dans le dump de debug.

};

#endif // SUGGESTIONMODEL_H
