#include<QDebug>
#include "PhotoModel.h"
#include "UndatedPhotoProxyModel.h"

#define QT_NO_DEBUG_OUTPUT




/* ************************************************************************ */
/* **********************************************************************************************************
 * @brief Contructeur. Pour ce proxy modèle assez simple, on utilise les fonctions basiques fournies par Qt.
 *        Le role à filtrer est "DateTimeOriginal". Par défaut, le filtrage est inactif.
 * @param parent : modèle source
 */
UndatedPhotoProxyModel::UndatedPhotoProxyModel(QObject *parent) : QSortFilterProxyModel(parent)
{
    this->setFilterRole(PhotoModel::DateTimeOriginalRole);
    this->setFilterEnabled(false);    // accept all
}


/* ************************************************************************ */
/* **********************************************************************************************************
 * @brief Cette méthode indique si le filtrage est actif ou non.
 * \returns true si le filtre est actif.
 */
bool UndatedPhotoProxyModel::filterEnabled() const
{
    return !(this->filterRegularExpression().pattern().isEmpty());
}


/* ************************************************************************ */
/* **********************************************************************************************************
 * @brief Ce slot active ou désactive le filtrage par le proxyModel.
 * @param enabled : true pour activer le filtrage
 */
void UndatedPhotoProxyModel::setFilterEnabled(bool enabled)
{
    if (enabled)
        this->setFilterRegularExpression("^$"); // accepte uniquement les Photos avec datatime vide
    else
        this->setFilterRegularExpression("");   // accept all

    emit filterEnabledChanged();
    invalidateFilter();
}


/* ************************************************************************ */
/* **********************************************************************************************************
 * @brief Cette fonction renvoie l'indice de la Photo dans le modèle source.
 * @param  row : L'indice de la Photo dans ce \b proxyModel.
 * \return l'indice de la Photo dans le \b sourceModel.
 */
int UndatedPhotoProxyModel::getSourceIndex(int row)
{
    qDebug() << "UndatedPhotoProxyModel::getSourceIndex";

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
    // Sinon, on lui transfère la demande.
    else
    {
        qDebug() << "La source est un Proxy";
        auto proxy_model = dynamic_cast<UndatedPhotoProxyModel*>(underneath_model);
        return proxy_model->getSourceIndex(sourceIndex.row());
    }

    // On fait ce traitement un peu compliqué, pour ne pas être contraint dans l'ordre où les proxyModels sont empilés.
}
