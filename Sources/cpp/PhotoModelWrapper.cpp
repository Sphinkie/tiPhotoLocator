#include "PhotoModelWrapper.h"
#include <QDebug>

/** **********************************************************************************************************
 * @brief Constructeur.
 * @param parent
 * ***********************************************************************************************************/
PhotoModelWrapper::PhotoModelWrapper(QObject *parent) : QObject(parent)
{}

/** **********************************************************************************************************
 * @brief removePhotoKeyword
 * @param keyword
 * ***********************************************************************************************************/
void PhotoModelWrapper::removePhotoKeyword(QString keyword)
{
    qDebug() << "Remove" <<keyword << "keyword";
}

