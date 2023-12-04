#include<QDebug>
#include "PhotoModel.h"
#include "UnlocalizedProxyModel.h"

#define QT_NO_DEBUG_OUTPUT




/* ************************************************************************ */
/*!
 * \brief Contructeur. Pour ce proxy modèle assez simple, on utilise les fonctions basiques fournies par Qt.
 *        Le role à filtrer est "hasGPS". Par défaut, le filtrage est inactif.
 * \param parent : modèle source
 */
UnlocalizedProxyModel::UnlocalizedProxyModel(QObject *parent) : QSortFilterProxyModel(parent)
{
    this->setFilterRole(PhotoModel::HasGPSRole);
    this->setFilterEnabled(false);    // accept all
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
 * \brief Ce slot active ou désactive le filtrage par le proxyModel.
 * \param enabled : true pour activer le filtrage
 */
void UnlocalizedProxyModel::setFilterEnabled(bool enabled)
{
    if (enabled)
        this->setFilterFixedString("false");   // accepte uniquement les Photos avec hasGPS = "false"
    else
        this->setFilterFixedString("");        // accept all

    emit filterEnabledChanged();
    invalidateFilter();
}


/* ************************************************************************ */
/*!
 * \brief Cette fonction renvoie l'indice de la Photo dans le modèle source.
 * \param  row : L'indice de la Photo dans ce \b proxyModel.
 * \return l'indice de la Photo dans le \b sourceModel.
 */
int UnlocalizedProxyModel::getSourceIndex(int row)
{
    // On convertit l'indice proxyModel vers un indice sourceModel
    QModelIndex sourceIndex = mapToSource(index(row,0));
    return sourceIndex.row();
}
