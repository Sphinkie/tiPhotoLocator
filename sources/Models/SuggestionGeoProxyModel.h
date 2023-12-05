#ifndef SUGGESTIONGEOPROXYMODEL_H
#define SUGGESTIONGEOPROXYMODEL_H

#include <QSortFilterProxyModel>



/* ************************************************************************ */
/*!
 * \class SuggestionGeoProxyModel
 * \brief The SuggestionGeoProxyModel class is a filter ProxyModel, that keeps
 *        only Suggestion with the "geo" (or "geo|tag") category.
 */
/* ************************************************************************ */


class SuggestionGeoProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT

    //! The filterEnabled property manages the status of the filtering.
    Q_PROPERTY(bool filterEnabled READ filterEnabled WRITE setFilterEnabled NOTIFY filterEnabledChanged)

public:
    explicit SuggestionGeoProxyModel(QObject *parent = nullptr);
    bool filterEnabled() const;

public slots:
    void setFilterEnabled(bool enabled);

signals:
    void filterEnabledChanged();  //!< Signal émis quand l'état du filtrage change.

};

#endif // SUGGESTIONGEOPROXYMODEL_H
