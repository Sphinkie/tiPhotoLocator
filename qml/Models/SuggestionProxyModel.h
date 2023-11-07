#ifndef SUGGESTIONPROXYMODEL_H
#define SUGGESTIONPROXYMODEL_H

#include <QSortFilterProxyModel>

/**
 * @brief The SuggestionProxyModel class if a filter ProxyModel, that filters the suggestions related to a given photo.
 */
class SuggestionProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(bool filterEnabled READ filterEnabled WRITE setFilterEnabled NOTIFY filterEnabledChanged)

public:
    explicit SuggestionProxyModel(QObject *parent = nullptr);
    bool filterEnabled() const;

public slots:
    void setFilterEnabled(bool enabled);
    void setFilterValue(const int photoRow);
    void removePhotoFromSuggestion(const int proxyRow);

signals:
    void filterEnabledChanged();

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

private:
    bool m_filterEnabled;
    int  m_filterPhotoRow;

};

#endif // SUGGESTIONPROXYMODEL_H
