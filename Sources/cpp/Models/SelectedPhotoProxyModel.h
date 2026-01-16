#ifndef SELECTEDPHOTOPROXYMODEL_H
#define SELECTEDPHOTOPROXYMODEL_H

#include <QSortFilterProxyModel>


/** **********************************************************************************************************
 * @brief The SelectedPhotoProxyModel class is a filter ProxyModel, that filters selected Photos.
 * ***********************************************************************************************************/
class SelectedPhotoProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT

    //! filterEnabled manages the status of the filtering.
    Q_PROPERTY(bool filterEnabled READ filterEnabled WRITE setFilterEnabled NOTIFY filterEnabledChanged)

public:
    explicit SelectedPhotoProxyModel(QObject *parent = nullptr);
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

#endif // SELECTEDPHOTOPROXYMODEL_H
