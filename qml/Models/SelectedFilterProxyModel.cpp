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
 * @brief Le slot SelectedFilterProxyModel::setAllCoords affecte les coordonnées GPS fournies à toutes les photos
 * du modèle filtré (hors saved position).
 * Ce slot appelé quand l'utilisateur change la position d'une photo sur la carte.
 * C'est un peu mieux de le faire ici, car on ne parcourt pas toutes les photos du modèle source, mais seulement celle du modèle filtré.
 * @param lati; latitude au format GPS
 * @param longi: longitude au format GPS
 */
void SelectedFilterProxyModel::setAllItemsCoords(const double lat, const double lon)
{
    // On parcourt tous les items du modèle FILTRÉ (par leur index dans le modèle)
    int row = 0;
    QModelIndex idx = this->index(row, 0);
    while (idx.isValid())
    {
        // qDebug() << "ProxyModel index" << row;
        // Si l'item n'est pas la SavedPosition, on modifie ses coords GPS
        if (!idx.data(PhotoModel::IsMarkerRole).toBool())
        {
            //const double old_lat = index0.data(PhotoModel::LatitudeRole).toDouble();
            //const double old_lon = index0.data(PhotoModel::LongitudeRole).toDouble();
            //qDebug() << "changing lat coords from " << old_lat << "to" << lat ;
            //qDebug() << "changing lon coords from " << old_lon << "to" << lon ;

            // On modifie l'item dans le proxy. (Nécessite l'implémentation de setData() dans le sourceModel).
            setData(idx, lat, PhotoModel::LatitudeRole);
            setData(idx, lon, PhotoModel::LongitudeRole);
            // Vérification
            qDebug() << "ProxyModel: set latitude" << idx.data(PhotoModel::LatitudeRole).toDouble() << "for" << idx.data(PhotoModel::FilenameRole).toString();
        }
        // On passe à la photo suivante de la liste filtrée
        idx = idx.siblingAtRow(++row);
    }
}

/**
 * @brief Le slot SelectedFilterProxyModel::setAllItemsSavedCoords applique les coordonnées GPS de la SavedPosition à toutes
 * les photos du modèle filtré.
 * Ce slot appelé quand l'utilisateur appuye sur "Apply Saved Position".
 */
void SelectedFilterProxyModel::setAllItemsSavedCoords()
{
    auto source_model = dynamic_cast<PhotoModel*>(this->sourceModel());
    // On vérifie si on a bien un index valide pour la SavedPosition
    if (!source_model->m_markerIndex.isValid()) return;
    // On récupère les coordonnées GPS de la SavedPosition (dans le Proxy Model)
    QModelIndex markerIndex = mapFromSource(source_model->m_markerIndex);
    double savedLatitude  = markerIndex.data(PhotoModel::LatitudeRole).toDouble();
    double savedLongitude = markerIndex.data(PhotoModel::LongitudeRole).toDouble();
    // On les applique à toutes les photos du modèle filtré
    emit setAllItemsCoords(savedLatitude, savedLongitude);
}

/* *************************************************************************
 * Ce slot Active/Désactive le filtrage
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
    if (!m_selectedFilterEnabled) return true;
    // On récupère l'index de la ligne à accepter ou pas
    const QModelIndex idx = sourceModel()->index(sourceRow, 0, sourceParent);
    // On récupère les données de la ligne
    const bool isSelected = idx.data(PhotoModel::IsSelectedRole).toBool();
    const bool isMarker = idx.data(PhotoModel::IsMarkerRole).toBool();
    // qDebug() << "ProxyModel: " << sourceModel() << idx.row() << isMarker ;
    return (isSelected || isMarker);
}
