#include "PhotoModelWrapper.h"
#include <QDebug>

/* **********************************************************************************************************
 * @brief PhotoModelWrapper::PhotoModelWrapper
 * @param parent
 */
PhotoModelWrapper::PhotoModelWrapper(QObject *parent) : QObject(parent)
{}

/* **********************************************************************************************************
 * @brief removePhotoKeyword
 * @param keyword
 * \note Cette methode modifie la photo actuellement sélectionée dans le PhotoModel.
 */
void PhotoModelWrapper::removePhotoKeyword(QString keyword)
{
    qDebug() << "Remove" <<keyword << "keyword";
}

