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
 * On remaplace les coords de l'item pas celles recçues en paramètre.
 * TODO: On devrait pouvoir faire cela avec un SLOT...
 * *************************************************************************/
void SelectedFilterProxyModel::cppSlot(const double latit)
{
    qDebug() << "Called the C++ slot with:" << latit;
}

/* *************************************************************************
 * On remaplace les coords de l'item pas celles recçues en paramètre.
 * *************************************************************************/
void SelectedFilterProxyModel::setCoords(double lat, double lon)
{
    // Normalement, il n'y a qu'un seul item dans cette liste filtrée...
    const QModelIndex index0 = this->index(0, 0);
    const double old_lat = index0.data(PhotoModel::LatitudeRole).toDouble();
    const double old_lon = index0.data(PhotoModel::LongitudeRole).toDouble();
    qDebug() << "changing lat coords from " << old_lat << "to" << lat ;
    qDebug() << "changing lon coords from " << old_lon << "to" << lon ;

    // TODO: On écrit dans l'item
    // WTF: Il ne veut pas modifier l'item !
    setData(index(0, 0), lat, PhotoModel::LatitudeRole);
    setData(index(0, 0), lon, PhotoModel::LongitudeRole);

    setData(sourceModel()->index(0, 0), lat, PhotoModel::LatitudeRole);
    //setData(sourceModel()->index(0, 0), lon, PhotoModel::LongitudeRole);

    emit dataChanged(index0, index0);
    qDebug() << "Proxy" << index0.data(PhotoModel::LatitudeRole).toDouble();
    //qDebug() << "source" << sourceModel()->index(0, 0).data(PhotoModel::LatitudeRole).toDouble();
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
    // qDebug() << "ProxyModel: " << sourceModel() << isSelected << name ;
    return (isSelected);
}
