#include<QDebug>
#include "SuggestionModel.h"
#include "SuggestionProxyModel.h"

#define QT_NO_DEBUG_OUTPUT

/* ************************************************************************ */
/**
 * @brief Contructeur
 */
SuggestionProxyModel::SuggestionProxyModel(QObject *parent) : QSortFilterProxyModel(parent)
{
    m_filterEnabled = true;
}


/* ************************************************************************ */
/**
 * @brief SuggestionProxyModel::filterEnabled indique si le filtre est actif ou non.
 * @return TRUE si le filtre est actif.
 */
bool SuggestionProxyModel::filterEnabled() const
{
    return m_filterEnabled;
}


/* ************************************************************************ */
/**
 * @brief Le slot SuggestionProxyModel::setFilterEnabled active ou désactive le filtrage par le ProxyModel.
 * @param enabled: TRUE pour activer le filtrage
 */
void SuggestionProxyModel::setFilterEnabled(bool enabled)
{
    if (m_filterEnabled == enabled)
        return;
    m_filterEnabled = enabled;
    emit filterEnabledChanged();
    invalidateFilter();
}

/* ************************************************************************ */
/**
 * @brief La méthode filterAcceptsRow() effectue le filtrage.
 * Elle laisse passer les lignes correspondant au filtrage, cad: suggestion liée à la photo de mandée.
 * @param sourceRow: Le numero d'une ligne du modèle parent (SuggestionModel)
 * @param sourceParent: Le modèle parent (SuggestionModel)
 * @return True si la ligne est acceptée
 */
bool SuggestionProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    if (!m_filterEnabled) return true;
    const QModelIndex idx = sourceModel()->index(sourceRow, 0, sourceParent);
    qDebug() << "filtering" << idx.data(SuggestionModel::TextRole).toString();
    qDebug() << "m_filterPhotoRow" << m_filterPhotoRow;

    // On récupère les données de la ligne à accepter ou pas
    // const QList<QVariant> listePhotos = idx.data(SuggestionModel::PhotosRole).toList();  // (autre méthode)
    const QList<int> listePhotosRow = idx.data(SuggestionModel::PhotosRole).value<QList<int>>();

    const bool photo_ok = listePhotosRow.contains(m_filterPhotoRow);

    qDebug() << "passed" << photo_ok;
    return (photo_ok);
}

/* ************************************************************************ */
/**
 * @brief SuggestionProxyModel::setFilterValue memorise le filtre à appliquer.
 * (Note: On n'utilise pas les slots par défaut du ProxyModel, tels que setFilterRole() et SetFilterFixedValue()...)
 * @param photoRow : l'indice de la photo pour laquelle on veut des suggestions
 */
void SuggestionProxyModel::setFilterValue(const int photoRow)
{
    qDebug() << "old FilterValue" << m_filterPhotoRow;
    m_filterPhotoRow = photoRow;
    qDebug() << "setFilterValue" << m_filterPhotoRow;
    invalidateRowsFilter();   // Le filtre à changé: On force un recalcul du filtrage
    // This function should be called if you are implementing custom filtering (e.g. filterAcceptsRow()), and your filter parameters have changed.

//    m_filterSuggestionType = suggestionType;

}







