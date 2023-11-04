#ifndef SUGGESTIONPROXYMODEL_H
#define SUGGESTIONPROXYMODEL_H

#include <QSortFilterProxyModel>

/**
 * @brief The SuggestionProxyModel class if a filter ProxyModel, to keep only the suggestions related to the selected photo.
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
    void setFilterValues(const int photoRow, const int suggestionType);

signals:
    void filterEnabledChanged();

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

private:
    bool m_filterEnabled;
    int  m_filterPhotoRow;
    int  m_filterSuggestionType;

};

#endif // SUGGESTIONPROXYMODEL_H
