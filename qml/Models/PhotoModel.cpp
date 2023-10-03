/**
 * This Model class stores all the metadata of the photos present in the selected folder.
 */

#include "PhotoModel.h"
#include <QTimer>
#include <QDebug>
#include <cstdlib>


#define QT_NO_DEBUG_OUTPUT

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
/**
 * @brief PhotoModel::rowCount returns the number of elements in the model. Implémentation obligatoire.
 * @param parent : parent of the model
 * @return the number of elements in the model
 */
int PhotoModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;
    return m_data.count();
}

// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::data returns the requeted role value of an element of the model. Implémentation obligatoire.
 * @param index : index of the element of the model
 * @param role : the requested role (enum)
 * @return the value of the role for this element.
 */
QVariant PhotoModel::data(const QModelIndex &index, int role) const
{
    if ( !index.isValid() )
        return QVariant();

    const Data &data = m_data.at(index.row());

    switch(role)
    {
        case FilenameRole:          return data.filename;
        case ImageUrlRole:          return data.imageUrl;
        case LatitudeRole:          return data.gpsLatitude;
        case LongitudeRole:         return data.gpsLongitude;
        case IsSelectedRole:        return data.isSelected;
        case HasGPSRole:            return data.hasGPS;
        case FileCreateDateRole:    return data.fileCreateDate;
        case CreateDateRole:        return data.createDate;
        case DateTimeOriginalRole:  return data.dateTimeOriginal;
        case ModifyDateRole:        return data.modifyDate;
        case CamModelRole:          return data.camModel;
        case MakeRole:              return data.make;
        case ImageWidthRole:        return data.imageWidth;
        case ImageHeightRole:       return data.imageHeight;
        case ArtistRole:            return data.artist;
        case GPSLatitudeRefRole:    return data.gpsLatitude;
        case GPSLongitudeRefRole:   return data.gpsLongitude;
        case CityRole:              return data.city;
        case CountryRole:           return data.country;
        case DescriptionRole:       return data.description;
        case DescriptionWriterRole: return data.descriptionWriter;
        case HeadlineRole:          return data.headline;
        case KeywordsRole:          return data.keywords;
        default:
            return QVariant();
    }
}

// -----------------------------------------------------------------------
/**
 * Table of Role names. Implémentation obligatoire.
 * C'est la correspondance entre le role C++ et le nom de la property dans QML
 */
QHash<int, QByteArray> PhotoModel::roleNames() const
{
    static QHash<int, QByteArray> mapping {
        {FilenameRole,   "filename"},
        {ImageUrlRole,   "imageUrl"},
        {LatitudeRole,   "latitude"},
        {LongitudeRole,  "longitude"},
        {HasGPSRole,     "hasGPS"},
        {IsSelectedRole, "isSelected"}
    };
    return mapping;
}


// -----------------------------------------------------------------------
/**
 * @brief Gives the full name (with absolute path) of the photo.
 * This is an example of unitary gat data method.
 * @param row : Indice de l'element à lire
 * @return a QVariant containg the image URL
 */
QVariant PhotoModel::getUrl(int row)
{
    if (row < 0 || row >= m_data.count())
        return QVariant();
    QVariant result = QVariant(m_data[row].imageUrl);
    return result;
}


// -----------------------------------------------------------------------
/**
 * @brief Append a photo to the model with just a name and a path (url).
 * Other data should be filled later, from exif metadata.
 * @param filename : filename of the photo
 * @param url : Full path of the photo (in Qt format)
 */
void PhotoModel::append(QString filename, QString url)
{
    QVariantMap map;
    map.insert(roleNames().value(FilenameRole), QVariant(filename));
    map.insert(roleNames().value(ImageUrlRole), QVariant(url));
    this->append(map);
}

// -----------------------------------------------------------------------
/**
 * @brief Add an item to the Model from a dictionnary of metadata.
 * This method can be called from QML.
 * @param data: A dictionnary of key-value
 */
void PhotoModel::append(QVariantMap data)
{
    // qDebug() << "append QVariantMap:" << data;
    const int rowOfInsert = m_data.count();
    Data* new_data = new Data(data["filename"].toString(), data["imageUrl"].toString(), data["latitude"].toDouble(), data["longitude"].toDouble());
    beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
    m_data.insert(rowOfInsert, *new_data);
    endInsertRows();
    qDebug() << "append" << data.value("filename").toString() << "to row" << rowOfInsert;

}


// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::selectedRow mémorise la position fournie.
 * Met le flag "isSelected" du précédent item à False et le nouveau à True.
 * @param row : l'indice de l'item sélectionné dans la ListView.
 */
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

// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::setData est une surcharge qui permet de modifier unitairement 1 role un item du modèle.
 * Certains roles ne sont pas modifiables: imageUrl, isSelected, hasGPS.
 * @param index : l'index (au sens ModelIndex) de l'item à modifier
 * @param value : la nouvelle valeur
 * @param role : le role à modifier (ex: FilenameRole)
 * @return true si la modification a réussi. False si l'index n'est pas valide, ou si la nouvelle valeur est identique à l'existante.
 * @see: https://doc.qt.io/qt-5/qtquick-modelviewsdata-cppmodels.html#qabstractitemmodel-subclass
 */
bool PhotoModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.isValid())
    {
        // Check if the new value differs from the current value
        if (m_data[index.row()].filename == value.toString())
        {
            return false;
        }

        // Set data in model here.
        switch (role)
        {
        // IsSelectedRole: non-modifiable par ici. Merci de passer par selectedRow().
        // FilenameRole: pour tests uniquement. Normalement, on ne modifie pas ce role.
        case FilenameRole:
            m_data[index.row()].filename = value.toString();
        break;
        case LatitudeRole:
            m_data[index.row()].gpsLatitude = value.toDouble();
            m_data[index.row()].hasGPS = true;
        break;
        case LongitudeRole:
            m_data[index.row()].gpsLongitude = value.toDouble();
            m_data[index.row()].hasGPS = true;
        break;
        }
        // Note: It is important to emit the dataChanged() signal after saving the changes.
        emit dataChanged(index, index);
        return true;
    }
    return false;
}

// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::setData permet de modifier plusieurs roles d'un item du modèle, avec comme clef le role FilenameRole.
 * @param value_list : la liste des données à modifier. Attention: les Keys sont les noms des balises EXIF. "FileName" est obligatoire. "imageUrl" est ignoré.
 */
void PhotoModel::setData(QVariantMap &value_list)
{
    qDebug() << "setData QVariantMap:" << value_list;
    // On trouve l'index correspondant au "filename"
    const QString file_name = value_list.value("FileName").toString();

    if (file_name.isEmpty()) return;    // No "FileName" tag received
    if (m_data.count() == 0) return;    // The list of photo data is empty.

    int row;
    for (row=0; row<m_data.count(); row++)
        if (m_data[row] == file_name) break;  // on a surchargé l'opérateur ==   :-)

    qDebug() << "found" << row ;
    if (row >= m_data.count()) return;        // FileName not found

    // On met à jour les data (apparement, ça passe même s'il n'y a pas de valeur)
//    if (value_list.contains("GPSLatitude"))
    m_data[row].gpsLatitude = value_list["GPSLatitude"].toDouble();
//    if (value_list.contains("GPSLongitude"))
    m_data[row].gpsLongitude = value_list["GPSLongitude"].toDouble();
    // Les indicateurs calculés
    m_data[row].hasGPS = ((m_data[row].gpsLatitude!=0) || ( m_data[row].gpsLongitude!=0));
    // Les metadata EXIF
    m_data[row].fileCreateDate  = value_list["FileCreateDate"].toString();
    m_data[row].createDate      = value_list["CreateDate"].toString();
    m_data[row].dateTimeOriginal = value_list["DateTimeOriginal"].toString();
    m_data[row].modifyDate      = value_list["ModifyDate"].toString();
    m_data[row].camModel        = value_list["Model"].toString();
    m_data[row].make            = value_list["Make"].toString();
    m_data[row].imageWidth      = value_list["ImageWidth"].toInt();
    m_data[row].imageHeight     = value_list["ImageHeight"].toInt();
    m_data[row].artist          = value_list["Artist"].toString();           // TODO : gérer Creator
    m_data[row].gpsLatitudeRef  = value_list["GPSLatitudeRef"].toString();
    m_data[row].gpsLongitudeRef = value_list["GPSLongitudeRef"].toString();
    m_data[row].city            = value_list["City"].toString();
    m_data[row].country         = value_list["Country"].toString();
    m_data[row].description     = value_list["Description"].toString();     // TODO : aka Caption / ImageDescription
    m_data[row].headline        = value_list["Headline"].toString();
    m_data[row].keywords        = value_list["Keywords"].toString();        // TODO: this is a list of keywords
    m_data[row].descriptionWriter = value_list["DescriptionWriter"].toString();

    // Envoi du signal dataChanged()
    QModelIndex changed_index = this->index(row, 0);
    emit dataChanged(changed_index, changed_index);
}


// -----------------------------------------------------------------------
/**
 * @brief Unused getter.
 * @return the last selected row.
 */
int PhotoModel::getSelectedRow()
{
    return m_lastSelectedRow;
}


// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::dumpData is a debug function that print (in the console) one line of the model at every call.
 */
void PhotoModel::dumpData()
{
    if (m_dumpedRow>=m_data.count()) {
        qDebug() << "dump completed";
        m_dumpedRow = 0;
        return;
    }
    qDebug() << m_data[m_dumpedRow].filename << m_data[m_dumpedRow].city << m_data[m_dumpedRow].gpsLatitude
             << m_data[m_dumpedRow].camModel << m_data[m_dumpedRow].make;
    m_dumpedRow++;
}

/**
 * @brief PhotoModel::clear deletes all the items of the Model.
 */
void PhotoModel::clear()
{
    beginResetModel();  // cette methode envoie un signal indiquant à tous que ce modèle va subir un changement radiacal
    m_data.clear();
    m_lastSelectedRow = 0;
    endResetModel();    // cette methode envoie un signal ModelReset
}

/**
 * @brief PhotoModel::photoListModel traite le SIGNAL indiquant qu'il faut lire des données EXIF des photos du répertoire.
 */
void PhotoModel::fetchExifMetadata()
{
    qDebug() << "fetchExifMetadata";
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
        m_data[i].gpsLatitude += m_data[i].gpsLatitude * 0.1 * growthFactor;
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


// -----------------------------------------------------------------------
// Surcharges d'operateurs
// -----------------------------------------------------------------------
bool Data::operator == (const QString &file_name)
{
   if (this->filename == file_name)
      return true;
  return false;
}

bool Data::operator == (const Data &data)
{
   if (this->filename == data.filename)
      return true;
  return false;
}
