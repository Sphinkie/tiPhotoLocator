QT += quick
QT += positioning
QT += location

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        Models/OnTheMapProxyModel.cpp \
        Models/PhotoModel.cpp \
        Models/SuggestionModel.cpp \
        cpp/ExifReadTask.cpp \
        cpp/ExifReadThread.cpp \
        cpp/ExifReadWorker.cpp \
        cpp/ExifWrapper.cpp \
        cpp/ExifWriteTask.cpp \
        cpp/GeocodeWrapper.cpp \
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
    Components/PhotoPreview.qml \
    images/clock.png

HEADERS += \
    Models/OnTheMapProxyModel.h \
    Models/PhotoModel.h \
    Models/SuggestionModel.h \
    cpp/ExifReadTask.h \
    cpp/ExifReadThread.h \
    cpp/ExifReadWorker.h \
    cpp/ExifWrapper.h \
    cpp/ExifWriteTask.h \
    cpp/GeocodeWrapper.h


HEADERS += \
    Models/OnTheMapProxyModel.h \
    Models/PhotoModel.h \
    cpp/ExifWrapper.h \
    cpp/GeocodeWrapper.h
