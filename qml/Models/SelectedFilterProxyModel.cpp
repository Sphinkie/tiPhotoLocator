/*************************************************************************
 *
 * Contraintes:
 * il faut inclure le .h du modèle
 * - donc ce n'est pas reutilisable contrairement à ce que dit Jepersen
 * - le modèle doit être forcement en c++ (et pas en Qml)
 * - donc il faut réimplementer les append(), get(), clear(), etc
 *
 *************************************************************************/

#include<QDebug>
#include "SelectedFilterProxyModel.h"
#include "PhotoModel.h"

// #define QT_NO_DEBUG_OUTPUT

/* *************************************************************************
 * Contructeur
 * *************************************************************************/
SelectedFilterProxyModel::SelectedFilterProxyModel(QObject *parent) : QSortFilterProxyModel(parent)
//    , m_selectedFilterEnabled(true)
{
    m_selectedFilterEnabled=true;
}

/* *************************************************************************
 * Retourne si le filter est actif ou non
 * *************************************************************************/
bool SelectedFilterProxyModel::selectedFilterEnabled() const
{
    return m_selectedFilterEnabled;
}

/* *************************************************************************
 * Active/Désactive le filtre
 * *************************************************************************/
void SelectedFilterProxyModel::setSelectedFilterEnabled(bool enabled)
{
    if (m_selectedFilterEnabled == enabled)
        return;
    m_selectedFilterEnabled = enabled;
    emit selectedFilterEnabledChanged();
    invalidateFilter();
}

/* *************************************************************************
 * Effectue le filtrage (toutes les 10 secondes)
 * @param sourceRow Le numero d'une ligne du modèle
 * @param sourceParent ??
 * @return True si la ligne est acceptée
 * *************************************************************************/
bool SelectedFilterProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    if (!m_selectedFilterEnabled)
        return true;
    // On récupère l'index de la ligne à accepter ou pas
    const QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    // On récupère les données de la ligne
    const bool isSelected = index.data(PhotoModel::IsSelectedRole).toBool();
    const QString name = index.data(PhotoModel::FilenameRole).toString();
    qDebug() << "ProxyModel: " << sourceModel() << isSelected << name ;
    return (isSelected);
}
