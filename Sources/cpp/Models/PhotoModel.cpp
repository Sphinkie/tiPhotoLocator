#include "PhotoModel.h"
#include "../ExifReadTask.h"
#include "../ExifWriteTask.h"
#include "../Utilities.h"

#include <QThreadPool>
#include <QSettings>
#include <QDebug>
#include <QDate>
#include <QDir>
#include <QUrl>
#include <QtMath>


#define QT_NO_DEBUG_OUTPUT


/** **********************************************************************************************************
 * @brief Constructor. Just add the welcome item in the list. If the debug mode is active, a second item is added for testing purpose.
 * @param parent : paramètre classique pour les QAbstractListModel.
 * ***********************************************************************************************************/
PhotoModel::PhotoModel(QObject *parent) : QAbstractListModel(parent)
{
    this->addTestItem();
}

/** **********************************************************************************************************
 * @brief Returns the number of items in the model. @note Implémentation obligatoire.
 * @param parent : parent of the model.
 * @returns the number of elements in the model.
 * ***********************************************************************************************************/
int PhotoModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;
    return m_photos.count();
}

/** **********************************************************************************************************
 * @brief Returns the role value of an element of the model.
 * @note Implémentation obligatoire.
 * @param  index : index of the element of the model.
 * @param  role : the requested role (enum).
 * @returns the requested role value
 * ***********************************************************************************************************/
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
    case IsCurrentRole:         return photo.isCurrent;
    case IsSelectedRole:        return photo.isSelected;
    case IsMarkerRole:          return photo.isMarker;
    case InsideCircleRole:      return photo.insideCircle;
    case ToBeSavedRole:         return photo.toBeSaved;
    case DateTimeOriginalRole:  return photo.dateTimeOriginal;
    case CamModelRole:          return photo.camModel;
    case MakeRole:              return photo.make;
    case ImageWidthRole:        return photo.imageWidth;
    case ImageHeightRole:       return photo.imageHeight;
    case OrientationRole:       return photo.orientation;
    case ShutterSpeedRole:      return photo.shutterSpeed;
    case FNumberRole:           return photo.fNumber;
    case CreatorRole:           return photo.creator;
    case CityRole:              return photo.city;
    case CountryRole:           return photo.country;
    case LocationRole:          return photo.location;
    case DescriptionRole:       return photo.description;
    case CaptionWriterRole:     return photo.captionWriter;
    case SoftwareRole:          return photo.software;
    case MetadataRole:          return photo.metadata;
    case KeywordsRole:          return photo.keywords;
    case WriteErrorRole:        return photo.writeError;
    default:
        return QVariant();
    }
}

/** *********************************************************************************************************
 * @brief Table of Role names.
 * C'est la correspondance entre le role C++ et le nom de la property dans QML.
 * @note Implémentation obligatoire.
 * @note Un appel à `roleNames().value(role);` renvoie la property (string) correspondant au role demandé.
 * @note Un appel à `roleNames().key(property.toUtf8());` renvoie le role (int) correspondant à la property demandée.
 * **********************************************************************************************************/
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
        {IsCurrentRole,         "isCurrent"},
        {IsSelectedRole,        "isSelected"},
        {IsMarkerRole,          "isMarker"},
        {InsideCircleRole,      "insideCircle"},
        {ToBeSavedRole,         "toBeSaved"},
        // Geolocation
        {LatitudeRole,          "latitude"},
        {LongitudeRole,         "longitude"},
        {CityRole,              "city"},
        {CountryRole,           "country"},
        {LocationRole,          "location"},
        // Photo
        {DateTimeOriginalRole,  "dateTimeOriginal"},
        {SoftwareRole,          "software"},
        {MetadataRole,          "metadata"},
        {OrientationRole,       "orientation"},
        {ShutterSpeedRole,      "shutterSpeed"},
        {FNumberRole,           "fNumber"},
        // Camera
        {CamModelRole,          "camModel"},
        {MakeRole,              "make"},
        // Userdata
        {CreatorRole,           "creator"},
        {KeywordsRole,          "keywords"},
        {DescriptionRole,       "description"},
        {CaptionWriterRole,     "captionWriter"},
        {WriteErrorRole,        "writeError"}
    };
    return mapping;
}


/** *********************************************************************************************************
 * @brief Retourne le nom du role dans le modèle.
 * @param role: la valeur numérique du role.
 * @return la valeur texte du role.
 * **********************************************************************************************************/
QString PhotoModel::getRoleName(int role)
{
    return roleNames().value(role);
}


/** **********************************************************************************************************
 * @brief Returns the full name of the photo. This is an example of unitary getter method.
 * @param row : Indice de l'élément à lire.
 * @returns a QVariant containing the absolute path and full name (image URL) of the photo.
 * ***********************************************************************************************************/
QVariant PhotoModel::getUrl(int row)
{
    if (row < 0 || row >= m_photos.count())
        return QVariant();
    else
        return QVariant(m_photos[row].imageUrl);
}


/** **********************************************************************************************************
 * @brief Adds a Photo to the model, with just a name and a path (url).
 *        Other data should be filled later, from exif metadata.
 * @param filename : filename of the photo
 * @param url : full path of the photo (in Qt format)
 * ***********************************************************************************************************/
void PhotoModel::append(const QString& filename, const QString& url)
{
    const int rowOfInsert = m_photos.count();
    beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
    m_photos.insert(rowOfInsert, Photo(filename, url));
    endInsertRows();
    emit countChanged();
}


/** **********************************************************************************************************
 * @brief Adds a Photo item to the model, from a list of metadata.
 * @param data : a 'key-value' dictionnary of metadata.
 * @note Accepts only 2 keys: filename and imageUrl.
 *
   @code
      QVariantMap map;
      map.insert("filename", QVariant(filename));
      map.insert(roleNames().value(ImageUrlRole), QVariant(url));
   @endcode
 * ***********************************************************************************************************/
void PhotoModel::append(const QVariantMap& data)
{
    // qDebug() << "append QVariantMap:" << data;
    const int rowOfInsert = m_photos.count();
    beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
    m_photos.insert(rowOfInsert, Photo(data["filename"].toString(), data["imageUrl"].toString()));
    endInsertRows();
    emit countChanged();
    // qDebug() << "append" << data.value("filename").toString() << "to row" << rowOfInsert;
}


/** **********************************************************************************************************
 * @brief Scanne un dossier directement via QDir (fallback pour les chemins UNC que FolderListModel ne supporte pas).
 * @param folderUrl: URL du dossier (format "file:////serveur/chemin" ou "file:///C:/chemin")
 * @return nombre de photos ajoutées au modèle
 * ***********************************************************************************************************/
int PhotoModel::scanFolder(const QString& folderUrl)
{
    QString localPath = QDir::toNativeSeparators(QUrl(folderUrl).toLocalFile());
    if (localPath.isEmpty())
        return 0;
    QDir dir(localPath);
    dir.setNameFilters({"*.jpg", "*.JPG", "*.jpeg", "*.JPEG"});
    const QFileInfoList files = dir.entryInfoList(QDir::Files | QDir::NoDotAndDotDot);
    for (const QFileInfo& fi : files) {
        QString absPath = fi.absoluteFilePath();
        QString fileUrl;
        if (absPath.startsWith("\\\\") || absPath.startsWith("//")) {
            // Chemin UNC: \\server\share\path → file:////server/share/path
            // (format file:////  : host vide, chemin UNC dans le path)
            // Contrairement à QUrl::fromLocalFile() qui produit file://server/path
            // (host="server"), lequel rend isLocalFile()=false et toLocalFile()="".
            QString normalized = absPath;
            normalized.replace('\\', '/').remove(0, 2); // retire les // ou \\ initiaux
            fileUrl = "file:////" + normalized;
        } else {
            fileUrl = QUrl::fromLocalFile(absPath).toString();
        }
        append(fi.fileName(), fileUrl);
    }
    qDebug() << "scanFolder:" << localPath << "->" << files.count() << "photos";
    return files.count();
}


/** **********************************************************************************************************
 * @brief Ajoute une entrée spéciale dans le Modèle, correspondant à une position GPS mémorisée (marker jaune).
 * Ses coordonnées GPS sont celles de la photo sélectionnée.
 * ***********************************************************************************************************/
void PhotoModel::appendSavedPosition()
{
    qDebug() << "appendSavedPosition"; // << coords.latitude();
    // S'il n'y a pas encore de Saved Position, on insère à la fin
    if (!m_markerIndex.isValid())
    {
        const int rowOfInsert = m_photos.count();
        beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
        m_photos.insert(rowOfInsert, Photo("Saved Position", "", true));
        endInsertRows();
        emit countChanged();
        // On mémorise sa position
        m_markerRow = rowOfInsert;
        m_markerIndex = index(rowOfInsert,0);
    }   
    this->setData(m_markerIndex, m_photos[m_lastCurrentRow].gpsLatitude, LatitudeRole);
    this->setData(m_markerIndex, m_photos[m_lastCurrentRow].gpsLongitude, LongitudeRole);
    m_savedPositionExists = true;
    emit savedPositionExistsChanged();
}


/** **********************************************************************************************************
 * @brief Ajoute une entrée spéciale dans le modèle avec des coordonnées GPS explicites (marker jaune).
 * Utilisé par l'identification IA pour sauvegarder la position du lieu reconnu.
 * ***********************************************************************************************************/
void PhotoModel::appendSavedPositionFromCoords(double latitude, double longitude)
{
    if (!m_markerIndex.isValid())
    {
        const int rowOfInsert = m_photos.count();
        beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
        m_photos.insert(rowOfInsert, Photo("Saved Position", "", true));
        endInsertRows();
        emit countChanged();
        m_markerRow = rowOfInsert;
        m_markerIndex = index(rowOfInsert, 0);
    }
    this->setData(m_markerIndex, latitude, LatitudeRole);
    this->setData(m_markerIndex, longitude, LongitudeRole);
    m_savedPositionExists = true;
    emit savedPositionExistsChanged();
}


/** **********************************************************************************************************
 * @brief Enregistre un message d'erreur d'écriture ExifTool pour une photo.
 *        Si message est vide, l'erreur précédente est effacée (écriture réussie).
 *        Si message est non-vide, émet writeErrorOccurred pour la snackbar QML.
 * ***********************************************************************************************************/
void PhotoModel::setWriteError(QModelIndex idx, const QString& message)
{
    if (!idx.isValid()) return;
    int row = idx.row();
    m_photos[row].writeError = message;
    emit dataChanged(idx, idx, {WriteErrorRole});
    if (!message.isEmpty())
        emit writeErrorOccurred(m_photos[row].filename, message);
}


/** **********************************************************************************************************
 * @brief Supprime du modèle l'item correspondant à la position sauvegardée.
 * @details L'item **SavedPosition**, de type **isMarker** est supprimé du modèle.
 * ***********************************************************************************************************/
void PhotoModel::removeSavedPosition()
{
    this->removeData(m_markerRow);
    m_markerIndex = index(-1,0);
    m_savedPositionExists = false;
    emit savedPositionExistsChanged();
}


/** **********************************************************************************************************
 * @brief Ce slot affecte les même coordonnées GPS fournies à toutes les photos géographiquement situées à
 *        l'interieur du cercle rouge.
 * @param latitude : Latitude GPS à affecter aux photos
 * @param longitude : Longitude GPS à affecter aux photos
 * @see PhotoModel::findInCirclePhotos
 * @note NOT USED
 * ***********************************************************************************************************/
void PhotoModel::setInCircleItemCoords(const double latitude, const double longitude)
{
    qDebug() << "setInCircleItemCoords";
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
            // qDebug() << "PhotoModel: set latitude" << idx.data(LatitudeRole).toDouble() << "for" << idx.data(FilenameRole).toString();
        }
        idx = idx.siblingAtRow(++row);
    }
}


/** **********************************************************************************************************
 * @brief Ce slot affecte le role fourni à toutes les photos demandées.
 * @param photo : l'indice de la Photo à modifier. Voir la note pour les valeurs particulières.
 * @param value : la valeur de la property.
 * @param property : le nom de la property (correspondant à un Role).
 * @note Valeurs particulières du paramètre `photo`:
 *       \li La valeur spéciale -1 signifie **toutes les photos**.
 *       \li La valeur spéciale -2 signifie **la photo courante**.
 *       \li La valeur spéciale -3 signifie **les photos du cercle**.
 *       \li La valeur spéciale -4 signifie **les photos sélectionées**.
 * ***********************************************************************************************************/
void PhotoModel::setPhotoProperty(const int photo, const QString& value, const QString& property)
{
    switch (photo) {
    case -1: {
        // On affecte toutes photos
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
        // On affecte la photo courante.
        setData(m_lastCurrentRow, value, property);
        break;
    case -3: {
        // On affecte les photos du cercle.
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
    case -4: {
        // On affecte les photos sélectionnées.
        int row = 0;
        QModelIndex idx = this->index(row, 0);
        while (idx.isValid())
        {
            if (m_photos[row].isSelected) {
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


/** **********************************************************************************************************
 * @brief Mémorise la photo indiquée comme étant la photo courante de la ListView.
 *
 * Met le flag **isCurrent** du précédent item à *False* et le nouveau à *True*.
 * On fait aussi le traitement si le numéro de row est le même, car il s'agit peut-être d'une autre
 * liste de photos.
 * @param row : l'indice de l'item courant de la ListView.
 * ***********************************************************************************************************/
void PhotoModel::currentItemRow(const int row)
{
    qDebug() << "currentItemRow " << row << "/" << m_photos.count();
    if (row < 0 || row >= m_photos.count() )
        return;
    // On remet à False le précédent item courant
    if (m_lastCurrentRow != -1)
    {
        m_photos[m_lastCurrentRow].isCurrent = false;
        QModelIndex previous_index = this->index(m_lastCurrentRow, 0);
        emit dataChanged(previous_index, previous_index, {IsCurrentRole} );
        // qDebug() << m_photos[m_lastCurrentRow].isCurrent << m_photos[m_lastCurrentRow].filename ;
    }
    // On met à True le nouvel item courant (il est aussi sélectionné).
    m_photos[row].isCurrent = true;
    m_photos[row].isSelected = true;
    QModelIndex new_index = this->index(row, 0);
    emit dataChanged(new_index, new_index, {IsCurrentRole, IsSelectedRole} );
    m_lastCurrentRow = row;
    // On notifie les autres classes qui ont besoin de savoir quelle est la photo courante
    emit currentItemRowChanged(row);
    // ----------------------------------------------------------------------------
    // Pour cette photo sélectionnée, on cherche quelques suggestions adaptées...
    // ----------------------------------------------------------------------------
    // Suggestion dateTimeOriginal : on cherche en arrière la première date non vide
    QString suggestedDate;
    for (int i = row - 1; i >= 0; i--)
    {
        if (!m_photos[i].dateTimeOriginal.isEmpty())
        {
            suggestedDate = Utilities::toReadableDateTime(m_photos[i].dateTimeOriginal);
            break;
        }
    }
    if (suggestedDate.isEmpty())
        suggestedDate = QDate::currentDate().toString("dd/MM/yyyy") + " 00:00";
    emit sendSuggestion(suggestedDate, "dateTimeOriginal", "tag", row);
    m_selectionCount = 1;
    emit selectionCountChanged();
}

/** **********************************************************************************************************
 * @brief Mémorise les coordonnées dans la photo sélectionnée.
 *
 * @param coords : Coordonnées GPS à appliquer.
 * ***********************************************************************************************************/
void PhotoModel::currentItemCoords(const QGeoCoordinate coords)
{
    QModelIndex index = this->index(m_lastCurrentRow, 0);
    this->setData(index, coords.latitude(), LatitudeRole);
    this->setData(index, coords.longitude(), LongitudeRole);
}


/** **********************************************************************************************************
 * @brief Ce slot ajoute ou modifie une propriété d'une Photo, par exemple quand on clique sur une suggestion.
 *
 * @param row : indice de la photo.
 * @param value : valeur de la propriété.
 * @param property : nom de la propriété.
 * ***********************************************************************************************************/
void PhotoModel::setData(int row, const QString& value, const QString& property)
{
    QModelIndex index = this->index(row, 0);
    int role = roleNames().key(property.toUtf8());
    this->setData(index, value, role);
}


/** **********************************************************************************************************
 * @brief Surcharge qui permet de modifier **unitairement** un Role d'un item du modèle.
 *
 * Cette fonction met aussi à *True* le flag **To Be Saved** quand il s'agit d'une action opérateur.
 * Cette fonction est appelée quand on clique sur un Chips, pour modifier une des propriétés de la Photo.
 * Certains roles ne sont pas modifiables: `imageUrl, isCurrent, hasGPS, filename, shutterSpeed, F-number`, etc.
 * @see https://doc.qt.io/qt-5/qtquick-modelviewsdata-cppmodels.html#qabstractitemmodel-subclass
 * @note: Il est important d'émettre le signal `dataChanged()` after saving the changes.
 *
 * @param index : l'index (au sens QModelIndex) de l'item à modifier.
 * @param value : la nouvelle valeur.
 * @param role : le Role à modifier (`LatitudeRole, LongitudeRole, ToBeSavedRole, city, country`).
 * @returns *true* si la modification a réussi. *False* si l'index n'est pas valide, ou si la nouvelle valeur est identique à l'existante.
 * ***********************************************************************************************************/
bool PhotoModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.isValid())
    {
        // qDebug() << "PhotoModel::setData" << roleNames().value(role);
        switch (role)
        {
        case LatitudeRole:
            m_photos[index.row()].gpsLatitude = value.toDouble();
            m_photos[index.row()].hasGPS = (m_photos[index.row()].gpsLatitude != 0) || (m_photos[index.row()].gpsLongitude != 0);
            m_photos[index.row()].toBeSaved = true;
            m_photos[index.row()].dirtyFields.insert("GPSLatitude");
            m_photos[index.row()].dirtyFields.insert("GPSLatitudeRef");
            m_photos[index.row()].dirtyFields.insert("GPSLongitude");
            m_photos[index.row()].dirtyFields.insert("GPSLongitudeRef");
            emit dataChanged(index, index, QVector<int>() << LatitudeRole << HasGPSRole << ToBeSavedRole);
            break;
        case LongitudeRole:
            m_photos[index.row()].gpsLongitude = value.toDouble();
            m_photos[index.row()].hasGPS = (m_photos[index.row()].gpsLatitude != 0) || (m_photos[index.row()].gpsLongitude != 0);
            m_photos[index.row()].toBeSaved = true;
            m_photos[index.row()].dirtyFields.insert("GPSLatitude");
            m_photos[index.row()].dirtyFields.insert("GPSLatitudeRef");
            m_photos[index.row()].dirtyFields.insert("GPSLongitude");
            m_photos[index.row()].dirtyFields.insert("GPSLongitudeRef");
            emit dataChanged(index, index, QVector<int>() << LongitudeRole << HasGPSRole << ToBeSavedRole);
            break;
        case CityRole:
            m_photos[index.row()].city = value.toString();
            m_photos[index.row()].toBeSaved = true;
            m_photos[index.row()].dirtyFields.insert("City");
            emit dataChanged(index, index, QVector<int>() << CityRole << ToBeSavedRole);
            emit sendSuggestion(value.toString(), "city", "tag", -1);
            break;
        case CountryRole:
            m_photos[index.row()].country = value.toString();
            m_photos[index.row()].toBeSaved = true;
            m_photos[index.row()].dirtyFields.insert("Country");
            emit dataChanged(index, index, QVector<int>() << CountryRole << ToBeSavedRole);
            emit sendSuggestion(value.toString(), "country", "tag", -1);
            break;
        case LocationRole:
            m_photos[index.row()].location = value.toString();
            m_photos[index.row()].toBeSaved = true;
            m_photos[index.row()].dirtyFields.insert("Location");
            emit dataChanged(index, index, QVector<int>() << LocationRole << ToBeSavedRole);
            emit sendSuggestion(value.toString(), "location", "tag", -1);
            break;
        case CreatorRole:
            m_photos[index.row()].creator = value.toString();
            m_photos[index.row()].toBeSaved = true;
            m_photos[index.row()].dirtyFields.insert("Creator");
            emit dataChanged(index, index, QVector<int>() << CreatorRole << ToBeSavedRole);
            break;
        case DateTimeOriginalRole:
            m_photos[index.row()].dateTimeOriginal = Utilities::toStandardDateTime(value);
            m_photos[index.row()].toBeSaved = true;
            m_photos[index.row()].dirtyFields.insert("DateTimeOriginal");
            emit dataChanged(index, index, QVector<int>() << DateTimeOriginalRole << ToBeSavedRole);
            break;
        case DescriptionRole:
            // Description + writer
            m_photos[index.row()].description = value.toString();
            m_photos[index.row()].captionWriter = QSettings().value("initiales").toString();
            m_photos[index.row()].toBeSaved = true;
            m_photos[index.row()].dirtyFields.insert("Description");
            m_photos[index.row()].dirtyFields.insert("CaptionWriter");
            emit dataChanged(index, index, QVector<int>() << DescriptionRole << CaptionWriterRole << ToBeSavedRole);
            break;
        case CaptionWriterRole:
            m_photos[index.row()].captionWriter = value.toString();
            m_photos[index.row()].toBeSaved = true;
            m_photos[index.row()].dirtyFields.insert("CaptionWriter");
            emit dataChanged(index, index, QVector<int>() << CaptionWriterRole << ToBeSavedRole);
            break;
        case KeywordsRole:
            m_photos[index.row()].keywords << value.toString();
            m_photos[index.row()].toBeSaved = true;
            m_photos[index.row()].dirtyFields.insert("Keywords");
            emit dataChanged(index, index, QVector<int>() << KeywordsRole << ToBeSavedRole);
            break;
        case IsSelectedRole:
            m_photos[index.row()].isSelected = value.toBool();
            emit dataChanged(index, index, QVector<int>() << IsSelectedRole);
            break;
        case ToBeSavedRole:
            m_photos[index.row()].toBeSaved = value.toBool();
            if (!value.toBool())
                m_photos[index.row()].dirtyFields.clear();
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


/** **********************************************************************************************************
 * @brief Cette méthode permet de modifier plusieurs roles d'un item du modèle, avec comme clef le role **FilenameRole**.
 *        Elle est appelée lors de la lecture (ou relecture) globale des tags Exif des photos originales.
 *
 * Roles non modifiables (ignorés): `imageUrl, insideCircle`.<br>
 * Roles non modifiables (recalculés): `hasGPS, toBeSaved`.<br>
 * @note Cette fonction positionne le flag **ToBeSaved** à *False*.<br>
 * @param value_list : la liste des données à modifier. Attention: les keys sont les noms des balises EXIF. `FileName` est obligatoire.
 * ***********************************************************************************************************/
void PhotoModel::setData(const QVariantMap &value_list)
{
    // qDebug() << "setData QVariantMap:" << value_list;
    // On trouve l'index correspondant au "filename"
    const QString file_name = value_list.value("FileName").toString();

    if (file_name.isEmpty()) return;      // If no "FileName" tag is received...
    if (m_photos.count() == 0) return;    // If the list of photo data is empty...

    int row;
    // -------------------------------------------------------------------
    // On cherche la photo
    // -------------------------------------------------------------------
    for (row=0; row<m_photos.count(); row++)
        if (m_photos[row] == file_name) break;  // Possible grace à notre surcharge de l'opérateur ==   :-)

    // qDebug() << "found" << row ;
    if (row >= m_photos.count()) return;        // Traitement du cas 'FileName not found'.

    // -----------------------------------------------------
    // On met à jour les data de la photo dans le modèle
    // -----------------------------------------------------
    m_photos[row].gpsLatitude     = value_list["GPSLatitude"].toDouble();
    m_photos[row].gpsLongitude    = value_list["GPSLongitude"].toDouble();
    // Les indicateurs calculés
    m_photos[row].hasGPS          = ((m_photos[row].gpsLatitude!=0) || ( m_photos[row].gpsLongitude!=0));
    m_photos[row].toBeSaved       = false;  // Les tags sont rétablis à leur valeur originelle
    m_photos[row].dirtyFields.clear();
    // Les metadata EXIF
    m_photos[row].dateTimeOriginal= value_list["DateTimeOriginal"].toString();
    m_photos[row].camModel        = value_list["Model"].toString();
    m_photos[row].make            = value_list["Make"].toString();
    m_photos[row].imageWidth      = value_list["ImageWidth"].toInt();
    m_photos[row].imageHeight     = value_list["ImageHeight"].toInt();
    m_photos[row].orientation     = value_list["Orientation"].toInt();
    m_photos[row].shutterSpeed    = value_list["ShutterSpeed"].toFloat();
    m_photos[row].fNumber         = value_list["FNumber"].toFloat();
    m_photos[row].metadata        = value_list["MetadataEditingSoftware"].toString();
    // Les metadata IPTC
    m_photos[row].city            = value_list["City"].toString();
    m_photos[row].country         = value_list["Country"].toString();
    m_photos[row].location        = value_list["Location"].toString();
    m_photos[row].description     = value_list["Description"].toString();
    m_photos[row].software        = value_list["Software"].toString();
    m_photos[row].keywords        = value_list["Keywords"].toStringList();
    m_photos[row].captionWriter   = value_list["CaptionWriter"].toString();
    // En priorité, on prend le tag Exif 'Artist'. Si vide, on prend le tag IPTC 'Creator'.
    // Ce tag peut être une String  ou une StringList, selon le nombre d'artistes...
    if (value_list["Artist"].isNull())
        m_photos[row].creator       = value_list["Creator"].toStringList().value(0);
    else
        m_photos[row].creator       = value_list["Artist"].toStringList().value(0);
    // On alimente le SuggestionModel avec toutes les valeurs rencontrées dans les EXIF/IPTC.
    // SuggestionModel::append() déduplique automatiquement sur (text + target).
    emit sendSuggestion(m_photos[row].city,     "city",     "tag", -1);
    emit sendSuggestion(m_photos[row].country,  "country",  "tag", -1);
    emit sendSuggestion(m_photos[row].location, "location", "tag", -1);
    // std::as_const évite la détachement COW (copy-on-write) du QStringList lors de l'itération,
    // car il indique que la liste de keywords de la photo va rester constante pendant l'opération.
    for (const QString &kw : std::as_const(m_photos[row].keywords))
        emit sendSuggestion(kw, "keywords", "tag", -1);
    // Envoi du signal dataChanged()
    QModelIndex photo_index = this->index(row, 0);
    emit dataChanged(photo_index, photo_index);

    // -------------------------------------------------------------------
    // Certaines infos sont des suggestions
    // -------------------------------------------------------------------
    if (row > 0)
    {
        QString prevDate = Utilities::toReadableDateTime(m_photos[row-1].dateTimeOriginal);
        emit sendSuggestion(prevDate, "dateTimeOriginal", "tag", row);
    }

}


/** **********************************************************************************************************
 * @brief Returns the last selected row.
 * ***********************************************************************************************************/
int PhotoModel::getCurrentItemRow()
{
    return m_lastCurrentRow;
}

/** **********************************************************************************************************
 * @brief Returns if the selected photo has GPS coordinates.
 * ***********************************************************************************************************/
bool PhotoModel::getCurrentItemHasGPS()
{
    return (m_photos[m_lastCurrentRow].hasGPS);
}

/** **********************************************************************************************************
 * @brief Returns the GPS Coords of the selected row.
 * ***********************************************************************************************************/
QGeoCoordinate PhotoModel::getCurrentItemCoords()
{
    return QGeoCoordinate(m_photos[m_lastCurrentRow].gpsLatitude, m_photos[m_lastCurrentRow].gpsLongitude);
}

/** **********************************************************************************************************
 * @brief Active la première photo de la liste (preview de l'image et pinpoint géographique).
 * Cette méthode est appelée une fois que l'on a lu les données Exif de la première photo de la liste.
 * ***********************************************************************************************************/
void PhotoModel::selectFirstPhoto()
{
    qDebug() << "selectFirstPhoto";
    // On efface la Saved Position
    this->removeSavedPosition();
    // On sélectionne la première photo
    this->currentItemRow(0);
    // On prévient la MapView
    emit firstCoordsReady();
}


/** **********************************************************************************************************
 * @brief Debug function that print (in the console) one line of the model at every call.
 * @note Debug function.
 * ***********************************************************************************************************/
void PhotoModel::dumpData()
{
    if (m_dumpedRow>=m_photos.count()) {
        qDebug() << "dump completed";
        m_dumpedRow = 0;
        return;
    }

    QString flags = "flags:";
    flags.append(m_photos[m_dumpedRow].toBeSaved ? " toBeSaved":"");
    flags.append(m_photos[m_dumpedRow].isCurrent? " isCurrent":"");
    flags.append(m_photos[m_dumpedRow].isSelected? " isSelected":"");
    flags.append(m_photos[m_dumpedRow].insideCircle? " insideCircle":"");

    qDebug() << m_photos[m_dumpedRow].filename << m_photos[m_dumpedRow].city
             << m_photos[m_dumpedRow].shutterSpeed << m_photos[m_dumpedRow].fNumber << m_photos[m_dumpedRow].orientation
             << m_photos[m_dumpedRow].camModel << m_photos[m_dumpedRow].make
             << flags
             << "dateTimeOriginal:" << m_photos[m_dumpedRow].dateTimeOriginal
             << "description:" << m_photos[m_dumpedRow].description
             << "artist:" << m_photos[m_dumpedRow].creator
             << "keywords:" << m_photos[m_dumpedRow].keywords ;

    m_dumpedRow++;
}


/** **********************************************************************************************************
 * @brief Deletes all the items of the Model.
 * @details On utilise cette fonction quand on scanne un nouveau répertoire de photos.
 * ***********************************************************************************************************/
void PhotoModel::clear()
{
    beginResetModel();  // cette méthode envoie un signal indiquant à tous que ce modèle va subir un changement radical
    m_photos.clear();
    m_lastCurrentRow = 0;
    endResetModel();    // cette méthode envoie un signal ModelReset.
    // Reset de l'état du cercle et de la sélection pour le nouveau dossier.
    m_lastCircleRadius = 0;
    m_lastCircleLat    = -1000.0;
    m_lastCircleLong   = -1000.0;
    m_circleResetted   = true;
    m_selectionCount   = 0;
    emit selectionCountChanged();
    emit countChanged();
    emit dataCleared();
}


/** **********************************************************************************************************
 * @brief Ce slot lit des données EXIF d'une (ou de toutes les) photos du répertoire, en utilisant la tache
 *        asynchrone ExifReadTask. A la fin de chaque lecture, la tache appelle setData().
 * @param photo : l'indice de la photo (vide ou -1 = toutes les photos du répertoire)
 * ***********************************************************************************************************/
void PhotoModel::fetchExifMetadata(int photo)
{
    this->setLoading(true);
    // qSetMessagePattern("%{time process}");
    if (photo > -1)
    {
        qDebug() << "fetchExifMetadata" << photo;
        m_pendingReadTasks = 1;
        // On lit les tags d'une photo
        ExifReadTask *task = new ExifReadTask(photo, m_photos[photo].imageUrl);
        task->run();
    }
    else
    {
        qDebug() << "fetchExifMetadata" << "all photos";
        // On lit les tags de toutes les photos
        QThreadPool::globalInstance()->setMaxThreadCount(3);   // Quantité maximum de threads
        // Mesures pour scanner 40 photos:
        // 1 par 1 = 32sec - 2 par 2 = 18sec - 3 par 3 = 13sec - 4 par 4 = 12sec - 5 par 5 = 12sec
        ExifReadTask::init(this);
        m_pendingReadTasks = m_photos.count();
        //Instanciation et ajout de plusieurs tâches au pool de threads
        for (int row = 0; row < m_photos.count(); row++)
        {
            ExifReadTask *task = new ExifReadTask(row, m_photos[row].imageUrl);
            QThreadPool::globalInstance()->start(task);
        }
        // On n'a pas besoin d'attendre de la fin de l'exécution des tâches du pool de threads.
        // QThreadPool::globalInstance()->waitForDone();
    }
}


/** **********************************************************************************************************
 * @brief Ce slot écrit dans les fichiers JPG (de façon asynchrone) les metadonnées IPTC des photos qui ont été modifiées.
 * Ce slot est connecté au signal QML saveMetadata émis par ToolBarBottom.
 * @note Tag obligatoire: `imageUrl`.
 * @note Tags modifiés: `GPS coords, Creator, City, Country, Location, DateTimeOriginal`.
 * @note Tags automatiques: `GPS Ref, MetadataEditingSoftware`.
 * ***********************************************************************************************************/
void PhotoModel::saveMetadata()
{
    qDebug() << "saveMetadata";

    // On recupère certaines infos dans les Settings
    QSettings settings;
    bool backupsEnabled = settings.value("backupsEnabled", false).toBool();

    // On cree le pool de threads.
    QThreadPool::globalInstance()->setMaxThreadCount(3);
    // On parcourt tous les items du modèle (par leur indice dans le vecteur)
    int row = 0;
    int taskCount = 1;
    QModelIndex idx = this->index(row, 0);
    while (idx.isValid())
    {
        // On teste si cette photo a été modifiée et doit être enregistrée
        if (idx.data(ToBeSavedRole).toBool() && !idx.data(IsMarkerRole).toBool())
        {
            // On écrit uniquement les tags modifiés depuis la dernière lecture/sauvegarde
            const QSet<QString>& dirty = m_photos[row].dirtyFields;
            QVariantMap exifData;
            exifData.insert("index", idx);
            exifData.insert("imageUrl", idx.data(ImageUrlRole));
            exifData.insert("MetadataEditingSoftware", settings.value("metadataSoftware", "TiPhotoLocator").toString());
            // GPS: les 4 champs sont liés — on les écrit ensemble si l'un d'eux est modifié
            if (dirty.contains("GPSLatitude") || dirty.contains("GPSLongitude")) {
                exifData.insert("GPSLatitude",    idx.data(LatitudeRole));
                exifData.insert("GPSLongitude",   idx.data(LongitudeRole));
                exifData.insert("GPSLatitudeRef", idx.data(LatitudeRole).toDouble() > 0 ? "N" : "S");
                exifData.insert("GPSLongitudeRef",idx.data(LongitudeRole).toDouble() > 0 ? "E" : "W");
            }
            if (dirty.contains("DateTimeOriginal"))
                exifData.insert("DateTimeOriginal", idx.data(DateTimeOriginalRole));
            if (dirty.contains("Creator"))
                exifData.insert("Creator", idx.data(CreatorRole));
            if (dirty.contains("City"))
                exifData.insert("City", idx.data(CityRole));
            if (dirty.contains("Country"))
                exifData.insert("Country", idx.data(CountryRole));
            if (dirty.contains("Location"))
                exifData.insert("Location", idx.data(LocationRole));
            if (dirty.contains("Description"))
                exifData.insert("Description", idx.data(DescriptionRole));
            if (dirty.contains("CaptionWriter"))
                exifData.insert("CaptionWriter", idx.data(CaptionWriterRole));
            if (dirty.contains("Keywords"))
                exifData.insert("Keywords", idx.data(KeywordsRole));

            //Instanciation et ajout de la tâche au pool de threads
            ExifWriteTask *task = new ExifWriteTask(exifData, this, backupsEnabled);
            QThreadPool::globalInstance()->start(task);
            taskCount++;
        }
        idx = idx.siblingAtRow(++row);
    }
    this->setWriteProgress(taskCount);
    emit dataSaved();
}


/** **********************************************************************************************************
 * @brief Adds a test item to the PhotoModel. (only if **DebugMode** is enabled in the *Settingss)
 * @note For testing purpose.
 * ***********************************************************************************************************/
void PhotoModel::addTestItem()
{
    QSettings settings;
    bool debugMode = settings.value("debugModeEnabled", false).toBool();
    if (!debugMode) return;

    this->m_photos << Photo("IMG_00000001", "qrc:///Pictures/IMG_00000001.png");
    QVariantMap ibizaData;
    ibizaData.insert("FileName", "IMG_00000001");
    ibizaData.insert("DateTimeOriginal", "2023:08:25 01:03:16");
    ibizaData.insert("Make", "Generative AI");
    ibizaData.insert("Model", "Midjourney");
    ibizaData.insert("ImageHeight", 603);
    ibizaData.insert("ImageWidth", 603);
    ibizaData.insert("City", "Ibiza");
    ibizaData.insert("Country", "Baleares");
    ibizaData.insert("Location", "Southern beach");
    ibizaData.insert("Creator", "Midjourney");
    ibizaData.insert("GPSLatitude", 38.9148);
    ibizaData.insert("GPSLongitude", 1.4351);
    ibizaData.insert("ShutterSpeed", 0.008);  // 1/125e
    ibizaData.insert("FNumber", 2.8);
    ibizaData.insert("Description", "Have fun !");
    this->setData(ibizaData);
}


/** **********************************************************************************************************
 * @brief Fonction typique qui supprime l'item désigné du modèle.
 * @param row : la position dans le vecteur de l'item à supprimer.
 * ***********************************************************************************************************/
void PhotoModel::removeData(int row)
{
    if (row < 0 || row >= m_photos.count())
        return;

    beginRemoveRows(QModelIndex(), row, row);
    m_photos.removeAt(row);
    endRemoveRows();
    emit countChanged();
}


/** **********************************************************************************************************
 * @brief Duplicates an item of the model, and add it at the end of the vector.
 * @param row : item row to be duplicated.
 * ***********************************************************************************************************/
void PhotoModel::duplicateData(int row)
{
    if (row < 0 || row >= m_photos.count())
        return;

    const Photo photo = m_photos[row];
    const int rowOfInsert = row + 1;

    beginInsertRows(QModelIndex(), rowOfInsert, rowOfInsert);
    m_photos.insert(rowOfInsert, photo);
    endInsertRows();
    emit countChanged();
}


/** **********************************************************************************************************
 * @brief La méthode get() (invocable par QML) renvoie les données de la photo demandée.
 *        Usage dans QML: `titre = myModel.get(1).title;`
 * @param row : indice.
 * @returns une Map contenant toutes les propriétés de l'item, dont la propriété spéciale: "row".
 * ***********************************************************************************************************/
QVariantMap PhotoModel::get(int row)
{
    // Si row est hors bornes, on utilise une Photo vide pour garantir des QVariants bien typés
    // (évite les erreurs QML "Unable to assign [undefined] to QString" quand le modèle est vide).
    const Photo& photo = (row >= 0 && row < m_photos.count()) ? m_photos.at(row) : Photo();

    QVariantMap result;
    result["row"]              = row;
    result["filename"]         = photo.filename;
    result["imageUrl"]         = photo.imageUrl;
    result["latitude"]         = photo.gpsLatitude;
    result["longitude"]        = photo.gpsLongitude;
    result["hasGPS"]           = photo.hasGPS;
    result["isCurrent"]        = photo.isCurrent;
    result["isSelected"]       = photo.isSelected;
    result["isMarker"]         = photo.isMarker;
    result["insideCircle"]     = photo.insideCircle;
    result["toBeSaved"]        = photo.toBeSaved;
    result["dateTimeOriginal"] = photo.dateTimeOriginal;
    result["camModel"]         = photo.camModel;
    result["make"]             = photo.make;
    result["imageWidth"]       = photo.imageWidth;
    result["imageHeight"]      = photo.imageHeight;
    result["orientation"]      = photo.orientation;
    result["shutterSpeed"]     = photo.shutterSpeed;
    result["fNumber"]          = photo.fNumber;
    result["creator"]          = photo.creator;
    result["city"]             = photo.city;
    result["country"]          = photo.country;
    result["location"]         = photo.location;
    result["description"]      = photo.description;
    result["captionWriter"]    = photo.captionWriter;
    result["software"]         = photo.software;
    result["metadata"]         = photo.metadata;
    result["keywords"]         = photo.keywords;
    return result;
}


/** **********************************************************************************************************
 * @brief Cette méthode (invocable par QML) ajoute la photo désignée aux photos sélectionnées.
 * @param row : indice de la photo dans la listView
 * @param exclusive : if True, all other Photos are unselected.
 * ***********************************************************************************************************/
void PhotoModel::addToSelection(int row, bool exclusive)
{
    qDebug() << "addToSelection" << row;
    // Le paramètre 'exclusive' déselectionne toutes les autres photos.
    if (exclusive)
        this->resetSelection();
    QModelIndex idx = this->index(row, 0);
    this->setData(idx, true, IsSelectedRole);
    m_selectionCount++;
    emit selectionCountChanged();
}

/** **********************************************************************************************************
 * @brief Cette méthode enlève la photo désignée des photos sélectionnées.
 * @param row : indice de la photo dans la listView
 * ***********************************************************************************************************/
void PhotoModel::removeFromSelection(int row)
{
    qDebug() << "removeFromSelection" << row;
    QModelIndex idx = this->index(row, 0);
    this->setData(idx, false, IsSelectedRole);
    m_selectionCount--;
    emit selectionCountChanged();
}


/** **********************************************************************************************************
 * @brief Ajoute le flag "isSelected" à toutes les photos qui n'ont pas de date.
 * ***********************************************************************************************************/
void PhotoModel::selectUndated()
{
    // On parcourt tous les items du modèle
    int row = 0;
    QModelIndex idx = this->index(row, 0);
    while (idx.isValid())
    {
        if (m_photos[row].dateTimeOriginal.isEmpty()) {
            m_photos[row].isSelected = true;
            emit dataChanged(idx, idx, QVector<int>() << IsSelectedRole);
        }
        idx = idx.siblingAtRow(++row);
    }
    this->selectionCount();
}


/** **********************************************************************************************************
 * @brief Ajoute le flag "isSelected" à toutes les photos qui n'ont pas de coordonnées GPS.
 * ***********************************************************************************************************/
void PhotoModel::selectUnlocalized()
{
    // On parcourt tous les items du modèle
    int row = 0;
    QModelIndex idx = this->index(row, 0);
    while (idx.isValid())
    {
        if (!m_photos[row].hasGPS) {
            m_photos[row].isSelected = true;
            emit dataChanged(idx, idx, QVector<int>() << IsSelectedRole);
        }
        idx = idx.siblingAtRow(++row);
    }
    this->selectionCount();
}


/** **********************************************************************************************************
 * @brief Ajoute le flag "isSelected" à toutes les photos.
 * ***********************************************************************************************************/
void PhotoModel::selectAll()
{
    // On parcourt tous les items du modèle
    int row = 0;
    QModelIndex idx = this->index(row, 0);
    while (idx.isValid())
    {
        m_photos[row].isSelected = true;
        idx = idx.siblingAtRow(++row);
    }
    // A la fin, on notifie en une seule fois l'ensemble des photos.
    emit dataChanged(this->index(0, 0), index(m_photos.count()-1, 0), QVector<int>() << IsSelectedRole);
    m_selectionCount = m_photos.count();
    emit selectionCountChanged();
}


/** **********************************************************************************************************
 * @brief Parcourt toutes les Photo du modèle, et flague celles qui sont à l'interieur du cercle demandé.
 *        Fonction avec mécanisme de Mutuelle Exclusion (MUTEX).
 * @param circle_radius: Le rayon du cercle (en mètres).
 *        Si *circle_radius* vaut **0**, alors on enleve les pictos "circle".
 *        Si *circle_radius* vaut **-1**, (*default value*) alors on réutilise la dernière valeur de rayon reçue.
 *
 * On utilise les conversions: **1°lat = 111km**  et  **1°long = 111km x cos(lat)**.
 * @see PhotoModel::resetCircle et PhotoModel::belong
 * @note: les appels rapprochés sont protégés par Mutex au niveau de PhotoModel
 * ***********************************************************************************************************/
void PhotoModel::findInCirclePhotos(int circle_radius)
{
    // Résolution du rayon : on capture l'ancienne valeur avant mise à jour pour la comparaison Cas 2.
    int previousRadius = m_lastCircleRadius;
    if (circle_radius==-1) circle_radius = m_lastCircleRadius;
    else m_lastCircleRadius = circle_radius;

    // Cas 0 : rayon nul → effacer le cercle (resetCircle a son propre guard m_circleResetted)
    if (circle_radius==0)  {
        this->resetCircle();
        return;
    }
    m_circleResetted = false;

    // Le centre du cercle est la photo sélectionnée
    double circle_lat  = m_photos[m_lastCurrentRow].gpsLatitude;
    double circle_long = m_photos[m_lastCurrentRow].gpsLongitude;

    // Cas 1 : photo courante sans GPS → pas de centre valide, on efface le cercle
    if (!m_photos[m_lastCurrentRow].hasGPS) {
        this->resetCircle();
        return;
    }

    // Cas 2 : centre et rayon identiques au calcul précédent → résultat inchangé
    if (circle_lat == m_lastCircleLat && circle_long == m_lastCircleLong && circle_radius == previousRadius) {
        return;
    }
    m_lastCircleLat  = circle_lat;
    m_lastCircleLong = circle_long;
    //qDebug() << "findInCirclePhotos" << circle_lat << circle_long << circle_radius << "m";

    double rayon_lat  = double(circle_radius) / 111111;                             // 1° lat ≈ 111 111 m
    double rayon_long = abs(rayon_lat / cos(qDegreesToRadians(circle_lat)));        // cos() attend des radians
    // qDebug() << "constantes: Rlat" << rayon_lat << ", Rlon" << rayon_long;

    // On parcourt tous les items du modèle (qui ont des coords GPS) pour positionner insideCircle.
    int row = 0;
    int selectionCount = 0;
    QModelIndex idx = this->index(row, 0);
    while (idx.isValid())
    {
        if (idx.data(HasGPSRole).toBool())
        {
            // Si la Photo est dans le cercle : on positionne "insideCircle" à true.
            if (belong(m_photos[row].gpsLatitude, m_photos[row].gpsLongitude, circle_lat, circle_long, rayon_lat, rayon_long) )
            {
                m_photos[row].insideCircle = true;
                m_photos[row].isSelected = true;
            }
            else
            {
                // Sinon on positionne "insideCircle" à false.
                m_photos[row].insideCircle = false;
                m_photos[row].isSelected = false;
            }
        }
        if (m_photos[row].isSelected) selectionCount++;
        idx = idx.siblingAtRow(++row);
    }
    // A la fin, on notifie en une seule fois l'ensemble de toutes les photos.
    emit dataChanged(this->index(0, 0), index(m_photos.count()-1, 0), QVector<int>() << InsideCircleRole << IsSelectedRole);

    // On actualise le nombre de photos sélectionées
    m_selectionCount = selectionCount;
    emit selectionCountChanged();
}


/** **********************************************************************************************************
 * @brief Enleve le flag "insideCircle" à toutes les photos.
 * ***********************************************************************************************************/
void PhotoModel::resetCircle()
{
    // Si cela a déjà été fait, on ne recommence pas.
    if (m_circleResetted) return;

    // On parcourt tous les items du modèle : on déselectionne uniquement les photos du cercle.
    int selectionCount = 0;
    int row = 0;
    QModelIndex idx = this->index(row, 0);
    while (idx.isValid())
    {
        if (m_photos[row].insideCircle) {
            m_photos[row].insideCircle = false;
            if (row != m_lastCurrentRow)       // la photo courante reste sélectionnée (marqueur carte)
                m_photos[row].isSelected = false;
        }
        if (m_photos[row].isSelected) selectionCount++;
        idx = idx.siblingAtRow(++row);
    }
    // A la fin, on notifie en une seule fois l'ensemble des photos.
    emit dataChanged(this->index(0, 0), index(m_photos.count()-1, 0), QVector<int>() << InsideCircleRole << IsSelectedRole);
    m_selectionCount = selectionCount;
    emit selectionCountChanged();
    m_circleResetted = true;
    // Invalider le cache de centre : le prochain findInCirclePhotos devra recalculer.
    m_lastCircleLat  = -1000.0;
    m_lastCircleLong = -1000.0;
}

/** **********************************************************************************************************
 * @brief Enleve le flag "isSelected" à toutes les photos.
 * ***********************************************************************************************************/
void PhotoModel::resetSelection()
{
    // On parcourt tous les items du modèle
    int row = 0;
    QModelIndex idx = this->index(row, 0);
    while (idx.isValid())
    {
        m_photos[row].isSelected = false;
        idx = idx.siblingAtRow(++row);
    }
    // A la fin, on notifie en une seule fois l'ensemble des photos.
    emit dataChanged(this->index(0, 0), index(m_photos.count()-1, 0), QVector<int>() << IsSelectedRole);
    m_selectionCount = 0;
    emit selectionCountChanged();
}

/** **********************************************************************************************************
 * @brief Positionne le flag "loading" qui indique que le modèle est en train de se remplir avec les données EXIF.
 * @param state: True pour indiquer que la lecture est en cours.
 * ***********************************************************************************************************/
void PhotoModel::setLoading(const bool state)
{
    m_loading = state;
    emit loadingChanged();
}

/** **********************************************************************************************************
 * @brief Appelé par chaque ExifReadTask à la fin de son exécution.
 *        Décrémente le compteur et arrête le BusyIndicator quand toutes les tâches sont terminées.
 * ***********************************************************************************************************/
void PhotoModel::readTaskFinished()
{
    if (--m_pendingReadTasks <= 0)
    {
        m_pendingReadTasks = 0;
        this->setLoading(false);
    }
}

/** **********************************************************************************************************
 * @brief PhotoModel::setWriteProgress
 * @param total : Nombre de photos dont on veut écrire les exifs.
 *    Si 0 ou non fourni, alors c'est que l'on vient de faire une écriture.
 * ***********************************************************************************************************/
void PhotoModel::setWriteProgress(const int total)
{
    if (total == 0)
        m_countWrite++;
    else
        m_totalWrite = total-1;

    // On convertit dans une valeur entre 0 et 1.
    m_writeProgress = qreal(m_countWrite) / m_totalWrite;
    // qDebug() << "progress" << m_countWrite <<"/" << m_totalWrite << "=" << m_writeProgress ;
    emit writeProgressChanged();
}


/** **********************************************************************************************************
 * @brief Indique si le point P de coordonnées (pX, pY) appartient au cercle de centre O (oX, oY) et de rayon R.
 * @param pLa : Latitude du point à tester.
 * @param pLo : Longitude du point à tester.
 * @param oLa : Latitude de l'origine du cercle.
 * @param oLo : Longitude de l'origine du cercle.
 * @param rLa : le rayon du cercle sur l'axe des Latitudes N-S(en degrés).
 * @param rLo : le rayon du cercle sur l'axe des Longitudes E-W (en degrés).
 * @return true si le point est dans le cercle.
 * ***********************************************************************************************************/
bool PhotoModel::belong(double pLa, double pLo, double oLa, double oLo, double rLa, double rLo)
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
    {
        // Le point est dans le carré englobant: on vérifie qu'il est dans le cercle (ellipse normalisée).
        double dLa = (pLa - oLa) / rLa;
        double dLo = (pLo - oLo) / rLo;
        return (dLa * dLa + dLo * dLo) <= 1.0;
    }
}


/** **********************************************************************************************************
 * @brief Applique le "photographe" à toutes les photos du modèle.
 * @details Le nom du photographe est configuré dans les Settings.
 * ***********************************************************************************************************/
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
        m_photos[row].dirtyFields.insert("Creator");
        idx = idx.siblingAtRow(++row);
    }
    // A la fin, on notifie en une seule fois l'ensemble des photos.
    emit dataChanged(this->index(0, 0), index(m_photos.count()-1, 0), QVector<int>() << CreatorRole << ToBeSavedRole);
}


/** **********************************************************************************************************
 * @brief Applique le "photographe" aux photos sélectionnées du modèle.
 * @details Le nom du photographe est configuré dans les Settings.
 * ***********************************************************************************************************/
void PhotoModel::applyCreatorToSelection()
{
    QSettings settings;
    QString photographe = settings.value("photographe", "").toString();
    if (photographe.isEmpty()) return;

    int row = 0;
    QModelIndex idx = this->index(row, 0);
    while (idx.isValid())
    {
        if (m_photos[row].isSelected)
        {
            m_photos[row].creator = photographe;
            m_photos[row].toBeSaved = true;
            m_photos[row].dirtyFields.insert("Creator");
        }
        idx = idx.siblingAtRow(++row);
    }
    emit dataChanged(this->index(0, 0), index(m_photos.count()-1, 0), QVector<int>() << CreatorRole << ToBeSavedRole);
}


/** **********************************************************************************************************
 * @brief Enlève un des mots-clef descriptif de la photo.
 * @param keyword : le mot-clef à retirer de la liste.
 * @note Cette méthode modifie la Photo actuellement sélectionée.
 * ***********************************************************************************************************/
void PhotoModel::removePhotoKeyword(const QString& keyword)
{
    if (m_photos[m_lastCurrentRow].keywords.contains(keyword))
    {
        qDebug() << "Remove" << keyword << "keyword";
        m_photos[m_lastCurrentRow].keywords.removeOne(keyword);
        m_photos[m_lastCurrentRow].toBeSaved = true;
        m_photos[m_lastCurrentRow].dirtyFields.insert("Keywords");
        QModelIndex idx = this->index(m_lastCurrentRow, 0);
        emit dataChanged(idx, idx, QVector<int>() << KeywordsRole << ToBeSavedRole);
    }
}


/** **********************************************************************************************************
 * @brief Ajoute un mot-clef à toutes les photos qui ne le possèdent pas déjà.
 * @param keyword : le mot-clef à ajouter.
 * ***********************************************************************************************************/
void PhotoModel::addKeywordToAll(const QString& keyword)
{
    for (int row = 0; row < m_photos.count(); ++row)
    {
        if (!m_photos[row].keywords.contains(keyword))
        {
            m_photos[row].keywords << keyword;
            m_photos[row].toBeSaved = true;
            m_photos[row].dirtyFields.insert("Keywords");
        }
    }
    emit dataChanged(this->index(0, 0), index(m_photos.count()-1, 0), QVector<int>() << KeywordsRole << ToBeSavedRole);
}


/** **********************************************************************************************************
 * @brief Ajoute un mot-clef aux photos sélectionnées qui ne le possèdent pas déjà.
 * @param keyword : le mot-clef à ajouter.
 * ***********************************************************************************************************/
void PhotoModel::addKeywordToSelection(const QString& keyword)
{
    for (int row = 0; row < m_photos.count(); ++row)
    {
        if (m_photos[row].isSelected && !m_photos[row].keywords.contains(keyword))
        {
            m_photos[row].keywords << keyword;
            m_photos[row].toBeSaved = true;
            m_photos[row].dirtyFields.insert("Keywords");
            QModelIndex idx = this->index(row, 0);
            emit dataChanged(idx, idx, QVector<int>() << KeywordsRole << ToBeSavedRole);
        }
    }
}


/** **********************************************************************************************************
 * @brief Remplace un keyword (mots-clef descriptif) par un autre dans la photo courante.
 * @param keyword : la nouvelle valeur du mot-clef.
 * @param index : la position du mot-clef dans la liste.
 * @note Cette méthode modifie la Photo actuellement sélectionée.
 * ***********************************************************************************************************/
void PhotoModel::replaceKeywordForCurrent(const QString& keyword, int index)
{
    // on vérifie que l'index est valide
    if (index<0 || index >= m_photos[m_lastCurrentRow].keywords.count()) return;

    m_photos[m_lastCurrentRow].keywords[index] = keyword;
    m_photos[m_lastCurrentRow].toBeSaved = true;
    m_photos[m_lastCurrentRow].dirtyFields.insert("Keywords");
    QModelIndex idx = this->index(m_lastCurrentRow, 0);
    emit dataChanged(idx, idx, QVector<int>() << KeywordsRole << ToBeSavedRole);
    emit sendSuggestion(keyword, "keywords", "tag", -1);
}


/** **********************************************************************************************************
 * @brief Remplace un keyword par un autre dans toutes les photos sélectionnées.
 * Recherche par valeur (pas par index) pour gérer les listes de longueurs différentes.
 * @param oldKeyword : le mot-clef à remplacer.
 * @param newKeyword : le nouveau mot-clef.
 * ***********************************************************************************************************/
void PhotoModel::replaceKeywordForSelection(const QString& oldKeyword, const QString& newKeyword)
{
    for (int row = 0; row < m_photos.count(); row++)
    {
        if (!m_photos[row].isSelected) continue;
        int idx = m_photos[row].keywords.indexOf(oldKeyword);
        if (idx < 0) continue;
        m_photos[row].keywords[idx] = newKeyword;
        m_photos[row].toBeSaved = true;
        m_photos[row].dirtyFields.insert("Keywords");
        QModelIndex qidx = this->index(row, 0);
        emit dataChanged(qidx, qidx, QVector<int>() << KeywordsRole << ToBeSavedRole);
    }
    emit sendSuggestion(newKeyword, "keywords", "tag", -1);
}


/** **********************************************************************************************************
 * @brief Affecte les coordonnées GPS fournies à toutes les photos sélectionnées.
 * @param coords: des coordonnées GPS.
 * Il faut distinguer le cas des photos sélectionées manuellement, et les photos sélectionées parce qu'elles
 * sont dans le cercle. A priori, on ne veut pas modifier les photos du cercle.
 * Solution A: si Rayon>0 ; on modifie uniquement la photo courante (easiest).
 * Solution B: On teste si la photo est dans le cercle avant de la modifier ou pas.
 * ***********************************************************************************************************/
void PhotoModel::setSelectedItemsCoords(QGeoCoordinate coords)
{
    // Solution A
    if (m_lastCircleRadius>0)
    {
        this->currentItemCoords(coords);
        this->findInCirclePhotos();
    }
    else
    {
        // On parcourt tous les items du modèle, pour trouver celles qui sont sélectionées
        int row = 0;
        QModelIndex idx = this->index(row, 0);
        while (idx.isValid())
        {
            if (m_photos[row].isSelected) {
                this->setData(idx, coords.latitude(), LatitudeRole);
                this->setData(idx, coords.longitude(), LongitudeRole);
            }
            idx = idx.siblingAtRow(++row);
        }
    }
}

/** **********************************************************************************************************
 * @brief Compte le nombre de photos sélectionnées.
 * ***********************************************************************************************************/
void PhotoModel::selectionCount()
{
    int count = 0;
    // On parcourt tous les items du modèle
    int row = 0;
    QModelIndex idx = this->index(row, 0);
    while (idx.isValid())
    {
        if (m_photos[row].isSelected) {
            count++;
        }
        idx = idx.siblingAtRow(++row);
    }
    m_selectionCount = count;
    emit selectionCountChanged();
}

/** **********************************************************************************************************
 * @brief Cherche des suggestions de keywords, country, city, location pour la photo courante,
 * en allant regarder dans les tags des autres photos de la selection.
 * ***********************************************************************************************************/
void PhotoModel::suggestFromSelection()
{
    // On parcourt tous les items du modèle
    int row = 0;
    QModelIndex idx = this->index(row, 0);
    while (idx.isValid())
    {
        if (m_photos[row].isSelected) {
            this->suggestFromPhoto(row);
        }
        idx = idx.siblingAtRow(++row);
    }
}

/** **********************************************************************************************************
 * @brief Envoie des suggestions de keywords, country, city, location pour la photo courante,
 * en allant regarder dans les tags de la photo fournie.
 * ***********************************************************************************************************/
void PhotoModel::suggestFromPhoto(const int row)
{
    emit sendSuggestion(m_photos[row].city, "city", "tag", -1);
    emit sendSuggestion(m_photos[row].country, "country", "tag", -1);
    emit sendSuggestion(m_photos[row].location, "location", "tag", -1);
}


/** **********************************************************************************************************
 * @brief PhotoModel::flags
 * @param index
 * @return
 * ***********************************************************************************************************/
Qt::ItemFlags PhotoModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return (Qt::ItemIsEditable | Qt::ItemIsEnabled | Qt::ItemIsSelectable);
}


/** **********************************************************************************************************
 * @brief Surcharge de l'opérateur ==.
 * @param file_name: Le texte à comparer
 * @return True si le **filename** de la photo correspond au texte passé en paramètre.
 * ***********************************************************************************************************/
bool Photo::operator == (const QString &file_name)
{
    if (this->filename == file_name)
        return true;
    return false;
}


/** **********************************************************************************************************
 * @brief Opérateur de comparaison standard.
 * @param photo : Un autre objet photo
 * @return True si les deux objets pointent sur les mêmes data.
 * ***********************************************************************************************************/
bool Photo::operator == (const Photo &photo)
{
    if (this->filename == photo.filename)
        return true;
    return false;
}

