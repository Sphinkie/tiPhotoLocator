/*************************************************************************
 *
 * Copyright (c) 2010-2019, Klaralvdalens Datakonsult AB (KDAB)
 * All rights reserved.
 *
 * See the LICENSE.txt file shipped along with this file for the license.
 *
 *************************************************************************/

#include "PhotoModel.h"

#include <QByteArray>
#include <QTimer>
#include <cstdlib>

// -----------------------------------------------------------------------
// Constructor
// -----------------------------------------------------------------------
PhotoModel::PhotoModel(QObject *parent) : QAbstractListModel(parent)
{
    m_data
//        << Data("Denmark", "qrc:images/denmark.jpg", 5.6, 0.0 )
        << Data("Select your photo folder", "qrc:///Images/ibiza.png", 38.980, 1.433);  // Ibiza

    QTimer *growthTimer = new QTimer(this);
    connect(growthTimer, &QTimer::timeout, this, &PhotoModel::growPopulation);
    growthTimer->start(10000);
}

// -----------------------------------------------------------------------
// Returns the number of elements in the model
// -----------------------------------------------------------------------
int PhotoModel::rowCount( const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;
    return m_data.count();
}

// -----------------------------------------------------------------------
// Returns an element of the model
// -----------------------------------------------------------------------
QVariant PhotoModel::data(const QModelIndex &index, int role) const
{
    if ( !index.isValid() )
        return QVariant();

    const Data &data = m_data.at(index.row());

    if ( role == FilenameRole )
        return data.filename;
    else if ( role == ImageUrlRole )
        return data.imageUrl;
    else if ( role == LatitudeRole )
        return data.latitude;
    else if ( role == LongitudeRole )
        return data.longitude;
    else
        return QVariant();
}

// -----------------------------------------------------------------------
// Table of Role names
// -----------------------------------------------------------------------
QHash<int, QByteArray> PhotoModel::roleNames() const
{
    static QHash<int, QByteArray> mapping {
        {FilenameRole, "filename"},
        {ImageUrlRole, "imageUrl"},
        {LatitudeRole, "latitude"},
        {LongitudeRole, "longitude"}
    };
    return mapping;
}


QVariant PhotoModel::get(int index, QString role){
    if (index < 0 || index >= m_data.count())
        return QVariant();
    QVariant result = QVariant("qrc:///Images/ibiza.png");
    return result;
}


// -----------------------------------------------------------------------
// Autres fonctions / A supprimer si inutile
// -----------------------------------------------------------------------
void PhotoModel::duplicateData(int row)
{
    if (row < 0 || row >= m_data.count())
        return;

    const Data data = m_data[row];
    const int rowOfInsert = row + 1;

    beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
    m_data.insert(rowOfInsert, data);
    endInsertRows();
}

void PhotoModel::removeData(int row)
{
    if (row < 0 || row >= m_data.count())
        return;

    beginRemoveRows(QModelIndex(), row, row);
    m_data.removeAt(row);
    endRemoveRows();
}

void PhotoModel::growPopulation()
{
    const double growthFactor = 0.01 / RAND_MAX;

    const int count = m_data.count();
    for (int i = 0; i < count; ++i) {
        m_data[i].latitude += m_data[i].latitude * 0.1 * growthFactor;
    }

    // we've just updated all rows...
    const QModelIndex startIndex = index(0, 0);
    const QModelIndex endIndex   = index(count - 1, 0);

    // ...but only the population field
    emit dataChanged(startIndex, endIndex, QVector<int>() << LatitudeRole);
}
