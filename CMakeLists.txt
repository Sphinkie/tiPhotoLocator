cmake_minimum_required(VERSION 3.16)

project(QT_TiPhotoLocator VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)         # Auto use QRC resource File

find_package(Qt6 REQUIRED COMPONENTS Quick Location)

qt_standard_project_setup(REQUIRES 6.8)
set_source_files_properties(Sources/Qml/Style.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_executable(tiPhotoLocator
    Sources/cpp/main.cpp
    Resources/tiPhotoLocator.qrc
    Resources/appicon.rc
)

qt_add_qml_module(tiPhotoLocator
    URI QT_TiPhotoLocator
    VERSION 1.0
    SOURCES
        Sources/cpp/ExifReadTask.cpp          Sources/cpp/ExifReadTask.h
        Sources/cpp/ExifWriteTask.cpp         Sources/cpp/ExifWriteTask.h
        Sources/cpp/GeocodeWrapper.cpp        Sources/cpp/GeocodeWrapper.h
        Sources/cpp/PhotoModelWrapper.cpp     Sources/cpp/PhotoModelWrapper.h
        Sources/cpp/Utilities.cpp             Sources/cpp/Utilities.h
        Sources/cpp/Models/Photo.h
        Sources/cpp/Models/Suggestion.h
        Sources/cpp/Models/CameraSet.cpp              Sources/cpp/Models/CameraSet.h
        Sources/cpp/Models/OnTheMapProxyModel.cpp     Sources/cpp/Models/OnTheMapProxyModel.h
        Sources/cpp/Models/PhotoModel.cpp             Sources/cpp/Models/PhotoModel.h
        Sources/cpp/Models/SuggestionModel.cpp        Sources/cpp/Models/SuggestionModel.h
        Sources/cpp/Models/SuggestionProxyModel.cpp   Sources/cpp/Models/SuggestionProxyModel.h
        Sources/cpp/Models/UndatedPhotoProxyModel.cpp Sources/cpp/Models/UndatedPhotoProxyModel.h
        Sources/cpp/Models/UnlocalizedProxyModel.cpp  Sources/cpp/Models/UnlocalizedProxyModel.h
        Sources/cpp/Models/SuggestionCategoryProxyModel.cpp  Sources/cpp/Models/SuggestionCategoryProxyModel.h
    RESOURCES
        Resources/tiPhotoLocator.qrc
    QML_FILES
        Sources/Qml/Main.qml
        Sources/Qml/Style.qml
        Sources/Qml/Components/Chips.qml
        Sources/Qml/Components/FatChip.qml
        Sources/Qml/Components/ImagettesListView.qml
        Sources/Qml/Components/SuggestionRepeater.qml
        Sources/Qml/Components/MapView.qml
        Sources/Qml/Components/MainMenuBar.qml
        Sources/Qml/Components/TinyChip.qml
        Sources/Qml/Components/PhotoListview.qml
        Sources/Qml/Components/TabFramePhotoPreview.qml
        Sources/Qml/Components/TabFramePhotoTags.qml
        Sources/Qml/Components/TabFrameGlobalTags.qml
        Sources/Qml/Components/TabFramePhotoMap.qml
        Sources/Qml/Components/TimerLoadFolder.qml
        Sources/Qml/Components/Zone.qml
        Sources/Qml/Components/ZoneTitle.qml
        Sources/Qml/Controllers/ZoneExif.qml
        Sources/Qml/Controllers/ZoneIptc.qml
        Sources/Qml/Controllers/PopupMetadata.qml
        Sources/Qml/Controllers/PopupSettings.qml
        Sources/Qml/Controllers/ToolbarBottom.qml
        Sources/Qml/Controllers/MapToolbar.qml
        Sources/Qml/Controllers/ToolbarPrincipale.qml
        Sources/Qml/Controllers/ZoneCamera.qml
        Sources/Qml/Controllers/ZoneGeoloc.qml
        Sources/Qml/Controllers/ZonePhoto.qml
        Sources/Qml/Controllers/ZonePreview.qml
        Sources/Qml/Controllers/ZoneSuggestedTags.qml
        Sources/Qml/Controllers/ZoneSuggestedLocations.qml
        Sources/Qml/Controllers/ZoneUserdata.qml
        Sources/Qml/Dialogs/AboutDialog.qml
        Sources/Qml/Dialogs/ApikeyDialog.qml
        Sources/Qml/Dialogs/CreditsDialog.qml
        Sources/Qml/Dialogs/RescanWarning.qml
        Sources/Qml/Dialogs/TiFolderDialog.qml
        Sources/Qml/Models/ModelFolderList.qml
        Sources/Qml/Vues/ZoneExifForm.ui.qml
        Sources/Qml/Vues/ZoneIptcForm.ui.qml
        Sources/Qml/Vues/PopupMetadataForm.ui.qml
        Sources/Qml/Vues/PopupSettingsForm.ui.qml
        Sources/Qml/Vues/ToolbarBottomForm.ui.qml
        Sources/Qml/Vues/ToolbarMapForm.ui.qml
        Sources/Qml/Vues/ToolbarPrincipaleForm.ui.qml
        Sources/Qml/Vues/ZoneCameraForm.ui.qml
        Sources/Qml/Vues/ZoneGeolocForm.ui.qml
        Sources/Qml/Vues/ZonePhotoForm.ui.qml
        Sources/Qml/Vues/ZonePreviewForm.ui.qml
        Sources/Qml/Vues/ZoneSuggestedTagsForm.ui.qml
        Sources/Qml/Vues/ZoneSuggestedLocationsForm.ui.qml
        Sources/Qml/Vues/ZoneUserdataForm.ui.qml
    QML_FILES
        Sources/Qml/Javascript/Chips.js
        Sources/Qml/Javascript/Networking.js
        Sources/Qml/Javascript/TiUtilities.js
        QML_FILES Sources/Qml/Components/ApplicationLogo.qml
    )

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(tiPhotoLocator PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQT_TiPhotoLocator
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(tiPhotoLocator
    PRIVATE Qt6::Quick Qt6::Location
)

include(GNUInstallDirs)
install(TARGETS tiPhotoLocator
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
