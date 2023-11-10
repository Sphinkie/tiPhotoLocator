#ifndef UNLOCALIZEDPROXYMODEL_H
#define UNLOCALIZEDPROXYMODEL_H

#include <QSortFilterProxyModel>

/*!
 * \brief The UnlocalizedProxyModel class if a filter ProxyModel, that filters the Photo with/without GPS coordinates.
 */
class UnlocalizedProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(bool filterEnabled READ filterEnabled WRITE setFilterEnabled NOTIFY filterEnabledChanged)

public:
    explicit UnlocalizedProxyModel(QObject *parent = nullptr);
    bool filterEnabled() const;
    // -----------------------------------------------------
    // Méthodes pouvant être appelées depuis QML
    // -----------------------------------------------------
    Q_INVOKABLE int getSourceIndex(int row);

public slots:
    void setFilterEnabled(bool enabled);

signals:
    void filterEnabledChanged();  // Non implémenté

};

#endif // UNLOCALIZEDPROXYMODEL_H
