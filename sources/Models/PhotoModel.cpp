#include "PhotoModel.h"
#include "cpp/ExifReadTask.h"
#include "cpp/ExifWriteTask.h"
#include "cpp/utilities.h"

#include <QThreadPool>
#include <QSettings>
#include <QDebug>


#define QT_NO_DEBUG_OUTPUT


/* ********************************************************************************************************** */
/*!
 * \brief Constructor. Just add the welcome item in the list. If the debug mode is active, a second item is added for testing purpose.
 * \param parent : paramètre classique pour les QAbstractListModel.
 */
PhotoModel::PhotoModel(QObject *parent) : QAbstractListModel(parent)
{
    // On met l'item Welcome dans la liste
    m_photos << Photo("Select your photo folder", "qrc:Images/welcome.png", false, true, true);

    this->addTestItem();

    // Bout de code d'exemple de timer
    /*
    QTimer *growthTimer = new QTimer(this);
    connect(growthTimer, &QTimer::timeout, this, &PhotoModel::growPopulation);
    growthTimer->start(10000);
    */
}

/* ********************************************************************************************************** */
/*!
 * \brief Returns the number of items in the model. \note Implémentation obligatoire.
 * \param parent : parent of the model.
 * \returns the number of elements in the model.
 */
int PhotoModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;
    return m_photos.count();
}

/* ********************************************************************************************************** */
/*!
 * \brief Returns the role value of an element of the model. \note Implémentation obligatoire.
 * \param  index : index of the element of the model.
 * \param  role : the requested role (enum).
 * \returns the requested role value
 */
QVariant PhotoModel::data(const QModelIndex &index, int role) const
{
    if ( !index.isValid() )
        return QVariant();

    const Photo &photo = m_photos.at(index.row());

    switch(role)
    {
    case FilenameRole:          return photo.filename;
    case ImageUrlRole:          return photo.imageUrl;
    case LatitudeRole:          return photo.gpsLatitude;
    case LongitudeRole:         return photo.gpsLongitude;
    case HasGPSRole:            return photo.hasGPS;
    case IsSelectedRole:        return photo.isSelected;
    case IsMarkerRole:          return photo.isMarker;
    case IsWelcomeRole:         return photo.isWelcome;
    case InsideCircleRole:      return photo.insideCircle;
    case ToBeSavedRole:         return photo.toBeSaved;
    case DateTimeOriginalRole:  return photo.dateTimeOriginal;
    case CamModelRole:          return photo.camModel;
    case MakeRole:              return photo.make;
    case ImageWidthRole:        return photo.imageWidth;
    case ImageHeightRole:       return photo.imageHeight;
    case ShutterSpeedRole:      return photo.shutterSpeed;
    case FNumberRole:           return photo.fNumber;
    case CreatorRole:           return photo.creator;
    case CityRole:              return photo.city;
    case CountryRole:           return photo.country;
    case DescriptionRole:       return photo.description;
    case DescriptionWriterRole: return photo.descriptionWriter;
    case SoftwareRole:          return photo.software;
    case KeywordsRole:          return photo.keywords;
    default:
        return QVariant();
    }
}

/* ********************************************************************************************************** */
/*!
 * Table of Role names.
 * C'est la correspondance entre le role C++ et le nom de la property dans QML.
 * \note Implémentation obligatoire. <br>
 * Un appel à `roleNames().value(role);` renvoie la property (string) correspondant au role demandé. <br>
 * Un appel à `roleNames().key(property.toUtf8());` renvoie le role (int) correspondant à la property demandée. <br>
 */
QHash<int, QByteArray> PhotoModel::roleNames() const
{
    static QHash<int, QByteArray> mapping {
        // ROLE                 PROPËRTY
        {FilenameRole,          "filename"},
        {ImageUrlRole,          "imageUrl"},
        {ImageWidthRole,        "imageWidth"},
        {ImageHeightRole,       "imageHeight"},
        // flags
        {HasGPSRole,            "hasGPS"},
        {IsSelectedRole,        "isSelected"},
        {IsMarkerRole,          "isMarker"},
        {IsWelcomeRole,         "isWelcome"},
        {InsideCircleRole,      "insideCircle"},
        {ToBeSavedRole,         "toBeSaved"},
        // Geolocation
        {LatitudeRole,          "latitude"},
        {LongitudeRole,         "longitude"},
        {CityRole,              "city"},
        {CountryRole,           "country"},
        // Photo
        {DateTimeOriginalRole,  "dateTimeOriginal"},
        {SoftwareRole,          "software"},
        {ShutterSpeedRole,      "shutterSpeed"},
        {FNumberRole,           "fNumber"},
        // Camera
        {CamModelRole,          "camModel"},
        {MakeRole,              "make"},
        // Userdata
        {DescriptionRole,       "description"},
        {CreatorRole,           "creator"},
        {DescriptionWriterRole, "descriptionWriter"}
    };
    return mapping;
}

/* ********************************************************************************************************** */
/*!
 * \brief Returns the full name of the photo. This is an example of unitary getData method.
 * \param row : Indice de l'element à lire
 * \returns a QVariant containing the absolute path and full name (image URL) of the photo.
 */
QVariant PhotoModel::getUrl(int row)
{
    if (row < 0 || row >= m_photos.count())
        return QVariant();
    QVariant result = QVariant(m_photos[row].imageUrl);
    return result;
}

/* ********************************************************************************************************** */
/*!
 * \brief Adds a Photo to the model, with just a name and a path (url).
 *        Other data should be filled later, from exif metadata.
 * \param filename : filename of the photo
 * \param url : full path of the photo (in Qt format)
 */
void PhotoModel::append(const QString filename, const QString url)
{
    const int rowOfInsert = m_photos.count();
    Photo* new_photo = new Photo(filename, url);
    beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
    m_photos.insert(rowOfInsert, *new_photo);
    endInsertRows();
}

/* ********************************************************************************************************** */
/*!
 * \brief Adds a Photo item to the model, from a list of metadata.
 * \param data : a 'key-value' dictionnary of metadata.
 *
   \code
      QVariantMap map;
      map.insert("filename", QVariant(filename));
      map.insert(roleNames().value(ImageUrlRole), QVariant(url));
   \endcode
 */
void PhotoModel::append(const QVariantMap data)
{
    // qDebug() << "append QVariantMap:" << data;
    const int rowOfInsert = m_photos.count();
    Photo* new_photo = new Photo(data["filename"].toString(), data["imageUrl"].toString());
    // TODO: il faudrait probablement ajouter aussi un setData()
    beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
    m_photos.insert(rowOfInsert, *new_photo);
    endInsertRows();
    qDebug() << "append" << data.value("filename").toString() << "to row" << rowOfInsert;
}

/* ********************************************************************************************************** */
/*!
 * \brief Ajoute une entrée spéciale dans le Modèle, correspondant à une position GPS mémorisée (marker jaune).
 * \param latitude : latitude au format GPS.
 * \param longitude : longitude au format GPS.
 */
void PhotoModel::appendSavedPosition(double latitude, double longitude)
{
    // S'il n'y a pas encore de Saved Position, on insère à la fin
    if (!m_markerIndex.isValid())
    {
        const int rowOfInsert = m_photos.count();
        Photo* new_data = new Photo("Saved Position", "", true);
        beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
        m_photos.insert(rowOfInsert, *new_data);
        endInsertRows();
        // On mémorise sa position
        m_markerRow = rowOfInsert;
        m_markerIndex = index(rowOfInsert,0);
    }
    this->setData(m_markerIndex, latitude, LatitudeRole);
    this->setData(m_markerIndex, longitude, LongitudeRole);
}

/* ********************************************************************************************************** */
/*!
 * \brief Supprime du modèle l'item correspondant à la position sauvegardée.
 * \details L'item **SavedPosition**, de type **isMarker** est supprimé du modèle.
 */
void PhotoModel::removeSavedPosition()
{
    this->removeData(m_markerRow);
    m_markerIndex = index(-1,0);
}

/* ********************************************************************************************************** */
/*!
 * \brief Affecte les coordonnées GPS fournies à la photo actuellement sélectionnée.
 * \param latitude : Latitude GPS à affecter.
 * \param longitude : Longitude GPS à affecter.
 */
void PhotoModel::setSelectedItemCoords(double latitude, double longitude)
{
    QModelIndex idx = this->index(m_lastSelectedRow, 0);
    setData(idx, latitude, LatitudeRole);
    setData(idx, longitude, LongitudeRole);
    qDebug() << "GPS coords changed for " << m_lastSelectedRow;
}

/* ********************************************************************************************************** */
/*!
 * \brief Ce slot affecte les coordonnées GPS fournies à toutes les photos géographiquement situées à
 *        l'interieur du cercle rouge.
 * \param latitude : Latitude GPS à affecter aux photos
 * \param longitude : Longitude GPS à affecter aux photos
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
/*!
 * \brief Ce slot affecte le role fourni à toutes les photos géographiquement situées à l'interieur
 *        du cercle rouge.
 * \param photo : l'indice de la Photo à modifier. Voir la note pour les valeurs particulières.
 * \param value : la valeur
 * \param property : le nom de la property correspondant au Role
 * \note Valeurs particulières:
 *       \li La valeur spéciale -1 signifie **toutes les photos**.
 *       \li La valeur spéciale -2 signifie **la photo sélectionée**.
 *       \li La valeur spéciale -3 signifie **les photos du cercle**.
 */
void PhotoModel::setPhotoProperty(const int photo, const QString value, const QString property)
{
    switch (photo) {
    case -1:
        // On affecte toutes photos
        {
            int row = 0;
            QModelIndex idx = this->index(row, 0);
            while (idx.isValid())
            {
                setData(idx, value, roleNames().key(property.toUtf8()));
                idx = idx.siblingAtRow(++row);
            }
            break;
        }
    case -2:
        // On affecte la photo sélectionnée
        setData(m_lastSelectedRow, value, property);
        break;
    case -3:
        // On affecte les photos du Cercle
        {
            int row = 0;
            QModelIndex idx = this->index(row, 0);
            while (idx.isValid())
            {
                // Si la photo est dans le cercle, on modifie ses données
                if (idx.data(InsideCircleRole).toBool())
                {
                    setData(idx, value, roleNames().key(property.toUtf8()));
                }
                idx = idx.siblingAtRow(++row);
            }
            break;
        }
    default:
        // Autres cas: on a reçu un numéro de Photo
        setData(photo, value, property);
        break;
    }
}

/* ********************************************************************************************************** */
/*!
 * \brief Mémorise la position fournie.
 *
 * Met le flag \b "isSelected" du précédent item à \b False et le nouveau à \b True.
 * Met aussi le flag \b "insideCircle" du précédent item à \b False et le nouveau à \b True.
 * \param row : l'indice de l'item sélectionné dans la ListView.
 */
void PhotoModel::selectedRow(int row)
{
    qDebug() << "selectedRow " << row << "/" << m_photos.count();
    if (row < 0 || row >= m_photos.count() || row == m_lastSelectedRow)
        return;
    // On remet à False le précédent item sélectionné
    if (m_lastSelectedRow != -1)
    {
        m_photos[m_lastSelectedRow].isSelected = false;
        m_photos[m_lastSelectedRow].insideCircle = false;
        QModelIndex previous_index = this->index(m_lastSelectedRow, 0);
        emit dataChanged(previous_index, previous_index, {IsSelectedRole, InsideCircleRole} );
        qDebug() << m_photos[m_lastSelectedRow].isSelected << m_photos[m_lastSelectedRow].filename ;
    }
    // On remet à True le nouvel item sélectionné
    m_photos[row].isSelected = true;
    m_photos[row].insideCircle = true;
    QModelIndex new_index = this->index(row, 0);
    emit dataChanged(new_index, new_index, {IsSelectedRole, InsideCircleRole} );
    qDebug() << "PhotoModel: " << this << m_photos[row].isSelected << m_photos[row].filename  ;
    m_lastSelectedRow = row;
    // On notifie les autres classes qui ont besoin de savoir quelle est photo sélectinée
    emit selectedRowChanged(row);
}

/* ********************************************************************************************************** */
/*!
 * \brief Ce slot ajoute ou modifie une propriété d'une Photo, par exemple quand on clique sur une suggestion.
 *
 * \param row : indice de la photo.
 * \param value : valeur de la propriété.
 * \param property : nom de la propriété.
 */
void PhotoModel::setData(int row, QString value, QString property)
{
    QModelIndex index = this->index(row, 0);
    int role = roleNames().key(property.toUtf8());
    this->setData(index, value, role);
}

/* ********************************************************************************************************** */
/*!
 * \brief Surcharge qui permet de modifier \b unitairement un Role d'un item du modèle.
 *
 * Cette fonction met aussi à \c TRUE le flag \c "To Be Saved" car il s'agit d'une action opérateur.
 * Cette fonction est appelée quand on clique sur un Chips, pour modifier une des propriétés de la Photo.
 * Certains roles ne sont pas modifiables: imageUrl, isSelected, hasGPS, filename, shutterSpeed, F-number, etc.
 * \see https://doc.qt.io/qt-5/qtquick-modelviewsdata-cppmodels.html#qabstractitemmodel-subclass
 * \note: It is important to emit the dataChanged() signal after saving the changes.
 *
 * \param index : l'index (au sens ModelIndex) de l'item à modifier.
 * \param value : la nouvelle valeur.
 * \param role : le Role à modifier (LatitudeRole, LongitudeRole, ToBeSavedRole, city, country).
 * \returns \c true si la modification a réussi. \c False si l'index n'est pas valide, ou si la nouvelle valeur est identique à l'existante.
 */
bool PhotoModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.isValid())
    {
        qDebug() << "PhotoModel::setData" << roleNames().value(role);
        switch (role)
        {
        case LatitudeRole:
            m_photos[index.row()].gpsLatitude = value.toDouble();
            m_photos[index.row()].hasGPS = (value != 0);    // Pas hyper-rigoureux...
            m_photos[index.row()].toBeSaved = true;
            emit dataChanged(index, index, QVector<int>() << LatitudeRole << HasGPSRole << ToBeSavedRole);
            break;
        case LongitudeRole:
            m_photos[index.row()].gpsLongitude = value.toDouble();
            m_photos[index.row()].hasGPS = (value != 0);     // Théoriquement, il faudrait tester lat et long...
            m_photos[index.row()].toBeSaved = true;
            emit dataChanged(index, index, QVector<int>() << LongitudeRole << HasGPSRole << ToBeSavedRole);
            break;
        case CityRole:
            m_photos[index.row()].city = value.toString();
            m_photos[index.row()].toBeSaved = true;
            emit dataChanged(index, index, QVector<int>() << CityRole << ToBeSavedRole);
            break;
        case CountryRole:
            m_photos[index.row()].country = value.toString();
            m_photos[index.row()].toBeSaved = true;
            emit dataChanged(index, index, QVector<int>() << CountryRole << ToBeSavedRole);
            break;
        case CreatorRole:
            m_photos[index.row()].creator = value.toString();
            m_photos[index.row()].toBeSaved = true;
            emit dataChanged(index, index, QVector<int>() << CreatorRole << ToBeSavedRole);
            break;
        case DateTimeOriginalRole:
            m_photos[index.row()].dateTimeOriginal = Utilities::toStandardDateTime(value);
            m_photos[index.row()].toBeSaved = true;
            emit dataChanged(index, index, QVector<int>() << DateTimeOriginalRole << ToBeSavedRole);
            break;
        case DescriptionRole:
            m_photos[index.row()].description = value.toString();
            m_photos[index.row()].toBeSaved = true;
            emit dataChanged(index, index, QVector<int>() << DescriptionRole << ToBeSavedRole);
            break;
        case DescriptionWriterRole:
            m_photos[index.row()].descriptionWriter = value.toString();
            m_photos[index.row()].toBeSaved = true;
            emit dataChanged(index, index, QVector<int>() << DescriptionWriterRole << ToBeSavedRole);
            break;
        case ToBeSavedRole:
            m_photos[index.row()].toBeSaved = value.toBool();
            emit dataChanged(index, index, QVector<int>() << ToBeSavedRole);
            break;
        default:
            // pas de role précis reconnu: refesh global
            emit dataChanged(index, index);
        }
        return true;
    }
    else return false;
}

/* ********************************************************************************************************** */
/*!
 * \brief Cette méthode permet de modifier plusieurs roles d'un item du modèle, avec comme clef le role 'FilenameRole'.
 *        Elle est appelée lors de la lecture (ou relecture) globale des tags Exif des photos originales.
 *
 * Roles non modifiables (ignorés): imageUrl, insideCircle.
 * Roles non modifiables (recalculés): hasGPS, toBeSaved.
 * Cette fonction positionne le flag "ToBeSaved" à FALSE.
 * \param value_list : la liste des données à modifier. Attention: les Keys sont les noms des balises EXIF. "FileName" est obligatoire.
 */
void PhotoModel::setData(const QVariantMap &value_list)
{
    // qDebug() << "setData QVariantMap:" << value_list;
    // On trouve l'index correspondant au "filename"
    const QString file_name = value_list.value("FileName").toString();

    if (file_name.isEmpty()) return;    // No "FileName" tag received
    if (m_photos.count() == 0) return;    // The list of photo data is empty.

    int row;
    // ----------------------------------
    // On cherche la photo
    // ----------------------------------
    for (row=0; row<m_photos.count(); row++)
        if (m_photos[row] == file_name) break;  // Possible grace à notre surcharge de l'opérateur ==   :-)

    // qDebug() << "found" << row ;
    if (row >= m_photos.count()) return;        // Traitement du cas FileName not found

    // -----------------------------------------------------
    // On met à jour les data de la photo dans le modèle
    // -----------------------------------------------------
    m_photos[row].gpsLatitude     = value_list["GPSLatitude"].toDouble();
    m_photos[row].gpsLongitude    = value_list["GPSLongitude"].toDouble();
    // Les indicateurs calculés
    m_photos[row].hasGPS          = ((m_photos[row].gpsLatitude!=0) || ( m_photos[row].gpsLongitude!=0));
    m_photos[row].toBeSaved       = false;  // Les tags sont rétablis à leur valeur originelle
    // Les metadata EXIF
    m_photos[row].dateTimeOriginal= value_list["DateTimeOriginal"].toString();
    m_photos[row].camModel        = value_list["Model"].toString();
    m_photos[row].make            = value_list["Make"].toString();
    m_photos[row].imageWidth      = value_list["ImageWidth"].toInt();
    m_photos[row].imageHeight     = value_list["ImageHeight"].toInt();
    m_photos[row].shutterSpeed    = value_list["ShutterSpeed"].toFloat();
    m_photos[row].fNumber         = value_list["FNumber"].toFloat();
    // Les metadata IPTC
    m_photos[row].city            = value_list["City"].toString();
    m_photos[row].country         = value_list["Country"].toString();
    m_photos[row].description     = value_list["Description"].toString();     // TODO : aka Caption
    m_photos[row].software        = value_list["Software"].toString();
    m_photos[row].keywords        = value_list["Keywords"].toString();        // TODO: this is a list of keywords
    m_photos[row].descriptionWriter = value_list["DescriptionWriter"].toString();
    // En priorité, on prend le tag Exif 'Artist'. Si vide, on prend le tag IPTC 'Creator'.
    if (value_list["Artist"].isNull())
        m_photos[row].creator          = value_list["Creator"].toString();
    else
        m_photos[row].creator          = value_list["Artist"].toString();
    // Envoi du signal dataChanged()
    QModelIndex changed_index = this->index(row, 0);
    emit dataChanged(changed_index, changed_index);

    // -------------------------------------
    // Certaines infos sont des suggestions
    // -------------------------------------
    QString createDate = Utilities::toReadableDateTime(value_list["CreateDate"]);
    emit sendSuggestion(createDate, "dateTimeOriginal", "tag", row);
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
 * \note Debug function.
 */
void PhotoModel::dumpData()
{
    if (m_dumpedRow>=m_photos.count()) {
        qDebug() << "dump completed";
        m_dumpedRow = 0;
        return;
    }

    QString flags = "flags:";
    flags.append(m_photos[m_dumpedRow].toBeSaved ? "toBeSaved ":"");
    flags.append(m_photos[m_dumpedRow].isSelected? "isSelected ":"");
    flags.append(m_photos[m_dumpedRow].insideCircle? "insideCircle ":"");

    qDebug() << m_photos[m_dumpedRow].filename << m_photos[m_dumpedRow].city << m_photos[m_dumpedRow].shutterSpeed << m_photos[m_dumpedRow].fNumber
             << m_photos[m_dumpedRow].camModel << m_photos[m_dumpedRow].make
             << flags
             << "dateTimeOriginal:" << m_photos[m_dumpedRow].dateTimeOriginal << "description:" << m_photos[m_dumpedRow].description
             << "creator:" << m_photos[m_dumpedRow].creator ;

    m_dumpedRow++;
}

/* ********************************************************************************************************** */
/*!
 * \brief Deletes all the items of the Model.
 * \details On utilise cette fonction quand on scanne un nouveau répertoire de photos.
 */
void PhotoModel::clear()
{
    beginResetModel();  // cette methode envoie un signal indiquant à tous que ce modèle va subir un changement radical
    m_photos.clear();
    m_lastSelectedRow = 0;
    endResetModel();    // cette methode envoie un signal ModelReset
}

/* ********************************************************************************************************** */
/*!
 * \brief Ce slot lit des données EXIF d'une (ou toutes) photos du répertoire.
 * \param photo : l'indice de la photo (vide ou -1 = toutes les photos du répertoire)
 */
void PhotoModel::fetchExifMetadata(int photo)
{
    // qSetMessagePattern("%{time process}");
    // qDebug() << "fetchExifMetadata";
    if (photo > -1)
    {
        // On lit les tags d'une photo
        ExifReadTask *task = new ExifReadTask(m_photos[photo].imageUrl);
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
        for (int row = 0; row < m_photos.count(); row++)
        {
            ExifReadTask *task = new ExifReadTask(m_photos[row].imageUrl);
            QThreadPool::globalInstance()->start(task);
        }
        // On n'a pas besoin d'attendre de la fin de l'exécution des tâches du pool de threads.
        // QThreadPool::globalInstance()->waitForDone();
    }
}


/* ********************************************************************************************************** */
/*!
 * \brief Ce slot écrit dans les fichiers JPG (de façon asynchrone) les metadonnées IPTC des photos qui ont été modifiées.
 * \note Tag obligatoire: imageUrl.
 * \note Tags modifiés: GPS coords, Creator, City, Country, DateTimeOriginal.
 * \note Tags automatiques: GPS Ref, MetadataEditingSoftware.
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
            exifData.insert("Creator", idx.data(CreatorRole));
            if (!preserveExif)  exifData.insert("Artist", idx.data(CreatorRole));
            exifData.insert("MetadataEditingSoftware", software);
            exifData.insert("City", idx.data(CityRole));
            exifData.insert("Country", idx.data(CountryRole));
            exifData.insert("dateTimeOriginal", idx.data(DateTimeOriginalRole));

            //Instanciation et ajout de la tâche au pool de threads
            ExifWriteTask *task = new ExifWriteTask(exifData, backupsEnabled);
            QThreadPool::globalInstance()->start(task);

            // On fait retomber le flag "toBeSaved"
            setData(idx, false, ToBeSavedRole);
            // ou:
            // m_photos[row].toBeSaved = false;
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

    this->m_photos << Photo("IMG_00000001", "qrc:///Images/IMG_00000001.png");
    QVariantMap ibizaData;
    ibizaData.insert("FileName", "IMG_00000001");
    ibizaData.insert("DateTimeOriginal", "2023:08:25 01:03:16");
    ibizaData.insert("Make", "Generative AI");
    ibizaData.insert("Model", "Midjourney");
    ibizaData.insert("ImageHeight", 603);
    ibizaData.insert("ImageWidth", 603);
    ibizaData.insert("City", "Ibiza");
    ibizaData.insert("Country", "Baleares");
    ibizaData.insert("Creator", "Midjourney");
    ibizaData.insert("GPSLatitude", 38.9148);
    ibizaData.insert("GPSLongitude", 1.4351);
    ibizaData.insert("ShutterSpeed", 0.008);  // 1/125e
    ibizaData.insert("FNumber", 2.8);
    ibizaData.insert("Description", "Have fun !");
    this->setData(ibizaData);
}

/* ********************************************************************************************************** */
/*!
 * \brief Fonction typique qui supprime l'item désigné du modèle.
 * \param row : la position dans le vecteur de l'item à supprimer.
 */
void PhotoModel::removeData(int row)
{
    if (row < 0 || row >= m_photos.count())
        return;

    beginRemoveRows(QModelIndex(), row, row);
    m_photos.removeAt(row);
    endRemoveRows();
}

/* ********************************************************************************************************** */
/*!
 * \brief Duplicates an item of the model, and add it at the end of the vector.
 * \param row : item row to be duplicated.
 */
void PhotoModel::duplicateData(int row)
{
    if (row < 0 || row >= m_photos.count())
        return;

    const Photo photo = m_photos[row];
    const int rowOfInsert = row + 1;

    beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
    m_photos.insert(rowOfInsert, photo);
    endInsertRows();
}


/* ********************************************************************************************************** */
/*!
 * \brief La methode get() (invocable par QML) renvoie les données de la photo demandée.
 *        Usage dans QML: `titre = myModel.get(1).title;`
 * \param row : indice
 * \returns une Map contenant toutes les propriétés de l'item, dont la propriété spéciale: "row".
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
/*!
 * \brief Parcourt toutes les Photo du modèle, et flague celles qui sont à l'interieur du cercle demandé.
 *        Fonction avec mécanisme de Mutuelle Exclusion (MUTEX).
 * \param circle_radius: Le rayon du cercle (en mètres).
 *
 * On utilise les conversions: **1°lat = 111km**  et  **1°long = 111km x cos(lat)**.
 */
void PhotoModel::findInCirclePhotos(int circle_radius)
{
    // Le centre du cercle est la photo sélectionnée
    double circle_lat = m_photos[m_lastSelectedRow].gpsLatitude;
    double circle_long = m_photos[m_lastSelectedRow].gpsLongitude;
    //qDebug() << "findInCirclePhotos" << circle_lat << circle_long << circle_radius << "m";

    double rayon_lat = double(circle_radius) / 111111;       // rayon_lat = circle_radius(km) / 111.11
    double rayon_long = rayon_lat / cos(circle_lat);
    // qDebug() << "constantes; Rlat" << rayon_lat << ", Rlon" << rayon_long;

    // On parcourt tous les items du modèle (qui ont des coords GPS)
    int row = 0;
    QModelIndex idx = this->index(row, 0);
    while (idx.isValid())
    {
        if (idx.data(HasGPSRole).toBool())
        {
            // Si la Photo est dans le cercle : on positionne "insideCircle" à true.
            if (belong(m_photos[row].gpsLatitude, m_photos[row].gpsLongitude, circle_lat, circle_long, rayon_lat, rayon_long) )
                m_photos[row].insideCircle = true;
            else
                // Sinon on positionne "insideCircle" à false.
                m_photos[row].insideCircle = false;
        }
        idx = idx.siblingAtRow(++row);
    }
    // A la fin, on notifie en une seule fois l'ensemble des photos.
    emit dataChanged(this->index(0, 0), index(m_photos.count()-1, 0), QVector<int>() << InsideCircleRole);

    // si la fonction est relancée une seconde fois alors que celle-ci n'est pas finie : on ignore
    // TODO : Mettre un Mutex
}


/* ********************************************************************************************************** */
/*!
 * \brief Indique si le point P de coordonnées (pX, pY) appartient au cercle de centre O (oX, oY) et de rayon R.
 * \param pLa : Latitude du point à tester.
 * \param pLo : Longitude du point à tester.
 * \param oLa : Latitude de l'origine du cercle.
 * \param oLo : Longitude de l'origine du cercle.
 * \param rLa : le rayon du cercle sur l'axe des Latitudes N-S(en degrés).
 * \param rLo : le rayon du cercle sur l'axe des Longitudes E-W (en degrés).
 * \return true si le point est dans le cercle.
 * \note Pour être le plus rapide possible, le cercle est plutôt un carré.
 */
bool PhotoModel::belong(double pLa, double pLo, double oLa, double oLo, float rLa, float rLo)
{
    if (rLa==0) return false;
    // qDebug() << "  Comparaison avec: pLa:" << pLa << "=> Ecart lat" << abs(pLa-oLa) << "vs" << rLa ;
    // qDebug() << "  Comparaison avec: pLo:" << pLo << "=> Ecart long" << abs(pLo-oLo) << "vs" << rLo ;
    if (abs(pLa - oLa) > rLa)
    {
        return false;
    }
    else if (abs(pLo - oLo) > rLo)
    {
        return false;
    }
    else
        // TODO : pour les points qui arrivent jusqu'ici, on peut faire un test plus précis
        return true;
}


/* ********************************************************************************************************** */
/*!
 * \brief Applique le "photographe" à toutes les photos du modèle.
 * \details Le nom du photographe est configuré dans les Settings.
 */
void PhotoModel::applyCreatorToAll()
{
    QSettings settings;
    QString photographe = settings.value("photographe", "").toString();
    if (photographe.isEmpty()) return;

    // On parcourt tous les items du modèle
    int row = 0;
    QModelIndex idx = this->index(row, 0);
    while (idx.isValid())
    {
        m_photos[row].creator = photographe;
        m_photos[row].toBeSaved = true;
        idx = idx.siblingAtRow(++row);
    }
    // A la fin, on notifie en une seule fois l'ensemble des photos.
    emit dataChanged(this->index(0, 0), index(m_photos.count()-1, 0), QVector<int>() << CreatorRole << ToBeSavedRole);
}


/* ********************************************************************************************************** */
/*!
 * \brief Surcharge de l'opérateur ==.
 * \param file_name: Le texte à comparer
 * \return True si le **filename** de la photo correspond au texte passé en paramètre.
 */
bool Photo::operator == (const QString &file_name)
{
    if (this->filename == file_name)
        return true;
    return false;
}

/* ********************************************************************************************************** */
/*!
 * \brief Opérateur de comparaison standard.
 * \param photo : Un autre objet photo
 * \return True si les deux objets pointent sur les mêmes data.
 */
bool Photo::operator == (const Photo &photo)
{
    if (this->filename == photo.filename)
        return true;
    return false;
}
