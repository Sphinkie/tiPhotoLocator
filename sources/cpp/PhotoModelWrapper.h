#ifndef PHOTOMODELWRAPPER_H
#define PHOTOMODELWRAPPER_H

#include <QObject>

/* ********************************************************************************************************** */
/* **********************************************************************************************************
 * \class PhotoModelWrapper
 * @brief Cette classe propose des fonctions de plus haut niveau pour s'interfacer avec le PhotoModel.
 * \note  Non utilisée pour l'instant.
 */
/* ********************************************************************************************************** */



class PhotoModelWrapper : public QObject
{
    Q_OBJECT

public:
    explicit PhotoModelWrapper(QObject *parent = nullptr);

    Q_INVOKABLE void removePhotoKeyword(QString keyword);

};

#endif // PHOTOMODELWRAPPER_H
