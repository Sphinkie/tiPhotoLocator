/**
 * This Model class stores all the metadata of the photos present in the selected folder.
 */

#include "PhotoModel.h"
//#include <QTimer>
#include <QDebug>
#include <QSettings>
//#include <cstdlib>

#define QT_NO_DEBUG_OUTPUT


// -----------------------------------------------------------------------
/**
 * @brief Constructor. Just add the welcome item in the list. If the debug mode is active, a second item is added for testing purpose.
 * @param parent
 */
PhotoModel::PhotoModel(QObject *parent) : QAbstractListModel(parent)
{
    // On met quelques items dans la liste
    m_data << Data("Select your photo folder", "qrc:Images/kodak.png", false, true, true); // Welcome

    this->addTestItem();

    // Bout de code d'exemple de timer
    /*
    QTimer *growthTimer = new QTimer(this);
    connect(growthTimer, &QTimer::timeout, this, &PhotoModel::growPopulation);
    growthTimer->start(10000);
    */
}

// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::rowCount returns the number of elements in the model. Implémentation obligatoire.
 * @param parent: parent of the model
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
 * @param index: index of the element of the model
 * @param role: the requested role (enum)
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
        case HasGPSRole:            return data.hasGPS;
        case IsSelectedRole:        return data.isSelected;
        case IsMarkerRole:          return data.isMarker;
        case IsWelcomeRole:         return data.isWelcome;
        case InsideCircleRole:      return data.insideCircle;
        case ToBeSavedRole:         return data.toBeSaved;
        case DateTimeOriginalRole:  return data.dateTimeOriginal;
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
        {FilenameRole,        "filename"},
        {ImageUrlRole,        "imageUrl"},
        {ImageWidthRole,      "imageWidth"},
        {ImageHeightRole,     "imageHeight"},
        // flags
        {HasGPSRole,          "hasGPS"},
        {IsSelectedRole,      "isSelected"},
        {IsMarkerRole,        "isMarker"},
        {IsWelcomeRole,       "isWelcome"},
        {InsideCircleRole,    "insideCircle"},
        {ToBeSavedRole,       "toBeSaved"},
        // Geolocation
        {LatitudeRole,        "latitude"},
        {LongitudeRole,       "longitude"},
        {CityRole,            "city"},
        {CountryRole,         "country"},
        // Photo
        {DateTimeOriginalRole,"dateTimeOriginal"},
        // Camera
        {CamModelRole,        "camModel"},
        {MakeRole,            "make"},
        // Userdata
        {ArtistRole,          "artist"}
    };
    return mapping;
}

// -----------------------------------------------------------------------
/**
 * @brief The getUrl() method gives the full name (with absolute path) of the photo.
 * This is an example of unitary getData method.
 * @param row : Indice de l'element à lire
 * @return a QVariant containing the image URL
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
 * @brief This append() method adds a photo to the model, with just a name and a path (url).
 * Other data should be filled later, from exif metadata.
 * @param filename: filename of the photo
 * @param url: Full path of the photo (in Qt format)
 */
void PhotoModel::append(const QString filename, const QString url)
{
    const int rowOfInsert = m_data.count();
    Data* new_data = new Data(filename, url);
    beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
    m_data.insert(rowOfInsert, *new_data);
    endInsertRows();
}

// -----------------------------------------------------------------------
/**
 * @brief This append() method adds an item to the model, from a dictionnary of metadata.
 * @param data: A dictionnary of key-value
 * @example
    QVariantMap map;
    map.insert("filename", QVariant(filename));
    map.insert(roleNames().value(ImageUrlRole), QVariant(url));
 */
void PhotoModel::append(const QVariantMap data)
{
    // qDebug() << "append QVariantMap:" << data;
    const int rowOfInsert = m_data.count();
    Data* new_data = new Data(data["filename"].toString(), data["imageUrl"].toString());
    // TODO: il faudrait probablement ajouter aussi un setData()
    beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
    m_data.insert(rowOfInsert, *new_data);
    endInsertRows();
    qDebug() << "append" << data.value("filename").toString() << "to row" << rowOfInsert;
}

// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::appendSavedPosition ajoute une entrée spéciale dans le Modèle
 * correspondant à une position GPS mémorisée (marker jaune).
 * @param lati; latitude au format GPS
 * @param longi: longitude au format GPS
 */
void PhotoModel::appendSavedPosition(double lati, double longi)
{
    // S'il n'y a pas encore de Saved Position, on insère à la fin
    if (!m_markerIndex.isValid())
    {
        const int rowOfInsert = m_data.count();
        Data* new_data = new Data("Saved Position", "", Data::marker);
        beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
        m_data.insert(rowOfInsert, *new_data);
        endInsertRows();
        // On mémorise sa position
        m_markerRow = rowOfInsert;
        m_markerIndex = index(rowOfInsert,0);
    }
    this->setData(m_markerIndex, lati, LatitudeRole);
    this->setData(m_markerIndex, longi, LongitudeRole);
}

// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::removeSavedPosition supprime du modèle l'item correspondant à la possition sauvegardée.
 */
void PhotoModel::removeSavedPosition()
{
    this->removeData(m_markerRow);
    m_markerIndex = index(-1,0);
}

// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::setInCircleItemCoords affecte les coordonnées GPS fournies à toutes les photos
 * géographiquement situées à l'interieur du cercle rouge.
 * @param lati; latitude au format GPS
 * @param longi: longitude au format GPS
 */
void PhotoModel::setInCircleItemCoords(double lati, double longi)
{
    // On parcourt tous les items du modèle (par leur index dans le modèle)
    int row = 0;
    QModelIndex idx = this->index(row, 0);
    while (idx.isValid())
    {
        // qDebug() << "PhotoModel index" << row;
        // Si la photo est dans le cercle, on modifie ses coords GPS
        if (idx.data(InsideCircleRole).toBool())
        {
            setData(idx, lati, LatitudeRole);
            setData(idx, longi, LongitudeRole);
            // Vérification
            qDebug() << "PhotoModel: set latitude" << idx.data(LatitudeRole).toDouble() << "for" << idx.data(FilenameRole).toString();
        }
        idx = idx.siblingAtRow(++row);
    }
}

// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::selectedRow mémorise la position fournie.
 * Met le flag "isSelected" du précédent item à False et le nouveau à True.
 * Met aussi le flag "insideCircle" du précédent item à False et le nouveau à True.
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
        m_data[m_lastSelectedRow].insideCircle = false;
        QModelIndex previous_index = this->index(m_lastSelectedRow, 0);
        emit dataChanged(previous_index, previous_index, {IsSelectedRole, InsideCircleRole} );
        qDebug() << m_data[m_lastSelectedRow].isSelected << m_data[m_lastSelectedRow].filename ;
    }
    // On remet à True le nouvel item sélectionné
    m_data[row].isSelected = true;
    m_data[row].insideCircle = true;
    QModelIndex new_index = this->index(row, 0);
    emit dataChanged(new_index, new_index, {IsSelectedRole, InsideCircleRole} );
    qDebug() << "PhotoModel: " << this << m_data[row].isSelected << m_data[row].filename  ;
    m_lastSelectedRow = row;
}

// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::setData est une surcharge qui permet de modifier unitairement un role d'un item du modèle.
 * Cette fonction met à TRUE le flag "To Be Saved" car il s'agit d'une action opérateur.
 * Certains roles ne sont pas modifiables: imageUrl, isSelected, hasGPS, filename, etc.
 * Note: It is important to emit the dataChanged() signal after saving the changes.
 * @param index : l'index (au sens ModelIndex) de l'item à modifier
 * @param value : la nouvelle valeur
 * @param role : le role à modifier (ex: LatitudeRole, LongitudeRole)
 * @return true si la modification a réussi. False si l'index n'est pas valide, ou si la nouvelle valeur est identique à l'existante.
 * @see: https://doc.qt.io/qt-5/qtquick-modelviewsdata-cppmodels.html#qabstractitemmodel-subclass
 */
bool PhotoModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.isValid())
    {
        switch (role)
        {
        case LatitudeRole:
            m_data[index.row()].gpsLatitude = value.toDouble();
            m_data[index.row()].hasGPS = (value != 0);    // Pas hyper-rigoureux...
            m_data[index.row()].toBeSaved = true;
            emit dataChanged(index, index, QVector<int>() << LatitudeRole << HasGPSRole);
            break;
        case LongitudeRole:
            m_data[index.row()].gpsLongitude = value.toDouble();
            m_data[index.row()].hasGPS = (value != 0);     // Théoriquement, il faudrait tester lat et long...
            m_data[index.row()].toBeSaved = true;
            emit dataChanged(index, index, QVector<int>() << LongitudeRole << HasGPSRole);
            break;
        case ToBeSavedRole:
            m_data[index.row()].toBeSaved = value.toBool();
            break;
        }
        emit dataChanged(index, index, QVector<int>() << ToBeSavedRole);
        return true;
    }
    else return false;
}

// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::setData permet de modifier plusieurs roles d'un item du modèle, avec comme clef le role 'FilenameRole'.
 * Roles non modifiables (ignorés): imageUrl; insideCircle.
 * Roles non modifiables (recalculés): hasGPS, toBeSaved.
 * Cette fonction positionne le flag "ToBeSaved" à FALSE. Elle convient à la lecture (ou relecture) globale des tags Exif des photos originales.
 * @param value_list : la liste des données à modifier. Attention: les Keys sont les noms des balises EXIF. "FileName" est obligatoire.
 */
void PhotoModel::setData(const QVariantMap &value_list)
{
    // qDebug() << "setData QVariantMap:" << value_list;
    // On trouve l'index correspondant au "filename"
    const QString file_name = value_list.value("FileName").toString();

    if (file_name.isEmpty()) return;    // No "FileName" tag received
    if (m_data.count() == 0) return;    // The list of photo data is empty.

    int row;
    for (row=0; row<m_data.count(); row++)
        if (m_data[row] == file_name) break;  // Possible grace à notre surcharge de l'opérateur ==   :-)

    qDebug() << "found" << row ;
    if (row >= m_data.count()) return;        // FileName not found

    // On met à jour les data (apparement, ça passe même s'il n'y a pas de valeur)
    m_data[row].gpsLatitude     = value_list["GPSLatitude"].toDouble();
    m_data[row].gpsLongitude    = value_list["GPSLongitude"].toDouble();
    // Les indicateurs calculés
    m_data[row].hasGPS          = ((m_data[row].gpsLatitude!=0) || ( m_data[row].gpsLongitude!=0));
    m_data[row].toBeSaved       = false;  // Les tags sont rétablis à leur valeur originelle
    // Les metadata EXIF
    m_data[row].dateTimeOriginal= value_list["DateTimeOriginal"].toString();
    m_data[row].camModel        = value_list["Model"].toString();
    m_data[row].make            = value_list["Make"].toString();
    m_data[row].imageWidth      = value_list["ImageWidth"].toInt();
    m_data[row].imageHeight     = value_list["ImageHeight"].toInt();
    //m_data[row].gpsLatitudeRef  = value_list["GPSLatitudeRef"].toString();
    //m_data[row].gpsLongitudeRef = value_list["GPSLongitudeRef"].toString();
    m_data[row].city            = value_list["City"].toString();
    m_data[row].country         = value_list["Country"].toString();
    m_data[row].description     = value_list["Description"].toString();     // TODO : aka Caption / ImageDescription
    m_data[row].headline        = value_list["Headline"].toString();
    m_data[row].keywords        = value_list["Keywords"].toString();        // TODO: this is a list of keywords
    m_data[row].descriptionWriter = value_list["DescriptionWriter"].toString();
    if (value_list["Artist"].isNull())
        m_data[row].artist          = value_list["Creator"].toString();
    else
        m_data[row].artist          = value_list["Artist"].toString();

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
    qDebug() << m_data[m_dumpedRow].filename << m_data[m_dumpedRow].city << m_data[m_dumpedRow].gpsLatitude << m_data[m_dumpedRow].gpsLongitude
             << m_data[m_dumpedRow].camModel << m_data[m_dumpedRow].make << "to be saved:" << m_data[m_dumpedRow].toBeSaved
             << "dateTimeOriginal:" << m_data[m_dumpedRow].dateTimeOriginal  <<  "description:" << m_data[m_dumpedRow].description  <<  "artist:" << m_data[m_dumpedRow].artist ;
    m_dumpedRow++;
}

// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::clear deletes all the items of the Model.
 */
void PhotoModel::clear()
{
    beginResetModel();  // cette methode envoie un signal indiquant à tous que ce modèle va subir un changement radical
    m_data.clear();
    m_lastSelectedRow = 0;
    endResetModel();    // cette methode envoie un signal ModelReset
}

// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::photoListModel traite le SIGNAL indiquant qu'il faut lire des données EXIF des photos du répertoire.
 */
void PhotoModel::fetchExifMetadata()
{
    qDebug() << "fetchExifMetadata";
    // TODO: envoyer un signal image par image et non plus un signal pour le répertoire entier
    QString path = m_data[0].imageUrl;
    int lim = path.lastIndexOf("/");
    path.truncate(lim);
    emit scanFile(path);
}


// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::saveExifMetadata enregistre dans le fichiers JPG les metadonnées EXIF qui ont été modifiées.
 */
void PhotoModel::saveExifMetadata()
{
    qDebug() << "saveExifMetadata";
    QSettings settings;
    bool creatorEnabled = settings.value("creatorEnabled", false).toBool();
    QString software = settings.value("software", "").toString();

    // On parcourt tous les items du modèle (par leur indice dans le vecteur)
    int row = 0;
    QModelIndex idx = this->index(row, 0);
    while (idx.isValid())
    {
        if (idx.data(ToBeSavedRole).toBool() && !idx.data(IsMarkerRole).toBool() && !idx.data(IsWelcomeRole).toBool())
        {
            // On ecrit les metadonnées dans le fichier JPG
            QVariantMap exifData;
            exifData.insert("imageUrl", idx.data(ImageUrlRole));   // Ce champ sert de clef
            exifData.insert("GPSLatitude", idx.data(LatitudeRole));
            exifData.insert("GPSLongitude", idx.data(LongitudeRole));
            exifData.insert("GPSLatitudeRef", idx.data(LatitudeRole).toInt()>0 ? "N" : "S" );
            exifData.insert("GPSLongitudeRef", idx.data(LongitudeRole).toInt()>0 ? "E" : "W" );           
            exifData.insert("Artist", idx.data(ArtistRole));
            if (creatorEnabled)  exifData.insert("Creator", idx.data(ArtistRole));
            exifData.insert("Software", software);
            emit writeMetadata(exifData);

            // On fait retomber le flag "toBeSaved"
            setData(idx, false, ToBeSavedRole);
            // ou:
            // m_data[row].toBeSaved = false;
            // emit dataChanged(idx, idx, QVector<int>() << ToBeSavedRole);
         }
        idx = idx.siblingAtRow(++row);
    }
}

// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::addTestItem add a test item to the Model. (only if DebugMode is enabled)
 * For testing purpose.
 */
void PhotoModel::addTestItem()
{
    QSettings settings;
    bool debugMode = settings.value("debugModeEnabled", false).toBool();
    if (!debugMode) return;

    this->m_data << Data("IMG_00000001", "qrc:///Images/IMG_00000001.png");
    QVariantMap ibizaData;
    ibizaData.insert("FileName", "IMG_00000001");
    ibizaData.insert("DateTimeOriginal", "2023:08:25 01:03:16");
    ibizaData.insert("Model", "Generative AI");
    ibizaData.insert("Make", "MIDJOURNEY");
    ibizaData.insert("ImageHeight", 603);
    ibizaData.insert("ImageWidth", 603);
    ibizaData.insert("City", "Ibiza");
    ibizaData.insert("GPSLatitude", 38.980);
    ibizaData.insert("GPSLongitude", 1.433);
    this->setData(ibizaData);
}

// -----------------------------------------------------------------------
/**
 * @brief PhotoModel::removeData est une fonction typqique qui supprime l'item désigné du modèle
 * @param row: la position dans le vecteur de l'item à modifier.
 */
void PhotoModel::removeData(int row)
{
    if (row < 0 || row >= m_data.count())
        return;

    beginRemoveRows(QModelIndex(), row, row);
    m_data.removeAt(row);
    endRemoveRows();
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


/**
 * @brief Méthode get() venant du forum.
 * Declaration dans .h = Q_INVOKABLE QVariantMap get(int row);
 * Usage dans .qml = myModel.get(1).title  // where 1 is an valid index.
 * @param row : indice
 * @return une Map contenant toutes les valeurs de l'item
 */
QVariantMap PhotoModel::get(int row)
{
    QHash<int,QByteArray> names = roleNames();
    QHashIterator<int, QByteArray> itr(names);
    QVariantMap result;
    while (itr.hasNext()) {
        itr.next();
        QModelIndex idx = index(row, 0);
        QVariant data = idx.data(itr.key());
        result[itr.value()] = data;
        //qDebug() << itr.key() << ": " << itr.value();
    }
    return result;
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
