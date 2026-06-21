#include<QDebug>
#include "PhotoModel.h"
#include "SelectedPhotoProxyModel.h"

#define QT_NO_DEBUG_OUTPUT


/** **********************************************************************************************************
 * @brief Contructeur. Pour ce proxy modèle assez simple, on utilise les fonctions basiques fournies par Qt.
 *        Le role à filtrer est "isSelected". Par défaut, le filtrage est inactif.
 * @param parent : modèle source
 * ***********************************************************************************************************/
SelectedPhotoProxyModel::SelectedPhotoProxyModel(QObject *parent) : QSortFilterProxyModel(parent)
{
    this->setFilterRole(PhotoModel::IsSelectedRole);
    this->setFilterEnabled(false);    // accept all
}


/** **********************************************************************************************************
 * @brief Cette méthode indique si le filtrage est actif ou non.
 * @returns true si le filtre est actif.
 * ***********************************************************************************************************/
bool SelectedPhotoProxyModel::filterEnabled() const
{
    return !(this->filterRegularExpression().pattern() == "");
}


/** **********************************************************************************************************
 * @brief Ce slot active ou désactive le filtrage par le proxyModel.
 * @param enabled : true pour activer le filtrage
 * ***********************************************************************************************************/
void SelectedPhotoProxyModel::setFilterEnabled(bool enabled)
{
    beginFilterChange();
    if (enabled)
        this->setFilterFixedString("true");   // accepte uniquement les Photos avec isSelected = "true"
    else
        this->setFilterFixedString("");        // accept all
    endFilterChange();
    emit filterEnabledChanged();
}


/** **********************************************************************************************************
 * @brief Cette fonction renvoie l'indice dans ce proxyModel pour un indice du modèle source donné.
 * @param  sourceRow : L'indice de la Photo dans le \b sourceModel PhotoModel.
 * @return l'indice dans ce \b proxyModel, ou -1 si la ligne est filtrée.
 * ***********************************************************************************************************/
int SelectedPhotoProxyModel::getProxyIndex(int sourceRow)
{
    const QModelIndex proxyIndex = mapFromSource(sourceModel()->index(sourceRow, 0));
    return proxyIndex.isValid() ? proxyIndex.row() : -1;
}


/** **********************************************************************************************************
 * @brief Cette fonction renvoie l'indice de la Photo dans le modèle source.
 * @param  row : L'indice de la Photo dans ce \b proxyModel.
 * @return l'indice de la Photo dans le \b sourceModel PhotoModel.
 * ***********************************************************************************************************/
int SelectedPhotoProxyModel::getSourceIndex(int row)
{
    // qDebug() << "SelectedPhotoProxyModel::getSourceIndex";

    // On convertit l'indice vers un indice de la source
    QModelIndex sourceIndex = mapToSource(index(row,0));
    // on a l'index dans le modele source, mais on ne sait pas si cette source est un Proxy ou le Model
    auto underneath_model = this->sourceModel();

    // Si le underneath_model est PhotoModel, on retourne l'indice
    if (!strcmp (underneath_model->metaObject()->className(), "PhotoModel"))
    {
        // qDebug() << "La source est un Model: on remonte son index";
        return sourceIndex.row();
    }
    else
    {
        // qDebug() << "La source est un Proxy";
        // Ce cas n'est plus d'actualité avec la nouvelle architecture en v1.4 : il n'y a plus de proxy empilés.
        // On garde le code comme modèle pour une autre fois.
        auto proxy_model = dynamic_cast<SelectedPhotoProxyModel*>(underneath_model); // Mettre ici le PoxyModel du dessous.
        return proxy_model->getSourceIndex(sourceIndex.row());
    }
    // On fait ce traitement un peu compliqué, pour ne pas être contraint dans l'ordre où les proxyModels sont empilés.
}
