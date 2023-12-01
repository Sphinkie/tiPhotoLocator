#include<QDebug>
#include "PhotoModel.h"
#include "UnlocalizedProxyModel.h"

#define QT_NO_DEBUG_OUTPUT




/* ************************************************************************ */
/*!
 * \brief Contructeur. Pour ce proxy modèle assez simple, on utilise les fonctions basiques fournies par Qt.
 * \param parent : modèle source
 */
UnlocalizedProxyModel::UnlocalizedProxyModel(QObject *parent) : QSortFilterProxyModel(parent)
{
    this->setFilterRole(PhotoModel::HasGPSRole);
    this->setFilterFixedString(""); // accept all
}


/* ************************************************************************ */
/*!
 * \brief Cette méthode indique si le filtrage est actif ou non.
 * \returns true si le filtre est actif.
 */
bool UnlocalizedProxyModel::filterEnabled() const
{
    return (this->filterRegularExpression().pattern() == "false");
}


/* ************************************************************************ */
/*!
 * \brief Le slot setFilterEnabled() active ou désactive le filtrage par le ProxyModel.
 * \param enabled : true pour activer le filtrage
 */
void UnlocalizedProxyModel::setFilterEnabled(bool enabled)
{
    if (enabled)
        this->setFilterFixedString("false");
    else
        this->setFilterFixedString("");

    emit filterEnabledChanged();
    invalidateFilter();
}


/* ************************************************************************ */
/*!
 * \brief La fonction getSourceIndex() renvoie l'indice de la Photo dans le modèle source.
 * \param  row : indice de la photo dans ce proxyModel.
 * \return l'indice de la photo dans le sourceModel.
 */
int UnlocalizedProxyModel::getSourceIndex(int row)
{
    // On convertit l'indice proxyModel vers un indice sourceModel
    QModelIndex sourceIndex = mapToSource(index(row,0));
    return sourceIndex.row();
}
