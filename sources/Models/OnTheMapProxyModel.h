#ifndef ONTHEMAPPROXYMODEL_H
#define ONTHEMAPPROXYMODEL_H

#include <QSortFilterProxyModel>


class OnTheMapProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(bool selectedFilterEnabled READ selectedFilterEnabled WRITE setSelectedFilterEnabled NOTIFY selectedFilterEnabledChanged)

public:
    explicit OnTheMapProxyModel(QObject *parent = nullptr);
    bool selectedFilterEnabled() const;

public slots:
    void setSelectedFilterEnabled(bool enabled);
    void setAllItemsCoords(const double lat, const double lon);
    void setAllItemsSavedCoords();

signals:
    void selectedFilterEnabledChanged();

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

private:
    bool m_selectedFilterEnabled;
};

#endif // ONTHEMAPPROXYMODEL_H
