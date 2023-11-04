# TI PHOTO LOCATOR

work in progress

## Présentation

When you have a GPX file, that you recorded during your trip, you can sync your photos with the GPX file.
But, if you don't have recorded any GPX file, or if your photos are older than handheld GPS devices, the **TiPhotoLocator** application will help you to geotag easily your photos on a map, and add some description tags.

## Tags

**TiPhotoLocator** manages the following EXIF and IPTC tags.

exchangeable image file format 

DateTimeOriginal 0x9003 ExifIFD
date time when the photo was taken 

### Exif tags

| Tag name | Read |  Write | Description | 
| -------- | ---- |  ----- | ----------- | 
| Model | yes | no | 0110 IDF0 camera model | 
| Make | yes |  no | 010f IDF0 camera manufacturer | 
| ImageWidth | yes | no | 0100 IDF0 Image width | 
| ImageHeight | yes | no | 0101 IDF0 Image height | 
| ImageDescription | yes | no | 010e IDF0 | 
| GPSLatitude | yes | yes | 0x8825 IFD0 photo location |
| GPSLongitude | yes | yes | photo location |
| GPSLatitudeRef | no | yes | North or South | 
| GPSLongitudeRef | no |  yes | West or East | 
| Artist | yes | yes | 013b IFD0Nom du photographe | 

IFD : image file directory

When adding GPS information to an image, it is important to set all of the following tags: GPSLatitude, GPSLatitudeRef, GPSLongitude, GPSLongitudeRef, and GPSAltitude and GPSAltitudeRef if the altitude is known.

### IPTC CORE tags

| Tag name | Read |  Write | Description | 
| -------- | ---- |  ----- | ----------- | 
| Description |  |  |  | 
| DescriptionWriter |  |  |  | 
| Caption |  |  |  | 
| Creator | yes | yes | Nom du photographe | 
| City | yes | yes | obsolete | 
| Country | yes | yes | obsolete | 
| Software | -- | yes | 0131 IFD0 "TiPhotoLocator" | 
| Keywords |  |  |  | 
| Landmark |  |  | ??? | 

### IPTC EXTENSION tags

| Tag name | Read |  Write | Description | 
| -------- | ---- |  ----- | ----------- | 
| Location/City |  |  | IPTC Extension | 
| Location/Country |  |  | IPTC Extension | 


## Compilation

To compile the sources of this applciation, you need the Qt framework (Qt6).

### Installation of the developpement environnement

* Install the open-source Qt IDE (Qt Creator)
* Check the following options:
   * Qt 6.x
      * MSVC 2019 64-bits compiler
      * MinGC 64-bits compiler
      * Additional libraries:
         * Qt Locator
         * Qt Positionning
         * Qt5 Compatibility module *(for DropShadow)*
   * OpenSSL *(binaries only)*
   * Qt Installer framework


## Cousin projects

If you recorded a GPX file during your trip, you can sync your photos with GPSync.


https://github.com/Simon-12/tidy-images/blob/main/app/src/main.cpp
