# TI PHOTO LOCATOR

work in progress

## Présentation

When you have a GPX file, that you recorded during your trip, you can sync your photos with the GPX file.
But, if you don't have recorded any GPX file, or if your photos are older than handheld GPS devices, the **TiPhotoLocator** application will help you to geotag easily your photos on a map, and add some description tags.

## Tags

**TiPhotoLocator** manages the following EXIF and IPTC tags.

DateTimeOriginal

### Exif tags

| Tag name | Read |  Write | Description | 
| -------- | ---- |  ----- | ----------- | 
| Model | yes | no | camera model | 
| Make | yes |  no | camera manufacturer | 
| ImageWidth | yes | no | | 
| ImageHeight | yes | no |  | 
| GPSLatitude | yes | yes |  | 
| GPSLongitude | yes | yes |  | 
| GPSLatitudeRef | no | yes |  North or South | 
| GPSLongitudeRef | no |  yes | West or East | 
| Software | -- |  yes | "TiPhotoLocator" | 

ImageDescription
Artist

### IPTC tags

| Tag name | Read |  Write | Description | 
| -------- | ---- |  ----- | ----------- | 
| Description |  |  |  | 
| DescriptionWriter |  |  |  | 
| Caption |  |  |  | 
| Keywords |  |  |  | 
| Creator | yes |  |  | 
| City | yes |  | obsolete | 
| Country |  |  | obsolete | 
| Landmark |  |  | ??? | 
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
