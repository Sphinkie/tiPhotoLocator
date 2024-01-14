#include <QSettings>
#include "SuggestionModel.h"




/* ********************************************************************************** */
/*!
 * \brief Contructor.
 * \param parent object.
 */
SuggestionModel::SuggestionModel(QObject *parent) : QAbstractListModel{parent}
{
    QSettings settings;
    QString photographe = settings.value("photographe","").toString();
    QString initiales   = settings.value("initiales","").toString();
    this->append(photographe, "creator", "tag", -1);
    this->append(" ", "description", "tag", -1);
    this->append(initiales,   "captionWriter", "tag", -1);
    this->append("paysage",   "keywords", "tag", -1);
    this->append("portrait",  "keywords", "tag", -1);
    this->append("urbanisme", "keywords", "tag", -1);
    this->append("nature",    "keywords", "tag", -1);
    this->append("animaux",   "keywords", "tag", -1);
}


/* ********************************************************************************** */
/*!
 * \brief Returns the number of elements in the model.
 * \note: Implémentation obligatoire.
 * \param parent: parent of the model
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
 * \param index: index of the element of the model.
 * \param role: the requested role (enum).
 */
QVariant SuggestionModel::data(const QModelIndex &index, int role) const
{
    if ( !index.isValid() )
        return QVariant();

    const Suggestion &suggestion = m_suggestions.at(index.row());

    switch(role)
    {
    case TextRole:      return suggestion.text;
    case TargetRole:    return suggestion.target;
    case CategoryRole:  return suggestion.category;
    case PhotosRole:    return QVariant::fromValue(suggestion.photos);   // returns a QVariant containing a copy of value.  (lecture: liste = variant.value<QList<int>>();)
    default:
        return QVariant();
    }
}

/* ********************************************************************************** */
/*!
 * \brief Table of Role names.
 * \note Implémentation obligatoire.
 * \details C'est la correspondance entre le role C++ et le nom de la property dans QML.
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


/* ********************************************************************************************************** */
Qt::ItemFlags SuggestionModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return (Qt::ItemIsEditable | Qt::ItemIsEnabled | Qt::ItemIsSelectable);
}

/* ********************************************************************************** */
/*!
 * \brief Adds a suggestion to the model.
 *        Ce slot permet à n'importe qui d'ajouter une Suggestion.
 *
 * \param text: The text of the Suggestion.
 * \param target: The name of the Exif tag compatible with this Suggestion.
 * \param category: The category of the Suggestion ("geo", "tag", "geo|tag")
 * \param photo_row: L'indice de la Photo à associée à cette Suggestion.
 *                   La valeur spéciale -1 signifie 'toutes les photos'.
 *                   La valeur spéciale -2 signifie 'la Photo sélectionée' (valeur par défaut).
 */
void SuggestionModel::append(const QString text, const QString target, const QString category, int photo_row)
{
    if (text.isEmpty()) return;

    for (int i=0; i<m_suggestions.count(); i++ )
    {
        if ( (m_suggestions.at(i).text == text) && (m_suggestions.at(i).target == target))
        {
            // Trouvé: la suggestion existe dejà (même texte et même target)
            // On ajoute la categorie à la suggestion (au cas où la catégorie serait différente)
            this->addCategoryToSuggestion(i, category);
            // On ajoute la photo à la liste
            this->addPhotoToSuggestion(i, photo_row);
            return;
        }
    }
    // A la fin de la boucle, on ne l'a pas trouvé: il s'agit donc d'un nouvelle suggestion
    if (photo_row == -2)
    {
        // si le numéro de la photo n'est pas fourni, on prend la photo sélectionnée dans la ListView.
        photo_row = m_selectedPhotoRow;
    }
    // On ajoute la photo à la suggestion
    // qDebug()<< "Adding" << target <<  "(" << category << ") suggestion " << text << "for" << photo_row;
    Suggestion* new_suggestion = new Suggestion(text, target, category, photo_row);
    const int rowOfInsert = m_suggestions.count();
    // On ajoute la suggestion à la liste
    beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
    m_suggestions.insert(rowOfInsert, *new_suggestion);
    endInsertRows();
}

/* ********************************************************************************** */
/*!
 * \brief Ajoute une Photo à la liste des photos ayant un "match" avec cette Suggestion.
 * \param suggestion_row : L'indice de la Suggestion à modifier.
 * \param photo_row : L'indice de la Photo à ajouter à la Suggestion.
 *                   La valeur spéciale -1 signifie 'toutes les photos'.
 *                   La valeur spéciale -2 signifie 'la Photo sélectionée'.
 */
void SuggestionModel::addPhotoToSuggestion(const int suggestion_row, int photo_row)
{
    if (suggestion_row<0 || suggestion_row>m_suggestions.count()) return;
    if (photo_row == -2)
    {
        photo_row = m_selectedPhotoRow;
    }
    // On ajoute la photo courante dans la liste.
    m_suggestions[suggestion_row].photos << photo_row;
    // Emit signal
    QModelIndex index = this->index(suggestion_row, 0);;
    emit dataChanged(index, index, QVector<int>() << PhotosRole);
}

/* ********************************************************************************** */
/*!
 * \brief Ajoute une catégorie à la Suggestion.
 * \param suggestion_row : L'indice de la Suggestion à modifier.
 * \param category : La catégorie à ajouter à la Suggestion: "geo" ou "tag".
 *
 * Si on veut ajouter la catégorie déjà existante : on ne fait rien.
 * Si on veut ajouter une autre catégorie : la catégorie devient "geo|tag" (les deux).
 */
void SuggestionModel::addCategoryToSuggestion(const int suggestion_row, const QString category)
{
    if (suggestion_row<0 || suggestion_row>m_suggestions.count()) return;

    if (m_suggestions[suggestion_row].category != category)
    {
        m_suggestions[suggestion_row].category = "geo|tag";
    }
    // Emit signal
    QModelIndex index = this->index(suggestion_row, 0);;
    emit dataChanged(index, index, QVector<int>() << CategoryRole);
}

/* ********************************************************************************** */
/*!
 * \brief Ce slot enlève la Photo courante de la liste des photos correspondant à une Suggestion donnée.
 * \param index : L'index dans le Model de la suggestion à modifier.
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
/*!
 * \brief Ce slot reçoit et mémorise la position dans le modèle de la photo sélectionnée dans la ListView.
 * \param row: La position dans PhotoModel de la photo active.
 */
void SuggestionModel::onSelectedPhotoChanged(const int row)
{
    if (row<0) return;
    // On mémorise la photo actuellement sélectionnée dans la ListView
    m_selectedPhotoRow = row;
}

/* ********************************************************************************************************** */
/*!
 * \brief Debug function that print (in the console) one line of the model at every call.
 */
void SuggestionModel::dumpData()
{
    if (m_dumpedRow>=m_suggestions.count()) {
        qDebug() << "dump completed";
        m_dumpedRow = 0;
        return;
    }
    qDebug() << m_suggestions[m_dumpedRow].category << m_suggestions[m_dumpedRow].target << m_suggestions[m_dumpedRow].text << m_suggestions[m_dumpedRow].photos;
    m_dumpedRow++;
}


/* ********************************************************************************** */
/*!
 * \brief Operateur de comparaison.
 * \note Cet operateur == permet d'utiliser la méthode Contains().
 * \param suggestion: Second operande.
 * \return True si le \b texte des deux suggestions est identique.
 */
bool Suggestion::operator== (const Suggestion &suggestion) const
{
    // As a member function, when binary operator is overloaded, the initial parameter required is a pointer to this.
    // Even though the signature defines operator== to take three arguments, it can only accommodate two.
    return (this->text == suggestion.text);
}


