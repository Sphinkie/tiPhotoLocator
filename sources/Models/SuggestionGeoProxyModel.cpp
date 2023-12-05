#include<QDebug>
#include "SuggestionModel.h"
#include "SuggestionGeoProxyModel.h"

#define QT_NO_DEBUG_OUTPUT



/* ************************************************************************ */
/*!
 * \brief Contructeur. Pour ce proxy modèle assez simple, on utilise les fonctions basiques fournies par Qt.
 *        Le role à filtrer est "category". Par défaut, le filtrage est actif.
 * \param parent : modèle source
 */
SuggestionGeoProxyModel::SuggestionGeoProxyModel(QObject *parent) : QSortFilterProxyModel(parent)
{
    this->setFilterRole(SuggestionModel::CategoryRole);
    this->setFilterEnabled(true);
}


/* ************************************************************************ */
/*!
 * \brief Cette méthode indique si le filtrage est actif ou non.
 * \returns true si le filtre est actif.
 */
bool SuggestionGeoProxyModel::filterEnabled() const
{
    return (this->filterRegularExpression().pattern() == "geo");
}


/* ************************************************************************ */
/*!
 * \brief Ce slot active ou désactive le filtrage par le proxyModel.
 * \param enabled : true pour activer le filtrage
 */
void SuggestionGeoProxyModel::setFilterEnabled(bool enabled)
{
    if (enabled)
        this->setFilterFixedString("geo");   // accepte uniquement les Suggestions avec category = "geo" et "geo|tag"
    else
        this->setFilterFixedString("");      // accept all

    emit filterEnabledChanged();
    invalidateFilter();
}
