#ifndef UNDATEDPHOTOPROXYMODEL_H
#define UNDATEDPHOTOPROXYMODEL_H

#include <QSortFilterProxyModel>



/* ************************************************************************ */
/*!
 * \class UndatedPhotoProxyModel
 * \brief The UndatedPhotoProxyModel class is a filter ProxyModel, that filters
 *        Photo with/without original datetime.
 */
/* ************************************************************************ */


class UndatedPhotoProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT

    //! filterEnabled manages the status of the filtering.
    Q_PROPERTY(bool filterEnabled READ filterEnabled WRITE setFilterEnabled NOTIFY filterEnabledChanged)

public:
    explicit UndatedPhotoProxyModel(QObject *parent = nullptr);
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

#endif // UNDATEDPHOTOPROXYMODEL_H
