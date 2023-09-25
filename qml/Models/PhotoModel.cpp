/*************************************************************************
 *
 *************************************************************************/

#include "PhotoModel.h"

#include <QByteArray>
#include <QTimer>
#include <QDebug>
#include <cstdlib>


// #define QT_NO_DEBUG_OUTPUT

// -----------------------------------------------------------------------
// Constructor
// -----------------------------------------------------------------------
PhotoModel::PhotoModel(QObject *parent) : QAbstractListModel(parent)
{
    // On met quelques items dans la liste
    m_data
        << Data("Select your photo folder", "qrc:Images/kodak.png", 48.866, 2.333, true)
        << Data("Ibiza", "qrc:///Images/ibiza.png", 38.980, 1.433, false);

    QTimer *growthTimer = new QTimer(this);
    connect(growthTimer, &QTimer::timeout, this, &PhotoModel::growPopulation);
    growthTimer->start(10000);
}

// -----------------------------------------------------------------------
// Returns the number of elements in the model. Implémentation obligatoire.
// -----------------------------------------------------------------------
int PhotoModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;
    return m_data.count();
}

// -----------------------------------------------------------------------
// Returns an element of the model. Implémentation obligatoire.
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
    else if ( role == IsSelectedRole )
        return data.isSelected;
    else
        return QVariant();
}

// -----------------------------------------------------------------------
// Table of Role names. Implémentation obligatoire.
// -----------------------------------------------------------------------
QHash<int, QByteArray> PhotoModel::roleNames() const
{
    static QHash<int, QByteArray> mapping {
        {FilenameRole, "filename"},
        {ImageUrlRole, "imageUrl"},
        {LatitudeRole, "latitude"},
        {LongitudeRole, "longitude"},
        {IsSelectedRole, "isSelected"}
    };
    return mapping;
}


// -----------------------------------------------------------------------
// Example of get unitary data method
// -----------------------------------------------------------------------
QVariant PhotoModel::getUrl(int index)
{
    if (index < 0 || index >= m_data.count())
        return QVariant();
    QVariant result = QVariant(m_data[index].imageUrl);
    return result;
}


// -----------------------------------------------------------------------
// Add an item to the Model
// -----------------------------------------------------------------------
void PhotoModel::append(QString filename, QString url, double latitude, double longitude )
{
    const int rowOfInsert = m_data.count();
    Data* data = new Data(filename, url, latitude, longitude);

    beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
    m_data.insert(rowOfInsert, *data);
    endInsertRows();
    qDebug() << "append" << url << "to row" << rowOfInsert;
}


// -----------------------------------------------------------------------
// Mémorise la position fournie.
// Met le flag "isSelected" du précédent item à False et le nouveau à True.
// -----------------------------------------------------------------------
void PhotoModel::selectedRow(int row)
{
    qDebug() << "selectedRow " << row << "/" << m_data.count();
    if (row < 0 || row >= m_data.count() || row == m_lastSelectedRow)
        return;
    // On remet à False le précédent item sélectionné
    if (m_lastSelectedRow != -1)
    {
        m_data[m_lastSelectedRow].isSelected = false;
        QModelIndex previous_index = this->index(m_lastSelectedRow, 0);
        emit dataChanged(previous_index, previous_index, {IsSelectedRole});
        qDebug() << m_data[m_lastSelectedRow].isSelected << m_data[m_lastSelectedRow].filename ;
    }
    // On remet à True le nouvel item sélectionné
    m_data[row].isSelected = true;
    qDebug() << "PhotoModel: " << this << m_data[row].isSelected << m_data[row].filename  ;
    QModelIndex new_index = this->index(row, 0);
    emit dataChanged(new_index, new_index, {IsSelectedRole});
    m_lastSelectedRow = row;

}


bool PhotoModel::setCoordData(const QModelIndex &index, double lat, double lon)
{
    if (index.isValid()) {
            m_data[index.row()].latitude = lat;
            m_data[index.row()].longitude = lon;
            emit dataChanged(index, index, { PhotoModel::LatitudeRole, PhotoModel::LongitudeRole });
            return true;
        }
    return false;
}


// Note: It is important to emit the dataChanged() signal after saving the changes.
// Voir : https://doc.qt.io/qt-5/qtquick-modelviewsdata-cppmodels.html#qabstractitemmodel-subclass
bool PhotoModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    // All Roles can be edited, in PhotoModel !
    if (index.isValid() )    // && role == Qt::EditRole
    {
        // Check if the new value differs from the current value
        if (m_data[index.row()].filename != value.toString())
        {
           // TODO
        }

        // Set data in model here.
        switch (role) {
        case FilenameRole:  // TODO : pour tests uniquement
            m_data[index.row()].filename = value.toString();
        break;
        case LatitudeRole:
            m_data[index.row()].latitude = value.toDouble();
        break;
        case LongitudeRole:
            m_data[index.row()].longitude = value.toDouble();
        break;
        }
        emit dataChanged(index, index);   // , { Qt::EditRole, Qt::DisplayRole });
        return true;

    }
    return false;
}


// -----------------------------------------------------------------------
// Useless
// -----------------------------------------------------------------------
int PhotoModel::getSelectedRow()
{
    return m_lastSelectedRow;
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


// Methode get() venant du forum
// QML usage = myModel.get(1).title  //where 1 is an valid index.
// Declaration = // Q_INVOKABLE QVariantMap get(int row);
QVariantMap PhotoModel::get(int row)
{
    QHash<int,QByteArray> names = roleNames();
    QHashIterator<int, QByteArray> i(names);
    QVariantMap res;
    while (i.hasNext()) {
        i.next();
        QModelIndex idx = index(row, 0);
        QVariant data = idx.data(i.key());
        res[i.value()] = data;
        //cout << i.key() << ": " << i.value() << endl;
    }
    return res;
}


