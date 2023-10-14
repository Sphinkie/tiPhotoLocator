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

#define QT_NO_DEBUG_OUTPUT

/* *************************************************************************
 * Contructeur
 * *************************************************************************/
SelectedFilterProxyModel::SelectedFilterProxyModel(QObject *parent) : QSortFilterProxyModel(parent)
{
    m_selectedFilterEnabled = true;
}


/**
 * @brief SelectedFilterProxyModel::selectedFilterEnabled indique si le filtre est actif ou non.
 * @return TRUE si le filtre est actif.
 */
bool SelectedFilterProxyModel::selectedFilterEnabled() const
{
    return m_selectedFilterEnabled;
}


/**
 * @brief SelectedFilterProxyModel::setCoords remplace les coords de l'item par celles reçues en paramètre.
 * C'est un SLOT appelé qaund l'utilisateur change la position d'une photo sur la carte.
 * @param lat: latitude au format GPS
 * @param lon: longitude au format GPS
 */
void SelectedFilterProxyModel::setCoords(const double lat, const double lon)
{
    // Normalement, il n'y a qu'un seul item dans cette liste filtrée...
    // TODO: plus maintenant !
    const QModelIndex index0 = this->index(0, 0);
    const double old_lat = index0.data(PhotoModel::LatitudeRole).toDouble();
    const double old_lon = index0.data(PhotoModel::LongitudeRole).toDouble();
    qDebug() << "changing lat coords from " << old_lat << "to" << lat ;
    qDebug() << "changing lon coords from " << old_lon << "to" << lon ;

    // On modifie l'item dans le proxy. (Nécessite l'implémentation de setData() dans le sourceModel).
    setData(index0, lat, PhotoModel::LatitudeRole);
    setData(index0, lon, PhotoModel::LongitudeRole);

    // Vérification
    qDebug() << "ProxyModel" << index0.data(PhotoModel::LatitudeRole).toDouble() << index0.data(PhotoModel::FilenameRole).toString();
//    qDebug() << "source" << index_source.data(PhotoModel::LatitudeRole).toDouble() << index_source.data(PhotoModel::FilenameRole).toString();
}

void setSavedCoordsTo()
{

}

/* *************************************************************************
 * SLOT: Active/Désactive le filtre
 * *************************************************************************/
void SelectedFilterProxyModel::setSelectedFilterEnabled(bool enabled)
{
    if (m_selectedFilterEnabled == enabled)
        return;
    m_selectedFilterEnabled = enabled;
    emit selectedFilterEnabledChanged();
    invalidateFilter();
}


/**
 * @brief SelectedFilterProxyModel::filterAcceptsRow effectue le filtrage (toutes les 10 secondes).
 * Laisse passer la (les) ligne(s) sélectionnée(s) et les marqueurs (aka: Saved Position)
 * @param sourceRow: Le numero d'une ligne du modèle.
 * @param sourceParent
 * @return True si la ligne est acceptée
 */
bool SelectedFilterProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    if (!m_selectedFilterEnabled)
        return true;
    // On récupère l'index de la ligne à accepter ou pas
    const QModelIndex idx = sourceModel()->index(sourceRow, 0, sourceParent);
    // On récupère les données de la ligne
    const bool isSelected = idx.data(PhotoModel::IsSelectedRole).toBool();
    const bool isMarker = idx.data(PhotoModel::IsMarkerRole).toBool();
    qDebug() << "ProxyModel: " << sourceModel() << idx.row() << isMarker ;
    return (isSelected || isMarker);
}
