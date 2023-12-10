#ifndef CAMERAMODEL_H
#define CAMERAMODEL_H

#include <QAbstractListModel>
#include "Camera.h"


/* ********************************************************************************************************** */
/*!
 * \class CameraModel
 * \inmodule TiPhotoLocator
 * \brief The CameraModel class manages a list of camera thumbnails.
 */
/* ********************************************************************************************************** */

class CameraModel : public QAbstractListModel
{
    Q_OBJECT

public:
    CameraModel();
    /*!
     * \brief The Roles enum lists the roles associated to each attribute of a Camera
     */
    enum Roles {
        NameRole  = Qt::UserRole,
        ThumbnailRole
    };
    QHash<int, QByteArray> roleNames() const override;

    // -----------------------------------------------------
    // Surcharges obligatoires
    // -----------------------------------------------------
    explicit CameraModel(QObject *parent = nullptr);
    int      rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

private:
    QVector<Camera> m_cameras;  //!< La liste des Camera du modèle

};

#endif // CAMERAMODEL_H
