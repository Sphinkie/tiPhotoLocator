# About Tags

**TiPhotoLocator** manages the following EXIF and IPTC tags.

## Exif tags

The **EXchangeable Image Fileformat** (EXIF) format is described on the [exiftool.org website](https://exiftool.org/TagNames/EXIF.html).
It has no official description.   
(`IFD` : Image File Directory)

| Tag name                   | Read | Write | Id & group     | Description        |
| -------------------------- | ---- | ----- | -------------- | ------------------ |
| ImageWidth                 | yes  | --    | 0x0100 IFD0    | Image width        |
| ImageHeight                | yes  | --    | 0x0101 IFD0    | Image height       |
| ImageDescription           | MWG  | MWG   | 0x010e IDF0    | Image description  |
| Make                       | yes  | --    | 0x010f IFD0    | Camera manufacturer|
| Model                      | yes  | --    | 0x0110 IFD0    | Camera model       |
| Orientation                | yes  | --    | 0x0112 IFD0    | Camera orientation |
| ShutterSpeedValue          | yes  | --    | 0x9201 IFD0    | Shutter speed in seconds |
| FNumber                    | yes  | --    | 0x829D IFD0    | Focal stop-number  |
| Software                   | yes  | --    | 0x0131 IFD0    | Camera or Scanner software version |
| Artist                     | yes  | MWG   | 0x013b IFD0    | Name of photographer               |
| GPSLatitude                | yes  | yes   | 0x8825 IFD0    | Photo location     |
| GPSLongitude               | yes  | yes   | 0x8825 IFD0    | Photo location     |
| GPSLatitudeRef             | --   | yes   | 0x8825 IFD0    | North or South     |
| GPSLongitudeRef            | --   | yes   | 0x8825 IFD0    | East or West       |
| DateTimeOriginal           | yes  | yes   | 0x9003 ExifIFD | Date/time when the photo was taken |
| MetadataProcessingSoftware | --   | yes   |                | "TiPhotoLocator"   |

| Tag name | Read | Write | Id & group          | Description |
| -------- | ---- | ----- | ------------------- | ----------- |
| Landmark |      |       | Sony:Note Fabricant |             |

`MWG`: Managed according to the Metadata Working Group recommandations.  

*When adding GPS information to an image, it is important to set all of the following tags: GPSLatitude, GPSLatitudeRef, GPSLongitude, GPSLongitudeRef.*

## IPTC CORE tags

The **International Press Telecommunications Council** format (IPTC) is described in the [iptc.org website](https://www.iptc.org/std/photometadata/specification/IPTC-PhotoMetadata)

| Tag name      | Read | Write | Description                                                                        |
| ------------- | ---- | ----- | --------------------------------------------------------------------------------- |
| Creator       | yes  | yes   | Name of photographer.                                                              |
| City          | yes  | yes   | Obsolete - Name of the city of the location shown in the image.                  |
| Country       | yes  | yes   | Obsolete - Name of the country of the location shown in the image.            |
| Description   | yes  | yes   | Description of the who, what, and why of what is happening in this image.       |
| CaptionWriter | yes  | yes   | Name of the person involved in writing the Description,                   |
| Keywords      | yes  | yes   | List of keywords used to express the subject matter in the image.                  |

`MWG`: Managed according to the Metadata Working Group recommandations.  

## IPTC EXTENSION tags

| Tag name               | Read | Write | Description                |
| ---------------------- | ---- | ----- | -------------------------- |
| Location shown         | ↓    | ↓     | IPTC Extension             |
| Location/City          | MWG  | MWG   |                            |
| Location/Country       | MWG  | MWG   | Country name               |
| Location/latitude      |      |       |                            |
| Location/longitude     |      |       |                            |
| Location/location name |      |       | Location name              |
| Location/state         |      |       | Province or state          |
| Location/sublocation   |      |       | Name of a sublocation to a city or the name of a well known location or (natural) monument outside a city |
| Location/WorldRegion   |      |       | World Region               |

## Unused tags

- **Title**: A short verbal and human readable name for the image, (may be the file name).
- **DateCreated** : Creation date of the *subject* of the image (*La Joconde: 1516*). 
- **Headline**: A publishable title.
- **Caption**: An other description.
