#ifndef SUGGESTIONGEOPROXYMODEL_H
#define SUGGESTIONGEOPROXYMODEL_H

#include <QSortFilterProxyModel>



/* ************************************************************************ */
/*!
 * \class SuggestionGeoProxyModel
 * \brief The SuggestionGeoProxyModel class is a filter ProxyModel, that keeps
 *        only Suggestion with the "geo" category.
 */
/* ************************************************************************ */


class SuggestionGeoProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT

    //! filterEnabled manages the status of the filtering.
    Q_PROPERTY(bool filterEnabled READ filterEnabled WRITE setFilterEnabled NOTIFY filterEnabledChanged)

public:
    explicit SuggestionGeoProxyModel(QObject *parent = nullptr);
    bool filterEnabled() const;
    // -----------------------------------------------------
    // Méthodes pouvant être appelées depuis QML
    // -----------------------------------------------------
    Q_INVOKABLE int getSourceIndex(int row);

public slots:
    void setFilterEnabled(bool enabled);

signals:
    void filterEnabledChanged();  //!< Signal émis quand l'état du filtrage change.

};

#endif // SUGGESTIONGEOPROXYMODEL_H
