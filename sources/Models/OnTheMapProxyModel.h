#ifndef ONTHEMAPPROXYMODEL_H
#define ONTHEMAPPROXYMODEL_H

#include <QSortFilterProxyModel>

/** **********************************************************************************************************
 * @brief The OnTheMapProxyModel class is a filter ProxyModel, to keep only the selected photo(s).
 * @note Dans ce ProxyModel on doit ré-implementer les méthodes append(), get(), clear(), etc.
 * ********************************************************************************************************** */
class OnTheMapProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT

    //! filterEnabled manages the status of the filtering.
    Q_PROPERTY(bool filterEnabled READ filterEnabled WRITE setFilterEnabled NOTIFY filterEnabledChanged)

public:
    explicit OnTheMapProxyModel(QObject *parent = nullptr);
    bool filterEnabled() const;

public slots:
    void setFilterEnabled(bool enabled);
    void setAllItemsCoords(const double latitude, const double longitude);
    void setAllItemsSavedCoords();

signals:
    void filterEnabledChanged();  //!< Signal émis quand l'état du filtrage change.

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

private:
    bool m_filterEnabled;  //!< Indicates if the filter is ON or OFF
};

#endif // ONTHEMAPPROXYMODEL_H
