/*************************************************************************
 *
 * Copyright (c) 2016-2019, Klaralvdalens Datakonsult AB (KDAB)
 * All rights reserved.
 *
 * See the LICENSE.txt file shipped along with this file for the license.
 *
 *************************************************************************/

#ifndef SELECTEDFILTERPROXYMODEL_H
#define SELECTEDFILTERPROXYMODEL_H

#include <QSortFilterProxyModel>

class SelectedFilterProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(bool selectedFilterEnabled READ selectedFilterEnabled WRITE setSelectedFilterEnabled NOTIFY selectedFilterEnabledChanged)

public:
    explicit SelectedFilterProxyModel(QObject *parent = nullptr);
    bool selectedFilterEnabled() const;
    Q_INVOKABLE void setCoords(double l1, double l2);

public slots:
    void setSelectedFilterEnabled(bool enabled);
    void cppSlot(const double latit);

signals:
    void selectedFilterEnabledChanged();

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

private:
    bool m_selectedFilterEnabled;
};

#endif // SELECTEDFILTERPROXYMODEL_H
