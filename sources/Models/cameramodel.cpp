#include "cameramodel.h"

CameraModel::CameraModel(QObject *parent) : QAbstractListModel(parent)
{

}

/* ********************************************************************************************************** */
/*!
 * \brief Returns the number of items in the model. \note Implémentation obligatoire.
 * \param parent : parent of the model.
 * \returns the number of elements in the model.
 */
int CameraModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;
    return m_cameras.count();
}

/* ********************************************************************************************************** */
/*!
 * \brief Returns the role value of an element of the model. \note Implémentation obligatoire.
 * \param  index : index of the element of the model.
 * \param  role : the requested role (enum).
 * \returns the requested role value
 */
QVariant CameraModel::data(const QModelIndex &index, int role) const
{
    if ( !index.isValid() )
        return QVariant();

    const Camera &camera = m_cameras.at(index.row());

    switch(role)
    {
    case NameRole:      return camera.name;
    case ThumbnailRole: return camera.thumbnail;
    default:
        return QVariant();
    }
}

/* ********************************************************************************************************** */
/*!
 * Table of Role names.
 * C'est la correspondance entre le role C++ et le nom de la property dans QML.
 * \note Implémentation obligatoire.
 */
    QHash<int, QByteArray> CameraModel::roleNames() const
{
    static QHash<int, QByteArray> mapping {
        {NameRole,          "name"},
        {ThumbnailRole,     "thumbnail"},
    };
    return mapping;
}
