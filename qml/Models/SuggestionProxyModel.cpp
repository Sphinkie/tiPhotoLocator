#include<QDebug>
#include "SuggestionModel.h"
#include "SuggestionProxyModel.h"

#define QT_NO_DEBUG_OUTPUT


/*!
 * \class SuggestionProxyModel
 * \inmodule TiPhotoLocator
 * \brief The SuggestionProxyModel class if a filter ProxyModel, that filters the suggestions related to a given photo.
 */

/* ************************************************************************ */
/*
 * \brief Contructeur.
 * \a parent : modèle source
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
 * @param enabled : TRUE pour activer le filtrage
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
 * @param sourceRow : Le numero d'une ligne du modèle parent (SuggestionModel)
 * @param sourceParent : Le modèle parent (SuggestionModel)
 * @return True si la ligne est acceptée
 */
bool SuggestionProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    if (!m_filterEnabled) return true;
    const QModelIndex idx = sourceModel()->index(sourceRow, 0, sourceParent);
    // qDebug() << "filtering" << idx.data(SuggestionModel::TextRole).toString();

    // On récupère les données de la ligne à accepter ou pas
    // const QList<QVariant> listePhotos = idx.data(SuggestionModel::PhotosRole).toList();  // (autre méthode)
    const QSet<int> listePhotosRow = idx.data(SuggestionModel::PhotosRole).value<QSet<int>>();
    // On effectue le test de filtrage
    const bool photo_ok = listePhotosRow.contains(m_filterPhotoRow);
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
    m_filterPhotoRow = photoRow;
    qDebug() << "setFilterValue" << m_filterPhotoRow;
    invalidateRowsFilter();   // Le filtre à changé: On force un recalcul du filtrage
    // This function should be called if you are implementing custom filtering (e.g. filterAcceptsRow()), and your filter parameters have changed.
}


/* ********************************************************************************** */
/*!
 * \brief Ce slot enlève la photo courante de la liste des photos correspondant à une suggestion donnée.
 * On convertit l'indice du ProxyModel dans l'index du sourceModel.
 * \a proxyRow : l'indice dans le ProxyModel de la suggestion à modifier
 */
void SuggestionProxyModel::removePhotoFromSuggestion(const int proxyRow)
{
    qDebug() << "proxyRow" << proxyRow;
    if (proxyRow<0) return;
    // On convertit l'indice proxyModel vers l'index sourceModel
    QModelIndex idx = mapToSource(index(proxyRow,0));
    // On retire la photo courante de la liste.
    auto source_model = dynamic_cast<SuggestionModel*>(this->sourceModel());
    source_model->removeCurrentPhotoFromSuggestion(idx);
}





