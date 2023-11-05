#include "SuggestionModel.h"


/* ********************************************************************************** */
/**
 * @brief Contructor
 * @param parent
 */
SuggestionModel::SuggestionModel(QObject *parent) : QAbstractListModel{parent}
{}

/* ********************************************************************************** */
/**
 * @brief rowCount returns the number of elements in the model. Implémentation obligatoire.
 * @param parent: parent of the model
 * @return the number of elements in the model
 */
int SuggestionModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;
    return m_suggestions.count();
}


/* ********************************************************************************** */
/**
 * @brief The method data() returns the requeted role value of an element of the model. Implémentation obligatoire.
 * @param index: index of the element of the model
 * @param role: the requested role (enum)
 * @return the value of the role for this element.
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
    case TypeRole:      return data.itemType;
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
        {TypeRole,      "type"},
        {PhotosRole,    "photos"}
    };
    return mapping;
}


/* ********************************************************************************** */
/**
 * @brief This append() method adds a suggestion to the model.
 * @param text: text of the suggestion
 * @param target: the name of the Exif tag compatible with this suggestion
 * @param item_type: the type of the suggestion (enum)
 */
void SuggestionModel::append(const QString text, const QString target, const Suggestion::ItemType item_type)
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
    qDebug()<< "Adding suggestion " << text << "for" << m_selectedPhotoRow;;
    Suggestion* new_suggestion = new Suggestion(text, target, item_type, m_selectedPhotoRow);
    const int rowOfInsert = m_suggestions.count();
    // On ajoute la suggestion à la liste
    beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
    m_suggestions.insert(rowOfInsert, *new_suggestion);
    endInsertRows();
}


/* ********************************************************************************** */
/**
 * @brief La méthode addCurrentPhotoToSuggestion() ajoute la photo actuellement sélectionnée
 * à la liste des photos ayant un "match" avec cette suggestion.
 * @param row: l'indice de la suggestion à modifier
 */
void SuggestionModel::addCurrentPhotoToSuggestion(int row)
{
    if (row<0) return;
    // On ajoute la photo courante dans la liste.
    m_suggestions[row].photos << m_selectedPhotoRow;
    // Emit signal
    QModelIndex index = this->index(row, 0);;
    emit dataChanged(index, index, QVector<int>() << PhotosRole);
}


/* ********************************************************************************** */
/**
 * @brief Le slot onSelectedPhotoChanged() reçoit et mémorise la position dans le modèle de la photo sélectionnée dans la ListView.
 * @param row: La position dans PhotoModel de la photo active
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
 * @param data: second operande
 * @return TRUE si le "texte" des deux suggestions est identique */
bool Suggestion::operator== (const Suggestion &data) const
{
    // As a member function, when binary operator is overloaded, the initial parameter required is a pointer to this.
    // Even though the signature defines operator== to take three arguments, it can only accommodate two.
    return (this->text == data.text);
}
