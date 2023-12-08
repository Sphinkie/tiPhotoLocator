#include<QDebug>
#include "PhotoModel.h"
#include "OnTheMapProxyModel.h"

#define QT_NO_DEBUG_OUTPUT



/* ************************************************************************* */
/*!
 * \brief Contructeur. Par défaut, le filtre est actif.
 */
OnTheMapProxyModel::OnTheMapProxyModel(QObject *parent) : QSortFilterProxyModel(parent)
{
    m_filterEnabled = true;
}


/* ************************************************************************ */
/*!
 * \brief Indique si le filtre est actif ou non.
 * \returns true si le filtre est actif.
 */
bool OnTheMapProxyModel::filterEnabled() const
{
    return m_filterEnabled;
}

/* ************************************************************************ */
/*!
 * \brief Ce slot active ou désactive le filtrage par le ProxyModel.
 * \param enabled : true pour activer le filtrage
 */
void OnTheMapProxyModel::setFilterEnabled(bool enabled)
{
    if (m_filterEnabled == enabled)
        return;
    m_filterEnabled = enabled;
    emit filterEnabledChanged();
    invalidateFilter();
}

/* ************************************************************************ */
/*!
 * \brief Effectue le filtrage.
 * Laisse passer les lignes correspondant au filtrage, cad : photos "selectionnée" et le marqueur "Saved Position".
 * \param sourceRow : Le numero d'une ligne du modèle parent (PhotoModel).
 * \param sourceParent : Le modèle parent (PhotoModel).
 * \returns true si la ligne est acceptée.
 */
bool OnTheMapProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    if (!m_filterEnabled) return true;
    // On récupère l'index de la ligne à accepter ou pas
    const QModelIndex idx = sourceModel()->index(sourceRow, 0, sourceParent);
    // On récupère les données de la ligne
    const bool isSelected = idx.data(PhotoModel::IsSelectedRole).toBool();
    const bool isMarker = idx.data(PhotoModel::IsMarkerRole).toBool();
    const bool isInsideCircle = idx.data(PhotoModel::InsideCircleRole).toBool();
    // qDebug() << "ProxyModel: " << sourceModel() << idx.row() << isMarker ;
    return (isSelected || isMarker || isInsideCircle);
}


/* ************************************************************************ */
/*!
 * \brief Ce slot affecte les coordonnées GPS fournies à toutes les photos du modèle filtré (hors saved position).
 * \details
 *      Details: Ce slot est appelé quand l'utilisateur change la position d'une photo sur la carte.
 *      C'est un peu mieux de le faire ici, car on ne parcourt pas toutes les photos du
 *      modèle source, mais seulement celle du modèle filtré.
 * \param latitude : latitude au format GPS.
 * \param longitude : longitude au format GPS.
 */
void OnTheMapProxyModel::setAllItemsCoords(const double latitude, const double longitude)
{
    // On parcourt tous les items du modèle FILTRÉ (par leur index dans le proxy modèle)
    int row = 0;
    QModelIndex idx = this->index(row, 0);
    while (idx.isValid())
    {
        // qDebug() << "ProxyModel index" << row;
        // Si l'item n'est pas la SavedPosition, on modifie ses coords GPS
        if (!idx.data(PhotoModel::IsMarkerRole).toBool())
        {
            //const double old_lat = idx.data(PhotoModel::LatitudeRole).toDouble();
            //const double old_lon = idx.data(PhotoModel::LongitudeRole).toDouble();
            //qDebug() << "changing lat coords from " << old_lat << "to" << latitude ;
            //qDebug() << "changing lon coords from " << old_lon << "to" << longitude ;

            // On modifie l'item dans le proxy. (Nécessite l'implémentation de setData() dans le sourceModel).
            setData(idx, latitude, PhotoModel::LatitudeRole);
            setData(idx, longitude, PhotoModel::LongitudeRole);
            //setData(idx, true, PhotoModel::HasGPSRole);
            //emit dataChanged(idx,idx);
            // Vérification
            qDebug() << "ProxyModel: set coords" << idx.data(PhotoModel::LatitudeRole).toDouble() << "for" << idx.data(PhotoModel::FilenameRole).toString();
        }
        // On passe à la photo suivante de la liste filtrée
        idx = idx.siblingAtRow(++row);
    }
}

/* ************************************************************************ */
/*!
 * \brief Ce slot applique les coordonnées GPS de la SavedPosition à toutes
 *        les photos du modèle filtré.
 *
 * Ce slot est appelé quand l'utilisateur appuye sur "Apply Saved Position".
 */
void OnTheMapProxyModel::setAllItemsSavedCoords()
{
    auto source_model = dynamic_cast<PhotoModel*>(this->sourceModel());
    // On vérifie si on a bien un index valide pour la SavedPosition
    if (!source_model->m_markerIndex.isValid()) return;
    // On récupère les coordonnées GPS de la SavedPosition (dans le Proxy Model)
    QModelIndex markerIndex = mapFromSource(source_model->m_markerIndex);
    double savedLatitude  = markerIndex.data(PhotoModel::LatitudeRole).toDouble();
    double savedLongitude = markerIndex.data(PhotoModel::LongitudeRole).toDouble();
    // On les applique à toutes les photos du modèle filtré
    this->setAllItemsCoords(savedLatitude, savedLongitude);
}




