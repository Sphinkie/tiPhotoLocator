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
 * @brief La méthode filterAcceptsRow() effectue le filtrage (toutes les 10 secondes).
 * Elle laisse passer les lignes correspondant au filtrage, cad: suggestion liée à la photo de mandée, et ayant le type demandé.
 * @param sourceRow: Le numero d'une ligne du modèle parent (SuggestionModel)
 * @param sourceIndex: Index de la ligne dans le modèle parent (SuggestionModel)
 * @return True si la ligne est acceptée
 */
bool SuggestionProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceIndex) const
{
    if (!m_filterEnabled) return true;
    // On récupère les données de la ligne à accepter ou pas
    const QList<QVariant> listePhotos = sourceIndex.data(SuggestionModel::PhotosRole).toList();
    const bool photo_ok = listePhotos.contains(m_filterPhotoRow);
    // On récupère les données de la ligne à accepter ou pas
    const int suggestionType = sourceIndex.data(SuggestionModel::TypeRole).toInt();
    const bool type_ok  = (suggestionType == m_filterSuggestionType);
    return (photo_ok && type_ok);
}

/* ************************************************************************ */
/**
 * @brief SuggestionProxyModel::setFilterValues memorise le filet à appliquer.
 * (Note: On n'utilise pas les slots par défaut du ProxyModel, tels que setFilterRole() et SetFilterFixedValue()...)
 * @param photoRow : l'indice de la photo pour laquelle on veut des suggestions
 * @param suggestionType: le type de suggestions souhaitées
 */
void SuggestionProxyModel::setFilterValues(const int photoRow, const int suggestionType)
{
    m_filterPhotoRow = photoRow;
    m_filterSuggestionType = suggestionType;
}







