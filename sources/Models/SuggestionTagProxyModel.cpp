#include<QDebug>
#include "SuggestionModel.h"
#include "SuggestionTagProxyModel.h"

#define QT_NO_DEBUG_OUTPUT



/* ************************************************************************ */
/*!
 * \brief Contructeur. Pour ce proxy modèle assez simple, on utilise les fonctions basiques fournies par Qt.
 *        Le role à filtrer est "category". Par défaut, le filtrage est actif.
 * \param parent : modèle source
 */
SuggestionTagProxyModel::SuggestionTagProxyModel(QObject *parent) : QSortFilterProxyModel(parent)
{
    this->setFilterRole(SuggestionModel::CategoryRole);
    this->setFilterEnabled(true);
}


/* ************************************************************************ */
/*!
 * \brief Cette méthode indique si le filtrage est actif ou non.
 * \returns true si le filtre est actif.
 */
bool SuggestionTagProxyModel::filterEnabled() const
{
    return (this->filterRegularExpression().pattern() == "tag");
}


/* ************************************************************************ */
/*!
 * \brief Ce slot active ou désactive le filtrage par le proxyModel.
 * \param enabled : true pour activer le filtrage
 */
void SuggestionTagProxyModel::setFilterEnabled(bool enabled)
{
    if (enabled)
        this->setFilterFixedString("tag");   // accepte uniquement les Suggestion avec category = "tag"
    else
        this->setFilterFixedString("");        // accept all

    emit filterEnabledChanged();
    invalidateFilter();
}
