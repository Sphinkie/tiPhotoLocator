#ifndef PHOTOMODELWRAPPER_H
#define PHOTOMODELWRAPPER_H

#include <QObject>

/*!
 * \class La classe PhotoModelWrapper propose des fonctions de plus haut niveau pour s'interfacer avec le PhotoModel.
 */



class PhotoModelWrapper : public QObject
{
    Q_OBJECT

public:
    explicit PhotoModelWrapper(QObject *parent = nullptr);

    Q_INVOKABLE void removePhotoKeyword(QString keyword);

};

#endif // PHOTOMODELWRAPPER_H
