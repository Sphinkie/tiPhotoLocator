#include<QDebug>
#include "PhotoModel.h"
#include "UnlocalizedProxyModel.h"

#include "UndatedPhotoProxyModel.h"

#define QT_NO_DEBUG_OUTPUT


/** **********************************************************************************************************
 * @brief Contructeur. Pour ce proxy modèle assez simple, on utilise les fonctions basiques fournies par Qt.
 *        Le role à filtrer est "hasGPS". Par défaut, le filtrage est inactif.
 * @param parent : modèle source
 * ***********************************************************************************************************/
UnlocalizedProxyModel::UnlocalizedProxyModel(QObject *parent) : QSortFilterProxyModel(parent)
{
    this->setFilterRole(PhotoModel::HasGPSRole);
    this->setFilterEnabled(false);    // accept all
}


/** **********************************************************************************************************
 * @brief Cette méthode indique si le filtrage est actif ou non.
 * @returns true si le filtre est actif.
 * ***********************************************************************************************************/
bool UnlocalizedProxyModel::filterEnabled() const
{
    return !(this->filterRegularExpression().pattern() == "");
}


/** **********************************************************************************************************
 * @brief Ce slot active ou désactive le filtrage par le proxyModel.
 * @param enabled : true pour activer le filtrage
 * ***********************************************************************************************************/
void UnlocalizedProxyModel::setFilterEnabled(bool enabled)
{
    if (enabled)
        this->setFilterFixedString("false");   // accepte uniquement les Photos avec hasGPS = "false"
    else
        this->setFilterFixedString("");        // accept all

    emit filterEnabledChanged();
    invalidateFilter();
}


/** **********************************************************************************************************
 * @brief Cette fonction renvoie l'indice de la Photo dans le modèle source.
 * @param  row : L'indice de la Photo dans ce \b proxyModel.
 * @return l'indice de la Photo dans le \b sourceModel PhotoModel.
 * ***********************************************************************************************************/
int UnlocalizedProxyModel::getSourceIndex(int row)
{
    qDebug() << "UnlocalizedProxyModel::getSourceIndex";

    // On convertit l'indice vers un indice de la source
    QModelIndex sourceIndex = mapToSource(index(row,0));
    // on a l'index dans le modele source, mais on ne sait pas si cette source est un Proxy ou le Model
    auto underneath_model = this->sourceModel();

    // Si le underneath_model est PhotoModel, on retourne l'indice
    if (!strcmp (underneath_model->metaObject()->className(), "PhotoModel"))
    {
        qDebug() << "La source est un Model: on remonte son index";
        return sourceIndex.row();
    }
    else
    {
        qDebug() << "La source est un Proxy";
        auto proxy_model = dynamic_cast<UndatedPhotoProxyModel*>(underneath_model);
        return proxy_model->getSourceIndex(sourceIndex.row());
    }
}
