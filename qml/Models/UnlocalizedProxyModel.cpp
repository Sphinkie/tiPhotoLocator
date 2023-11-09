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
 * \brief filterEnabled indique si le filtre est actif ou non.
 * \return TRUE si le filtre est actif.
 */
bool UnlocalizedProxyModel::filterEnabled() const
{
    return (this->filterRegularExpression().pattern() == "false");
}


/* ************************************************************************ */
/*!
 * \brief Le slot setFilterEnabled active ou désactive le filtrage par le ProxyModel.
 * \param enabled : TRUE pour activer le filtrage
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

