#ifndef SUGGESTIONTAGPROXYMODEL_H
#define SUGGESTIONTAGPROXYMODEL_H

#include <QSortFilterProxyModel>



/* ************************************************************************ */
/*!
 * \class SuggestionTagProxyModel
 * \brief The SuggestionTagProxyModel class is a filter ProxyModel, that keeps
 *        only Suggestion with the "tag" category.
 */
/* ************************************************************************ */


class SuggestionTagProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT

    //! The filterEnabled property manages the status of the filtering.
    Q_PROPERTY(bool filterEnabled READ filterEnabled WRITE setFilterEnabled NOTIFY filterEnabledChanged)

public:
    explicit SuggestionTagProxyModel(QObject *parent = nullptr);
    bool filterEnabled() const;

public slots:
    void setFilterEnabled(bool enabled);

signals:
    void filterEnabledChanged();  //!< Signal émis quand l'état du filtrage change.

};

#endif // SUGGESTIONTAGPROXYMODEL_H
