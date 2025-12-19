#ifndef SUGGESTIONPROXYMODEL_H
#define SUGGESTIONPROXYMODEL_H

#include <QSortFilterProxyModel>


/** **********************************************************************************************************
 * @brief The SuggestionProxyModel class is a filter ProxyModel, that filters the
 *        Suggestion related to a given Photo.
 * ***********************************************************************************************************/
class SuggestionProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT

    //! filterEnabled manages the status of the filtering.
    Q_PROPERTY(bool filterEnabled READ filterEnabled WRITE setFilterEnabled NOTIFY filterEnabledChanged)

public:
    explicit SuggestionProxyModel(QObject *parent = nullptr);
    bool filterEnabled() const;

public slots:
    void setFilterEnabled(bool enabled);
    void setFilterValue(const int photoRow);
    void removePhotoFromSuggestion(const int proxyRow);
    void removePhotoFromSuggestion(const QModelIndex proxyIndex);

signals:
    void filterEnabledChanged();    //!<  Signal émis quand l'état du filtrage change.

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

private:
    bool m_filterEnabled;          //!< True su le filtrage st actif.
    int  m_filterPhotoRow;         //!< Le numero de la Photo sur lequel doit se faire le filtrage.

};

#endif // SUGGESTIONPROXYMODEL_H
