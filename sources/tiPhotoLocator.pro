QT += quick
QT += positioning
QT += location
QT += network

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        Models/CameraSet.cpp \
        Models/OnTheMapProxyModel.cpp \
        Models/PhotoModel.cpp \
        Models/SuggestionCategoryProxyModel.cpp \
        Models/SuggestionModel.cpp \
        Models/SuggestionProxyModel.cpp \
        Models/UndatedPhotoProxyModel.cpp \
        Models/UnlocalizedProxyModel.cpp \
        Cpp/ExifReadTask.cpp \
        Cpp/ExifWriteTask.cpp \
        Cpp/GeocodeWrapper.cpp \
        Cpp/PhotoModelWrapper.cpp \
        Cpp/Utilities.cpp \
        main.cpp

RESOURCES += qml.qrc

TRANSLATIONS += \
    tiPhotoLocator_fr_FR.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    Doxyfile \
    TiPhotoLocator.qhp \
    tiPhotoLocator.qdocconf

HEADERS += \
    Models/CameraSet.h \
    Models/OnTheMapProxyModel.h \
    Models/PhotoModel.h \
    Models/SuggestionCategoryProxyModel.h \
    Models/SuggestionModel.h \
    Models/SuggestionProxyModel.h \
    Models/UndatedPhotoProxyModel.h \
    Models/UnlocalizedProxyModel.h \
    Cpp/ExifReadTask.h \
    Cpp/ExifWriteTask.h \
    Cpp/GeocodeWrapper.h \
    Cpp/PhotoModelWrapper.h \
    Cpp/Utilities.h

RC_ICONS = Images/logo_TPL.ico

CONFIG += file_copies

COPIES += myFiles
myFiles.files = $$files(../bin/exiftool.exe)
myFiles.path = $$OUT_PWD/debug

COPIES += myFilesForRelease
myFilesForRelease.files = $$files(../bin/exiftool.exe)
myFilesForRelease.path += $$OUT_PWD/release

