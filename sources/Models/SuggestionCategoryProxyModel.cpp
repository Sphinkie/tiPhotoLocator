#include<QDebug>
#include "SuggestionModel.h"
#include "SuggestionProxyModel.h"
#include "SuggestionCategoryProxyModel.h"

#define QT_NO_DEBUG_OUTPUT


/** **********************************************************************************************************
 * @brief Contructeur. Pour ce proxy modèle assez simple, on utilise les fonctions basiques fournies par Qt.
 *        Le role à filtrer est "category". Par défaut, le filtrage est inactif (tout passe).
 * @param parent : modèle source.
 * ***********************************************************************************************************/
SuggestionCategoryProxyModel::SuggestionCategoryProxyModel(QObject *parent) : QSortFilterProxyModel(parent)
{
    this->setFilterRole(SuggestionModel::CategoryRole);
    this->setFilterValue();
}

/** **********************************************************************************************************
 * @brief Cette méthode indique si le filtrage est actif ou non.
 * @returns true si le filtre est actif.
 * ***********************************************************************************************************/
bool SuggestionCategoryProxyModel::filterEnabled() const
{
    return !(this->filterRegularExpression().pattern().isEmpty());
}


/** **********************************************************************************************************
 * @brief Ce slot active ou désactive le filtrage par le proxyModel.
 * @param enabled : true pour activer le filtrage.
 * ***********************************************************************************************************/
void SuggestionCategoryProxyModel::setFilterEnabled(bool enabled)
{
    if (enabled)
        this->setFilterFixedString(m_filter);
    else
        this->setFilterFixedString(""); // accept all

    emit filterEnabledChanged();
    invalidateFilter();
}


/** **********************************************************************************************************
 * @brief Cette méthode invocable par QML active ou désactive le filtrage par le proxyModel.
 * @param filter : La chaine à garder pour le filtrage. (vide = Accept All)
 *
 * Le filtrage se fait sur la base : Suggestion dont la catégorie contient le mot passé en paramètre.
 * Par exemple, le filtre "tag" laissera passer les catégories "tag" et "geo|tag".
 * ***********************************************************************************************************/
void SuggestionCategoryProxyModel::setFilterValue(QString filter)
{
    // qDebug() << "Filtering on category " << filter;
    m_filter = filter;
    this->setFilterFixedString(filter);
    emit filterEnabledChanged();
    invalidateFilter();
}


/** **********************************************************************************************************
 * @brief Ce slot enlève la photo courante de la liste des photos correspondant à une suggestion donnée.
 * @note On convertit l'indice du ProxyModel dans l'index du sourceModel SuggestionProxyModel.
 * @param proxyRow : Indice dans le ProxyModel de la Suggestion à modifier.
 * ***********************************************************************************************************/
void SuggestionCategoryProxyModel::removePhotoFromSuggestion(const int proxyRow)
{
    if (proxyRow<0) return;
    // On convertit l'indice proxyModel vers l'index sourceModel
    QModelIndex idx = mapToSource(index(proxyRow,0));
    // On retire la photo courante de la liste.
    auto source_model = dynamic_cast<SuggestionProxyModel*>(this->sourceModel());
    source_model->removePhotoFromSuggestion(idx);
}


