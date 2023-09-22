/*************************************************************************
 *
 * Contraintes:
 * il faut inclure le .h du modèle
 * - donc ce n'est pas reutilisable contrairement à ce que dit Jepersen
 * - le modèle doit être forcement en c++ (et pas en Qml)
 * - donc il faut réimplementer les append(), get(), clear(), etc
 *
 *************************************************************************/

#include "selectedFilterProxyModel.h"
#include "PhotoModel.h"

/* *************************************************************************
 * Contructeur
 * *************************************************************************/
selectedFilterProxyModel::selectedFilterProxyModel(QObject *parent) : QSortFilterProxyModel(parent)
    , m_selectedFilterEnabled(true)
{
}

/* *************************************************************************
 * Retourne si le filter est actif ou non
 * *************************************************************************/
bool selectedFilterProxyModel::selectedFilterEnabled() const
{
    return m_selectedFilterEnabled;
}

/* *************************************************************************
 * Active/Désactive le filtre
 * *************************************************************************/
void selectedFilterProxyModel::setSelectedFilterEnabled(bool enabled)
{
    if (m_selectedFilterEnabled == enabled)
        return;

    m_selectedFilterEnabled = enabled;
    emit selectedFilterEnabledChanged();

    invalidateFilter();
}

/* *************************************************************************
 * Effectue le filtrage
 * @param sourceRow Le numero d'une ligne du modèle
 * @param sourceParent L'index du modèle
 * @return True si la ligne est acceptée
 * *************************************************************************/
bool selectedFilterProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    if (!m_selectedFilterEnabled)
        return true;
    // On récupère l'index de la ligne à accepter ou pas
    // const QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    // On regarde si c'est la ligne sélectionnée
    // const QString mediaType = index.data(isSelected).toString();
    // const double lat = index.data(PhotoModel::LatitudeRole).Double;
    int cur = sourceParent.model()->curIndex;
    return (sourceRow == 0);
}
