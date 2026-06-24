#include "PhotoModelWrapper.h"
#include <QDebug>

/** **********************************************************************************************************
 * @brief Constructeur.
 * @param parent
 * ***********************************************************************************************************/
PhotoModelWrapper::PhotoModelWrapper(QObject *parent) : QObject(parent)
{}

/** **********************************************************************************************************
 * @brief Supprime un keyword de la photo courante.
 * @param keyword : keyword à supprimer.
 * ***********************************************************************************************************/
void PhotoModelWrapper::removePhotoKeyword(QString keyword)
{
    qDebug() << "Remove" <<keyword << "keyword";
}

