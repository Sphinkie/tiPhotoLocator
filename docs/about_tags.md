# TI PHOTO LOCATOR

## About Tags

**TiPhotoLocator** manages the following EXIF and IPTC tags.


### Exif tags

The **EXchangeable Image Fileformat** (EXIF) format is described on the [exiftool.org website](https://exiftool.org/TagNames/EXIF.html).
It has no official description.   
(IFD : Image File Directory)



| Tag name    | Read |  Write | Id & group | Description | 
| ----------- | ---- |  ----- | ---------- | ----------- | 
| ImageWidth  | yes | no | 0x0100 IFD0 | Image width  | 
| ImageHeight | yes | no | 0x0101 IFD0 | Image height | 
| ImageDescription | yes | no | 0x010e IDF0 | Image description (pure ASCII) | 
| Make        | yes | no  | 0x010f IFD0 | Camera manufacturer | 
| Model       | yes | no  | 0x0110 IFD0 | Camera model        | 
| Software    | --  | yes | 0x0131 IFD0 | "TiPhotoLocator"    | 
| Artist      | yes | opt | 0x013b IFD0 | Name of photographer | 
| GPSLatitude      | yes | yes | 0x8825 IFD0 | Photo location |
| GPSLongitude     | yes | yes | 0x8825 IFD0 | Photo location |
| GPSLatitudeRef   | no  | yes | 0x8825 IFD0 | North or South | 
| GPSLongitudeRef  | no  | yes | 0x8825 IFD0 | East or West   | 
| DateTimeOriginal | yes | no  | 0x9003 ExifIFD | Date/time when the photo was taken | 

| Tag name    | Read |  Write | Id & group | Description | 
| ----------- | ---- |  ----- | ---------- | ----------- | 
| Landmark    |      |        | Sony:Note Fabricant | |


*When adding GPS information to an image, it is important to set all of the following tags: GPSLatitude, GPSLatitudeRef, GPSLongitude, GPSLongitudeRef.*

### IPTC CORE tags

The **International Press Telecommunications Council** forlmat (IPTC) is described in the [iptc.org website](https://www.iptc.org/std/photometadata/specification/IPTC-PhotoMetadata)


| Tag name    | Read |  Write | Description | 
| ----------- | ---- |  ----- | ----------- | 
| Creator     | yes  | yes | Name of photographer. | 
| City        | yes  | yes | obsolete - Name of the city of the location shown in the image.| 
| Country     | yes  | yes | obsolete - Full name of the country of the location shown in the image.| 
| Description |      |     | Description of the who, what, and why of what is happening in this image. | 
| DescriptionWriter |  |  | Name of the person involved in writing the Description, | 
| Caption     |  |  |  | 
| Keywords    |  |  | List of keywords, terms or phrases used to express the subject matter in the image. | 

### IPTC EXTENSION tags

| Tag name              | Read |  Write | Description | 
| --------------------- | ---- |  ----- | ----------- | 
| Location shown        | ↓ | ↓ | IPTC Extension | 
| Location/City         |   |  |  | 
| Location/Country      |   |  | Country name | 
| Location/latitude     |   |  |  | 
| Location/longitude    |   |  |  | 
| Location/location name|   |  | location name | 
| Location/state        |   |  | province or state | 
| Location/sublocation  |   |  | Name of a sublocation to a city or the name of a well known location or (natural) monument outside a city | 
| Location/WorldRegion  |   |  | WorldRegion | 



### Unused tags


* **Title**: A short verbal and human readable name for the image, (may be the file name).

* **dateCreated** : Creation date of the *subject* of the image. 

* **Headline**: Un titre publiable


