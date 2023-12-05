#ifndef SUGGESTIONCATEGORYPROXYMODEL_H
#define SUGGESTIONCATEGORYPROXYMODEL_H

#include <QSortFilterProxyModel>



/* ************************************************************************ */
/*!
 * \class SuggestionCategoryProxyModel
 * \brief The SuggestionCategoryProxyModel class is a filter ProxyModel, that keeps
 *        only Suggestion with a given category.
 */
/* ************************************************************************ */


class SuggestionCategoryProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT

    //! The filterEnabled property manages the status of the filtering.
    Q_PROPERTY(bool filterEnabled READ filterEnabled WRITE setFilterEnabled NOTIFY filterEnabledChanged)

public:
    explicit SuggestionCategoryProxyModel(QObject *parent = nullptr);
    bool filterEnabled() const;
    Q_INVOKABLE void setFilterValue(QString filter = "");

public slots:
    void setFilterEnabled(bool enabled);
    void removePhotoFromSuggestion(const int proxyRow);

signals:
    void filterEnabledChanged();  //!< Signal émis quand l'état du filtrage change.

private:
    QString m_filter = "";
};

#endif // SUGGESTIONCATEGORYPROXYMODEL_H
