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
    Q_PROPERTY(QString folderLocation READ folderLocation NOTIFY folderLocationChanged)

public:
    QString folderLocation() const { return m_folderLocation; }
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
    // Méthodes pouvant être appelées depuis QML
    // -----------------------------------------------------
    Q_INVOKABLE void dumpData();
    Q_INVOKABLE void clear();
    Q_INVOKABLE void setDefaultDateFromFolder(const QString &folderUrl);

    // -----------------------------------------------------
    // Méthodes publiques
    // -----------------------------------------------------
    void removeCurrentPhotoFromSuggestion(const QModelIndex index);
    void removeFromSuggestion(const QString target);

public slots:
    // -----------------------------------------------------
    // Slots
    // -----------------------------------------------------
    void append(const QString& text, const QString& target, const QString& category, int photo_row = -2);
    void onCurrentPhotoChanged(const int row);

signals:
    void folderLocationChanged();

private:
    // -----------------------------------------------------
    // Methodes privées
    // -----------------------------------------------------
    void addPhotoToSuggestion(const int suggestion_row, int photo_row);
    void addCategoryToSuggestion(const int suggestion_row, const QString category);
    void createInitialSuggestions();
    void loadKeywordsFromFile(const QString &lang);
    void loadKeywordsFromSettings();

    // -----------------------------------------------------
    // Membres
    // -----------------------------------------------------
    QVector<Suggestion> m_suggestions;  //!< La liste des Suggestion
    int     m_currentPhotoRow = -9;    //!< Indice de la photo courante. Valeurs spéciales: -9 = aucune photo | -1 = toutes les photos | -2 = la photo sélectionée.
    int     m_dumpedRow;               //!< La dernière ligne affichée dans le dump de debug.
    QString m_folderLocation;          //!< Le lieu extrait du nom du dossier courant.

};

#endif // SUGGESTIONMODEL_H
