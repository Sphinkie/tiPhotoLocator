# TI PHOTO LOCATOR

work in progress

## Présentation

When you have a GPX file, that you recorded during your trip, you can sync your photos with the GPX file.
But, if you don't have recorded any GPX file, or if your photos are older than handheld GPS devices, the **TiPhotoLocator** application will help you to geotag easily your photos on a map, and add some description tags.

## Tags

**TiPhotoLocator** manages the following EXIF and IPTC tags.



Les données EXIF et les données IPTC sont deux types de métadonnées utilisées dans la photographie numérique. Les données EXIF sont générées automatiquement par l'appareil photo et contiennent des informations techniques sur la prise de vue, tandis que les données IPTC sont des métadonnées ajoutées manuellement par l'utilisateur et contenant des informations éditoriales, telles que le titre, la description, les droits d'auteur, etc.

### Exif tags

EXchangeable Image Fileformat 

https://exiftool.org/TagNames/EXIF.html


| Tag name | Read |  Write | Id & group | Description | 
| -------- | ---- |  ----- | ---------- | ----------- | 
| ImageWidth  | yes | no | 0x0100 IFD0 | Image width  | 
| ImageHeight | yes | no | 0x0101 IFD0 | Image height | 
| ImageDescription | yes | no | 0x010e IDF0 | Image description (pure ASCII) | 
| Make        | yes | no  | 0x010f IFD0 | Camera manufacturer | 
| Model       | yes | no  | 0x0110 IFD0 | Camera model        | 
| Software    | --  | yes | 0x0131 IFD0 | "TiPhotoLocator"    | 
| Artist      | yes | opt | 0x013b IFD0 | Nom du photographe  | 
| GPSLatitude      | yes | yes | 0x8825 IFD0 | Photo location |
| GPSLongitude     | yes | yes | 0x8825 IFD0 | Photo location |
| GPSLatitudeRef   | no  | yes | 0x8825 IFD0 | North or South | 
| GPSLongitudeRef  | no  | yes | 0x8825 IFD0 | East or West   | 
| DateTimeOriginal | yes | no  | 0x9003 ExifIFD | Date/time when the photo was taken | 

IFD : Image File Directory

*When adding GPS information to an image, it is important to set all of the following tags: GPSLatitude, GPSLatitudeRef, GPSLongitude, GPSLongitudeRef.*

### IPTC CORE tags

International Press Telecommunications Council

https://www.iptc.org/std/photometadata/specification/IPTC-PhotoMetadata


| Tag name | Read |  Write | Description | 
| -------- | ---- |  ----- | ----------- | 
| Creator  | yes | yes | Nom du photographe | 
| City     | yes | yes | obsolete - Name of the city of the location shown in the image.| 
| Country  | yes | yes | obsolete - Full name of the country of the location shown in the image.| 
| Description |  |  | Description of the who, what, and why of what is happening in this image. | 
| DescriptionWriter |  |  | Name of the person involved in writing the Description, | 
| Caption  |  |  |  | 
| Keywords |  |  | List of keywords, terms or phrases used to express the subject matter in the image.
 | 
| Landmark |  |  | ??? | 

### IPTC EXTENSION tags

| Tag name         | Read |  Write | Description | 
| ---------------- | ---- |  ----- | ----------- | 
| Location/City    |  |  | IPTC Extension | 
| Location/Country |  |  | IPTC Extension | 


Location shown
- city
- country name
- latitude et longitude
- location name
- province or state
- Name of a sublocation. This sublocation name could either be the name of a sublocation to a city or the name of a well known location or (natural) monument outside a city. In the sense of a sublocation to a city this element is at the fifth level of a top-down geographical hierarchy.
- WorldRegion


### unused 


* **Title**: A short verbal and human readable name for the image, (may be the file name).

* **dateCreated** : La date de création du *sujet*.

* **Headline**: Un titre publiable




## Compilation

To compile the sources of this applciation, you need the Qt framework (Qt6).

### Installation of the developpement environnement

* Install the open-source Qt IDE (Qt Creator)
* Check the following options:
   * Qt 6.x
      * MSVC 2019 64-bits compiler
      * MinGW 64-bits compiler
      * Qt5 Compatibility module *(for DropShadow)*
      * Additional libraries:
         * Qt Locator
         * Qt Positionning
   * OpenSSL *(binaries only)*
   * Qt Installer framework


## Cousin projects

If you recorded a GPX file during your trip, you can sync your photos with GPSync.


https://github.com/Simon-12/tidy-images/blob/main/app/src/main.cpp
