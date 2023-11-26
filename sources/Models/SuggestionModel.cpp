#include <QSettings>
#include "SuggestionModel.h"


/*!
 * \class SuggestionModel
 * \inmodule TiPhotoLocator
 * \brief The SuggestionModel class manages a list of Suggestions.
 */

/* ********************************************************************************** */
/**
 * @brief Contructor
 * @param parent
 */
SuggestionModel::SuggestionModel(QObject *parent) : QAbstractListModel{parent}
{
    // A l'init, m_selectedPhotoRow vaut -1 = Suggestion valable pour toutes les photos.
    QSettings settings;
    this->append(settings.value("photographe","").toString(), "artist", "photo");
    this->append(settings.value("initiales","").toString(), "descriptionWriter", "photo");
    this->append("12/01/1934", "dateTimeOriginal", "photo");
}


/* ********************************************************************************** */
/*!
 * \brief Returns the number of elements in the model.
 * \note: Implémentation obligatoire.
 * \a parent: parent of the model
 */
int SuggestionModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;
    return m_suggestions.count();
}


/* ********************************************************************************** */
/*!
 * \brief Returns the requested role value of an element of the model.
 * \note: Implémentation obligatoire.
 * \a index: index of the element of the model.
 * \a role: the requested role (enum).
 */
QVariant SuggestionModel::data(const QModelIndex &index, int role) const
{
    if ( !index.isValid() )
        return QVariant();

    const Suggestion &data = m_suggestions.at(index.row());

    switch(role)
    {
    case TextRole:      return data.text;
    case TargetRole:    return data.target;
    case CategoryRole:  return data.category;
    case PhotosRole:    return QVariant::fromValue(data.photos);   // returns a QVariant containing a copy of value.  (lecture: liste = variant.value<QList<int>>();)
    default:
        return QVariant();
    }
}

/* ********************************************************************************** */
/**
 * Table of Role names. Implémentation obligatoire.
 * C'est la correspondance entre le role C++ et le nom de la property dans QML.
 */
QHash<int, QByteArray> SuggestionModel::roleNames() const
{
    static QHash<int, QByteArray> mapping {
        {TextRole,      "text"},
        {TargetRole,    "target"},
        {CategoryRole,  "category"},
        {PhotosRole,    "photos"}
    };
    return mapping;
}


/* ********************************************************************************** */
/*!
 * \brief Adds a suggestion to the model. \br
 * \a text: text of the suggestion. \br
 * \a target: the name of the Exif tag compatible with this suggestion. \br
 * \a category: the category of the suggestion ("Geo", ... )
 */
void SuggestionModel::append(const QString text, const QString target, const QString category)
{
    if (text.isEmpty()) return;

    for (int i=0; i<m_suggestions.count(); i++ )
    {
        if (m_suggestions.at(i).text == text)
        {
            // Trouvé: la suggestion existe dejà
            qDebug() << "already contains" << text;
            this->addCurrentPhotoToSuggestion(i);
            return;
        }
    }
    // A la fin de la boucle, on ne l'a pas trouvé: il s'agit donc d'un nouvelle suggestion
    qDebug()<< "Adding" << category << "suggestion " << text << "for" << m_selectedPhotoRow;;
    Suggestion* new_suggestion = new Suggestion(text, target, category, m_selectedPhotoRow);
    const int rowOfInsert = m_suggestions.count();
    // On ajoute la suggestion à la liste
    beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
    m_suggestions.insert(rowOfInsert, *new_suggestion);
    endInsertRows();
}


/* ********************************************************************************** */
/*!
 * \brief Ajoute la photo actuellement sélectionnée à la liste des photos ayant un
 * "match" avec cette suggestion.
 * Le paramètre \a row est l'indice de la suggestion à modifier.
 */
void SuggestionModel::addCurrentPhotoToSuggestion(int row)
{
    if (row<0 || row>m_suggestions.count()) return;
    // On ajoute la photo courante dans la liste.
    m_suggestions[row].photos << m_selectedPhotoRow;
    // Emit signal
    QModelIndex index = this->index(row, 0);;
    emit dataChanged(index, index, QVector<int>() << PhotosRole);
}


/* ********************************************************************************** */
/*!
 * \brief Ce slot enlève la photo courante de la liste des photos correspondant à une suggestion donnée.
 * Le paramètre \a index est l'index dans le Model de la suggestion à modifier.
 */
void SuggestionModel::removeCurrentPhotoFromSuggestion(const QModelIndex index)
{
    if (! index.isValid()) return;
    // On retire la photo courante de la liste.
    int row = index.row();
    m_suggestions[row].photos.remove(m_selectedPhotoRow);
    // Emit signal
    emit dataChanged(index, index, QVector<int>() << PhotosRole);
}


/* ********************************************************************************** */
/*
 * \brief Ce slot reçoit et mémorise la position dans le modèle de la photo sélectionnée dans la ListView.
 * \a row: La position dans PhotoModel de la photo active.
 */
void SuggestionModel::onSelectedPhotoChanged(const int row)
{
    if (row<0) return;
    // On mémorise la photo actuellement sélectionnée dans la ListView
    m_selectedPhotoRow = row;
}

/* ********************************************************************************** */
/**
 * @brief La surcharge de l'operateur == permet d'utiliser la méthode contains().
 * @param data: second operande.
 * @return TRUE si le "texte" des deux suggestions est identique.
 */
bool Suggestion::operator== (const Suggestion &data) const
{
    // As a member function, when binary operator is overloaded, the initial parameter required is a pointer to this.
    // Even though the signature defines operator== to take three arguments, it can only accommodate two.
    return (this->text == data.text);
}
