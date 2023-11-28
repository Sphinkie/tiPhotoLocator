#include "PhotoModel.h"
#include "cpp/ExifReadTask.h"
#include "cpp/ExifWriteTask.h"

#include <QThreadPool>
#include <QSettings>
#include <QDebug>


#define QT_NO_DEBUG_OUTPUT
/* ********************************************************************************************************** */
/*!
 * \class PhotoModel
 * \inmodule TiPhotoLocator
 * \brief The PhotoModel class manages a list of photo data.
 */
/* ********************************************************************************************************** */


/* ********************************************************************************************************** */
/**
 * @brief Constructor. Just add the welcome item in the list. If the debug mode is active, a second item is added for testing purpose.
 * @param parent : paramètre classique pour les QAbstractListModel.
 */
PhotoModel::PhotoModel(QObject *parent) : QAbstractListModel(parent)
{
    // On met l'item Welcome dans la liste
    m_data << Data("Select your photo folder", "qrc:Images/welcome.png", false, true, true);

    this->addTestItem();

    // Bout de code d'exemple de timer
    /*
    QTimer *growthTimer = new QTimer(this);
    connect(growthTimer, &QTimer::timeout, this, &PhotoModel::growPopulation);
    growthTimer->start(10000);
    */
}

/* ********************************************************************************************************** */
/**
 * @brief Returns the number of items in the model. @note Implémentation obligatoire.
 * @param parent : parent of the model.
 * @returns the number of elements in the model.
 */
int PhotoModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;
    return m_data.count();
}

/* ********************************************************************************************************** */
/**
 * @brief Returns the role value of an element of the model. @note Implémentation obligatoire.
 * @param  index : index of the element of the model.
 * @param  role : the requested role (enum).
 * @returns the requested role value
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

/* ********************************************************************************************************** */
/*
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
        {ArtistRole,            "artist"},
        {DescriptionWriterRole, "descriptionWriter"}
    };
    return mapping;
}

/* ********************************************************************************************************** */
/**
 * @brief Returns the full name (with absolute path) of the photo, in a QVariant
 * containing the image URL. This is an example of unitary getData method.
 * @param row : Indice de l'element à lire
 */
QVariant PhotoModel::getUrl(int row)
{
    if (row < 0 || row >= m_data.count())
        return QVariant();
    QVariant result = QVariant(m_data[row].imageUrl);
    return result;
}

/* ********************************************************************************************************** */
/**
 * @brief Adds a photo to the model, with just a name and a path (url).
 * Other data should be filled later, from exif metadata.
 * @param filename : filename of the photo
 * @param url : full path of the photo (in Qt format)
 */
void PhotoModel::append(const QString filename, const QString url)
{
    const int rowOfInsert = m_data.count();
    Data* new_data = new Data(filename, url);
    beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
    m_data.insert(rowOfInsert, *new_data);
    endInsertRows();
}

/* ********************************************************************************************************** */
/*!
 * \brief Adds an item to the model, from a 'key-value' dictionnary of metadata given in the \a data parameter.
 *
 * \code
      QVariantMap map;
      map.insert("filename", QVariant(filename));
      map.insert(roleNames().value(ImageUrlRole), QVariant(url));
   \endcode
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

/* ********************************************************************************************************** */
/*!
 * \brief Ajoute une entrée spéciale dans le Modèle,
 *        correspondant à une position GPS mémorisée (marker jaune).
 *
 * \a lati : latitude au format GPS.
 * \a longi : longitude au format GPS.
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

/* ********************************************************************************************************** */
/**
 * @brief Supprime du modèle l'item correspondant à la position sauvegardée.
 */
void PhotoModel::removeSavedPosition()
{
    this->removeData(m_markerRow);
    m_markerIndex = index(-1,0);
}

/* ********************************************************************************************************** */
/**
 * @brief Affecte les coordonnées GPS fournies à toutes les photos géographiquement situées à l'interieur
 *        du cercle rouge.
 * @param latitude : latitude GPS à affecter aux photos
 * @param longitude : longitude GPS à affecter aux photos
 */
void PhotoModel::setInCircleItemCoords(double latitude, double longitude)
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
            setData(idx, latitude, LatitudeRole);
            setData(idx, longitude, LongitudeRole);
            // Vérification
            qDebug() << "PhotoModel: set latitude" << idx.data(LatitudeRole).toDouble() << "for" << idx.data(FilenameRole).toString();
        }
        idx = idx.siblingAtRow(++row);
    }
}

/* ********************************************************************************************************** */
/**
 * @brief Mémorise la position fournie.
 * Met le flag \b "isSelected" du précédent item à \b False et le nouveau à \b True.
 * Met aussi le flag \b "insideCircle" du précédent item à \b False et le nouveau à \b True.
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
    // On notifie les autres classes qui ont besoin de savoir quelle est photo sélectinée
    emit selectedRowChanged(row);
}

/* ********************************************************************************************************** */
/*!
 * \brief Ce slot ajoute une propriété à une photo, par exemple si on clique sur une suggestion.
 *
 * \a row : indice de la photo.
 * \a value : valeur de la propriété.
 * \a property : nom de la propriété.
 */
void PhotoModel::setData(int row, QString value, QString property)
{
    QModelIndex index = this->index(row, 0);
    //QVariant val = value;
    int role = roleNames().key(property.toUtf8());
    this->setData(index, value, role);
}

/* ********************************************************************************************************** */
/*!
 * \overload setData()
 * \brief Surcharge qui permet de modifier unitairement un role d'un item du modèle.
 *
 * Returns \c true si la modification a réussi. \c False si l'index n'est pas valide, ou si la nouvelle valeur est identique à l'existante.
 * Cette fonction met aussi à \c TRUE le flag \c "To Be Saved" car il s'agit d'une action opérateur.
 * Certains roles ne sont pas modifiables: imageUrl, isSelected, hasGPS, filename, etc.
 * \sa {https://doc.qt.io/qt-5/qtquick-modelviewsdata-cppmodels.html#qabstractitemmodel-subclass}
 * Note: It is important to emit the dataChanged() signal after saving the changes.
 *
 * \a index : l'index (au sens ModelIndex) de l'item à modifier.
 * \a value : la nouvelle valeur.
 * \a role : le role à modifier (LatitudeRole, LongitudeRole, ToBeSavedRole, city, country).
 */
bool PhotoModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.isValid())
    {
        qDebug() << "PhotoModel::setData" << roleNames().value(role);
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
        case CityRole:
            m_data[index.row()].city = value.toString();
            m_data[index.row()].toBeSaved = true;
            emit dataChanged(index, index, QVector<int>() << CityRole );
            break;
        case CountryRole:
            m_data[index.row()].country = value.toString();
            m_data[index.row()].toBeSaved = true;
            emit dataChanged(index, index, QVector<int>() << CountryRole );
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

/* ********************************************************************************************************** */
/*!
 * \overload setData()
 * \brief Cette méthode permet de modifier plusieurs roles d'un item du modèle, avec comme clef le role 'FilenameRole'.
 * Roles non modifiables (ignorés): imageUrl, insideCircle.
 * Roles non modifiables (recalculés): hasGPS, toBeSaved.
 * Cette fonction positionne le flag "ToBeSaved" à FALSE. Elle convient à la lecture (ou relecture) globale des tags Exif des photos originales.
 * \a value_list : la liste des données à modifier. Attention: les Keys sont les noms des balises EXIF. "FileName" est obligatoire.
 */
void PhotoModel::setData(const QVariantMap &value_list)
{
    // qDebug() << "setData QVariantMap:" << value_list;
    // On trouve l'index correspondant au "filename"
    const QString file_name = value_list.value("FileName").toString();

    if (file_name.isEmpty()) return;    // No "FileName" tag received
    if (m_data.count() == 0) return;    // The list of photo data is empty.

    int row;
    // ----------------------------------
    // On cherche la photo
    // ----------------------------------
    for (row=0; row<m_data.count(); row++)
        if (m_data[row] == file_name) break;  // Possible grace à notre surcharge de l'opérateur ==   :-)

    // qDebug() << "found" << row ;
    if (row >= m_data.count()) return;        // Traitement du cas FileName not found

    // ----------------------------------
    // On met à jour les data de la photo
    // ----------------------------------
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
    // ImageDescription
    // Les metadata IPTC
    m_data[row].city            = value_list["City"].toString();
    m_data[row].country         = value_list["Country"].toString();
    m_data[row].description     = value_list["Description"].toString();     // TODO : aka Caption
    m_data[row].headline        = value_list["Headline"].toString();
    m_data[row].keywords        = value_list["Keywords"].toString();        // TODO: this is a list of keywords
    m_data[row].descriptionWriter = value_list["DescriptionWriter"].toString();
    if (value_list["Artist"].isNull())
        m_data[row].artist          = value_list["Creator"].toString();
    else
        m_data[row].artist          = value_list["Artist"].toString();
    // -------------------------------------
    // Certaines infos sont des suggestions
    // -------------------------------------
    QString modifyDate = value_list["ModifyDate"].toString().left(10);
    if (!modifyDate.isEmpty()) {
        // "2021:02:18 16:15:21"
        QString suggestedDate = modifyDate.mid(8,2)+"/"+modifyDate.mid(5,2)+"/"+modifyDate.left(4);
        emit sendSuggestion(suggestedDate, "dateTimeOriginal", "photo", row);
    }

    // Envoi du signal dataChanged()
    QModelIndex changed_index = this->index(row, 0);
    emit dataChanged(changed_index, changed_index);
}


/* ********************************************************************************************************** */
/*!
 * \brief Returns the last selected row.
 */
int PhotoModel::getSelectedRow()
{
    return m_lastSelectedRow;
}

/* ********************************************************************************************************** */
/*!
 * \brief Debug function that print (in the console) one line of the model at every call.
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

/* ********************************************************************************************************** */
/*!
 * \brief Deletes all the items of the Model.
 */
void PhotoModel::clear()
{
    beginResetModel();  // cette methode envoie un signal indiquant à tous que ce modèle va subir un changement radical
    m_data.clear();
    m_lastSelectedRow = 0;
    endResetModel();    // cette methode envoie un signal ModelReset
}

/* ********************************************************************************************************** */
/*!
 * \brief Ce slot lit des données EXIF d'une (ou toutes) photos du répertoire.
 * \a photo : l'indice de la photo (vide ou -1 = toutes les photos du répertoire)
 */
void PhotoModel::fetchExifMetadata(int photo)
{
    // qSetMessagePattern("%{time process}");
    // qDebug() << "fetchExifMetadata";
    if (photo > -1)
    {
        // On lit les tags d'une photo
        ExifReadTask *task = new ExifReadTask(m_data[photo].imageUrl);
        task->run();
    }
    else
    {
        // On lit les tags de toutes les photos
        QThreadPool::globalInstance()->setMaxThreadCount(4);   // Quantité maximum de threads
        // Mesures pour scanner 40 photos:
        // 1 par 1 = 32sec - 2 par 2 = 18sec - 3 par 3 = 13sec - 4 par 4 = 12sec - 5 par 5 = 12sec
        ExifReadTask::init(this);
        //Instanciation et ajout de plusieurs tâches au pool de threads
        for (int row = 0; row < m_data.count(); row++)
        {
            ExifReadTask *task = new ExifReadTask(m_data[row].imageUrl);
            QThreadPool::globalInstance()->start(task);
        }
        // On n'a pas besoin d'attendre de la fin de l'exécution des tâches du pool de threads.
        // QThreadPool::globalInstance()->waitForDone();
    }
}


/* ********************************************************************************************************** */
/*!
 * \brief Ce slot enregistre dans le fichier JPG les metadonnées IPTC qui ont été modifiées.
 * Tag obligatoire: imageUrl.
 * Tags modifiés: coords GPS, Creator, City, Country.
 */
void PhotoModel::saveMetadata()
{
    qDebug() << "saveMetadata";
    QSettings settings;
    bool backupsEnabled = settings.value("backupsEnabled", false).toBool();
    bool preserveExif = settings.value("preserveExif", false).toBool();
    QString software = settings.value("software", "").toString();

    QThreadPool::globalInstance()->setMaxThreadCount(3);
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
            exifData.insert("Creator", idx.data(ArtistRole));
            if (!preserveExif)  exifData.insert("Artist", idx.data(ArtistRole));
            exifData.insert("Software", software);
            exifData.insert("City", idx.data(CityRole));
            exifData.insert("Country", idx.data(CountryRole));

            //Instanciation et ajout de la tâche au pool de threads
            ExifWriteTask *task = new ExifWriteTask(exifData, backupsEnabled);
            QThreadPool::globalInstance()->start(task);

            // On fait retomber le flag "toBeSaved"
            setData(idx, false, ToBeSavedRole);
            // ou:
            // m_data[row].toBeSaved = false;
            // emit dataChanged(idx, idx, QVector<int>() << ToBeSavedRole);
         }
        idx = idx.siblingAtRow(++row);
    }
}

/* ********************************************************************************************************** */
/*!
 * \brief Adds a test item to the PhotoModel. (only if \c DebugMode is enabled in the \e settings)
 * \note For testing purpose.
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
    ibizaData.insert("Make", "Midjourney");
    ibizaData.insert("ImageHeight", 603);
    ibizaData.insert("ImageWidth", 603);
    ibizaData.insert("City", "Ibiza");
    ibizaData.insert("Country", "Baleares");
    ibizaData.insert("Creator", "Midjourney");
    ibizaData.insert("GPSLatitude", 38.980);
    ibizaData.insert("GPSLongitude", 1.433);
    this->setData(ibizaData);
}

/* ********************************************************************************************************** */
/*!
 * \brief Fonction typique qui supprime l'item désigné du modèle.
 * \a row : la position dans le vecteur de l'item à modifier.
 */
void PhotoModel::removeData(int row)
{
    if (row < 0 || row >= m_data.count())
        return;

    beginRemoveRows(QModelIndex(), row, row);
    m_data.removeAt(row);
    endRemoveRows();
}

/* ********************************************************************************************************** */
/*!
 * \brief Duplicates an item of the model, and add it at the end of the vector.
 * \a row : item row to be duplicated.
 */
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


/* ********************************************************************************************************** */
/*
 * \brief La methode get() (invocable par QML) renvoie les données de la photo demandée.
 * Usage dans QML: titre = myModel.get(1).title;
 * \a row : indice
 * Returns une Map contenant toutes les propriétés de l'item. Continet auss une propriété "row".
 */
QVariantMap PhotoModel::get(int row)
{
    // On cree un itérateur sur la table des Roles
    QHash<int,QByteArray> names = roleNames();
    QHashIterator<int, QByteArray> itr(names);
    QVariantMap result;
    result["row"] = row;

    while (itr.hasNext()) {
        itr.next();
        QModelIndex idx = index(row, 0);
        QVariant data = idx.data(itr.key());
        result[itr.value()] = data;
        //qDebug() << itr.key() << ": " << itr.value();
    }
    return result;
}


/* ********************************************************************************************************** */
// Surcharges d'operateurs
/* ********************************************************************************************************** */
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
