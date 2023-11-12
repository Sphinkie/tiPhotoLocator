# TI PHOTO LOCATOR

work in progress

## Présentation

When you have a GPX file, that you recorded during your trip, you can sync your photos with the GPX file.
But, if you don't have recorded any GPX file, or if your photos are older than handheld GPS devices, the **TiPhotoLocator** application will help you to geotag easily your photos on a map, and add some description tags.

## Technical information

### Exif and IPTC tags

Les données **EXIF** et les données **IPTC** sont deux types de métadonnées utilisées dans la photographie numérique.

Les données **EXIF** sont générées automatiquement par l'appareil photo et contiennent des informations techniques sur la prise de vue, tandis que les données **IPTC** sont des métadonnées ajoutées manuellement par l'utilisateur et contenant des informations éditoriales, telles que le titre, la description, les droits d'auteur, etc.

Details concerning the tags used by the application are on [this page](docs/about_tags.md)

### Compilation

The application is developped with the [Qt framework](https://qt.io).

Explanation concerning the compiler configuration are on [this page](docs/compilation.md)


## Cousin projects

Application to geotag your photos with a .gpx file : [GPicSync](
https://github.com/notfrancois/GPicSync)

A photo gallery developed with Qt, exiv2 and OpenCV: [Tidy Images](https://github.com/Simon-12/tidy-images) by Simon-12.