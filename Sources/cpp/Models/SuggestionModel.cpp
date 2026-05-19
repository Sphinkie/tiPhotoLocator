#include <QSettings>
#include <QDir>
#include <QUrl>
#include <QDate>
#include <QFile>
#include <QTextStream>
#include <QRegularExpression>
#include "SuggestionModel.h"
#include "../utilities.h"


/** **********************************************************************************************************
 * @brief Contructor.
 * @param parent object.
 * ***********************************************************************************************************/
SuggestionModel::SuggestionModel(QObject *parent) : QAbstractListModel{parent}
{
    this->createInitialSuggestions();
}


/** **********************************************************************************************************
 * @brief Ajoute au modèle quelques suggestions basiques.
 * ***********************************************************************************************************/
void SuggestionModel::createInitialSuggestions()
{
    QSettings settings;
    QString photographe = settings.value("photographe","").toString();
    QString initiales   = settings.value("initiales","").toString();
    QString homeCity    = settings.value("homecity"," ").toString();
    QString homeCountry = settings.value("homeCountry"," ").toString();
    if (homeCity.isEmpty()) homeCity= " ";
    if (homeCountry.isEmpty()) homeCountry= " ";

    this->append(photographe, "creator", "tag", -1);
    this->append(initiales,   "captionWriter", "tag", -1);
    this->append(homeCountry, "country", "tag", -1);
    this->append(homeCity,    "city", "tag", -1);
    this->append(" ",         "location", "tag", -1);
    this->append(tr("who ? where ?"), "description", "tag", -1);
    // Ajout des keywords définis dans les ressources.
    int tagLanguage = settings.value("tagLanguage", 0).toInt();
    this->loadKeywordsFromFile(tagLanguage == 0 ? "eng" : "fre");
    this->loadKeywordsFromSettings();
}


/** **********************************************************************************************************
 * @brief Charge les keywords personalisés depuis les settings.
 * ***********************************************************************************************************/
void SuggestionModel::loadKeywordsFromSettings()
{
    QSettings settings;
    const QString csv_keywords = settings.value("customKeywords", "").toString();
    if (csv_keywords.isEmpty()) return;
    const QStringList keywords = csv_keywords.split(',', Qt::SkipEmptyParts);
    for (const QString &kw : keywords)
    {
        const QString trimmed = kw.trimmed();
        if (!trimmed.isEmpty())
            this->append(trimmed, "keywords", "tag", -1);
    }
}


/** **********************************************************************************************************
 * @brief Charge les keywords prédéfinis depuis un fichier ressource (un fichier par langue).
 * @param lang : code de langue ("eng" ou "fre").
 * ***********************************************************************************************************/
void SuggestionModel::loadKeywordsFromFile(const QString &lang)
{
    QFile file(QString(":/Keywords/keywords.%1").arg(lang));
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;
    QTextStream in(&file);
    while (!in.atEnd())
    {
        QString line = in.readLine().trimmed();
        if (!line.isEmpty())
            this->append(line, "keywords", "tag", -1);
    }
}


/** **********************************************************************************************************
 * @brief Returns the number of elements in the model.
 * @note Implémentation obligatoire.
 * @param parent: parent of the model
 * ***********************************************************************************************************/
int SuggestionModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;
    return m_suggestions.count();
}


/** **********************************************************************************************************
 * @brief Returns the requested role value of an element of the model.
 * @note Implémentation obligatoire.
 * @param index: index of the element of the model.
 * @param role: the requested role (enum).
 * ***********************************************************************************************************/
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


/** **********************************************************************************************************
 * @brief Table of Role names.
 * @note Implémentation obligatoire.
 * @details C'est la correspondance entre le role C++ et le nom de la property dans QML.
 * ***********************************************************************************************************/
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


/** *********************************************************************************************************
 * @brief surcharge.
 * **********************************************************************************************************/
Qt::ItemFlags SuggestionModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return (Qt::ItemIsEditable | Qt::ItemIsEnabled | Qt::ItemIsSelectable);
}


/** **********************************************************************************************************
 * @brief Adds a suggestion to the model.
 *        Ce slot permet à n'importe qui d'ajouter une Suggestion. Il y a un controle pour éviter les doublons.
 *
 * @param text: The text of the Suggestion.
 * @param target: The name of the Exif tag compatible with this Suggestion.
 * @param category: The category of the Suggestion ("geo", "tag", "geo|tag")
 * @param photo_row: L'indice de la Photo à associer à cette Suggestion.
 *                   La valeur spéciale -1 signifie 'toutes les photos'.
 *                   La valeur spéciale -2 signifie 'la Photo courante' (valeur par défaut).
 * ***********************************************************************************************************/
void SuggestionModel::append(const QString& text, const QString& target, const QString& category, int photo_row)
{
    if (text.isEmpty()) return;

    // On parcourt toutes les suggestions pour voir si elle est dejà référencée.
    for (int i=0; i<m_suggestions.count(); i++ )
    {
        if ( (m_suggestions.at(i).text == text) && (m_suggestions.at(i).target == target))
        {
            // Si la suggestion existe dejà (même texte et même target)
            // On ajoute la categorie à la suggestion (au cas où la catégorie serait différente)
            this->addCategoryToSuggestion(i, category);
            // On ajoute la photo à la liste
            this->addPhotoToSuggestion(i, photo_row);
            return;
        }
    }
    // A la fin de la boucle, on ne l'a pas trouvé: il s'agit donc d'une nouvelle suggestion
    if (photo_row == -2)
    {
        // si le numéro de la photo n'est pas fourni, on prend la photo courante dans la ListView.
        photo_row = m_currentPhotoRow;
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


/** **********************************************************************************************************
 * @brief Ajoute une Photo à la liste des photos ayant un "match" avec cette Suggestion.
 * La suggestion apparait alors dans la Zone des Suggestions pour cette Photo.
 * @param suggestion_row : L'indice de la Suggestion à modifier.
 * @param photo_row : L'indice de la Photo à ajouter à la Suggestion.
 *                   La valeur spéciale -1 signifie 'toutes les photos'.
 *                   La valeur spéciale -2 signifie 'la Photo sélectionée'.
 * ***********************************************************************************************************/
void SuggestionModel::addPhotoToSuggestion(const int suggestion_row, int photo_row)
{
    if (suggestion_row<0 || suggestion_row>m_suggestions.count()) return;
    if (photo_row == -2)
    {
        photo_row = m_currentPhotoRow;
    }
    // On ajoute la photo courante dans la liste (comme c'est un Qset, il n'y a pas de doublons).
    m_suggestions[suggestion_row].photos << photo_row;
    // Emit signal
    QModelIndex index = this->index(suggestion_row, 0);;
    emit dataChanged(index, index, QVector<int>() << PhotosRole);
}


/** **********************************************************************************************************
 * @brief Ajoute une catégorie à la Suggestion.
 * @param suggestion_row : L'indice de la Suggestion à modifier.
 * @param category : La catégorie à ajouter à la Suggestion: "geo" ou "tag".
 *
 * Si on veut ajouter une catégorie déjà existante: la fonction ne fait rien.
 * Si on veut ajouter une autre catégorie: la catégorie devient "geo|tag" (les deux).
 * ***********************************************************************************************************/
void SuggestionModel::addCategoryToSuggestion(const int suggestion_row, const QString category)
{
    if (suggestion_row<0 || suggestion_row>m_suggestions.count()) return;

    if (m_suggestions[suggestion_row].category != category)
    {
        m_suggestions[suggestion_row].category = "geo|tag";
    }
    // Emit signal
    QModelIndex index = this->index(suggestion_row, 0);
    emit dataChanged(index, index, QVector<int>() << CategoryRole);
}


/** **********************************************************************************************************
 * @brief Enlève la Photo courante de la liste des photos correspondant à une Suggestion donnée par son index.
 * @param index : L'index dans le Model de la Suggestion à modifier.
 * Note: la suggestion existe toujours: on a juste enlevé la photo courante de ses photos associées:
 * donc elle n'apparait plus dans la Zone des Suggestions pour cette Photo.
 * ***********************************************************************************************************/
void SuggestionModel::removeCurrentPhotoFromSuggestion(const QModelIndex index)
{
    if (! index.isValid()) return;
    // On retire la photo courante de la liste.
    int row = index.row();
    m_suggestions[row].photos.remove(m_currentPhotoRow);
    // Emit signal
    emit dataChanged(index, index, QVector<int>() << PhotosRole);
}

/** **********************************************************************************************************
 * @brief Enlève la Photo courante de la liste des photos correspondant à une Suggestion donnée par sa Target.
 * @param target : la suggestion à enlever, par exemple "city", "country"...
 * Note: la suggestion existe toujours: on a juste enlevé la photo courante de ses photos associées:
 * donc elle n'apparait plus dans la Zone des Suggestions pour cette Photo.
 * ***********************************************************************************************************/
void SuggestionModel::removeFromSuggestion(const QString target)
{
    // On trouve la (ou les) suggestion(s) demandées
    for (int row=0; row<m_suggestions.count(); row++ )
    {
        // qDebug() << m_suggestions.at(row).target <<  m_suggestions.at(row).text;
        if (m_suggestions.at(row).target == target)
        {
            // Trouvé: On retire la photo de la suggestion
            m_suggestions[row].photos.remove(m_currentPhotoRow);
            // Emit signal : la liste des suggestions a changé
            emit dataChanged(index(row), index(row), QVector<int>() << PhotosRole);
        }
    }
}


/** **********************************************************************************************************
 * @brief Ce slot reçoit et mémorise l'indice dans le modèle de la photo courante de la ListView.
 * @param row: La position dans PhotoModel de la photo active.
 * ***********************************************************************************************************/
void SuggestionModel::onCurrentPhotoChanged(const int row)
{
    if (row<0) return;
    // On mémorise la photo courante de la ListView.
    m_currentPhotoRow = row;
}


/** **********************************************************************************************************
 * @brief Extrait date, lieu et commentaires du nom du dossier et les ajoute comme suggestions globales.
 *        Format attendu : YYYY[-. ]MM[-. ]<lieu>[-. ](<commentaires>)
 *        Valeurs par défaut si la date est absente: date courante.
 * @param folderUrl: URI du dossier (format "file:///...").
 * ***********************************************************************************************************/
void SuggestionModel::setDefaultDateFromFolder(const QString &folderUrl)
{
    QString folderName = QDir(QUrl(folderUrl).toLocalFile()).dirName();
    QRegularExpression re(R"((\d{4})[-\. ]+(\d{1,2})[-\. ]*(.*))");
    QRegularExpressionMatch match = re.match(folderName);

    // --- Date ---
    QString dateStr;
    if (match.hasMatch())
    {
        int year  = match.captured(1).toInt();
        int month = match.captured(2).toInt();
        dateStr = QString("%1:%2:15 12:00:00").arg(year, 4, 10, QChar('0')).arg(month, 2, 10, QChar('0'));
    }
    else
    {
        dateStr = QDate::currentDate().toString("yyyy:MM:dd") + " 00:00:00";
    }
    this->append(Utilities::toReadableDateTime(dateStr), "dateTimeOriginal", "tag", -1);

    if (!match.hasMatch()) return;

    // --- Lieu et commentaires ---
    QString rest = match.captured(3).trimmed();
    QString location, description;
    QRegularExpression commentRe(R"(^(.*?)\s*\(([^)]+)\)\s*$)");
    QRegularExpressionMatch commentMatch = commentRe.match(rest);
    if (commentMatch.hasMatch())
    {
        location    = commentMatch.captured(1).trimmed();
        description = commentMatch.captured(2).trimmed();
    }
    else
    {
        location = rest;
    }

    // On ajoute les suggestions
    if (!location.isEmpty())
    {
        this->append(location, "location", "tag", -1);
        m_folderLocation = location;
        emit folderLocationChanged();
    }
    if (!description.isEmpty())
        this->append(description, "description", "tag", -1);
}


/** **********************************************************************************************************
 * @brief Debug function that print (in the console) one line of the model at every call.
 * ***********************************************************************************************************/
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

/** **********************************************************************************************************
 * @brief Deletes all the items of the Model.
 * @details On utilise cette fonction quand on scanne un nouveau répertoire de photos.
 * ***********************************************************************************************************/
void SuggestionModel::clear()
{
    beginResetModel();  // cette méthode envoie un signal indiquant à tous que ce modèle va subir un changement radical
    m_suggestions.clear();
    this->createInitialSuggestions();
    m_currentPhotoRow = -4;
    m_folderLocation  = "";
    emit folderLocationChanged();
    endResetModel();    // cette méthode envoie un signal ModelReset.
}


/** **********************************************************************************************************
 * @brief Operateur de comparaison.
 * @note Cet operateur == permet d'utiliser la méthode Contains().
 * @param suggestion: Second operande.
 * @return True si le \b texte des deux suggestions est identique.
 * ***********************************************************************************************************/
bool Suggestion::operator== (const Suggestion &suggestion) const
{
    // As a member function, when binary operator is overloaded, the initial parameter required is a pointer to this.
    // Even though the signature defines operator== to take three arguments, it can only accommodate two.
    return (this->text == suggestion.text);
}


