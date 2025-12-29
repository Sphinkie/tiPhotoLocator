cmake_minimum_required(VERSION 3.16)

project(QT_TiPhotoLocator VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Location)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(tiPhotoLocator
    Sources/cpp/main.cpp
    Resources/tiPhotoLocator.qrc
)

qt_add_qml_module(tiPhotoLocator
    URI QT_TiPhotoLocator
    VERSION 1.0
    SOURCES
        Sources/cpp/Models/CameraSet.cpp
        Sources/cpp/Models/CameraSet.h
        Sources/cpp/Models/OnTheMapProxyModel.cpp
        Sources/cpp/Models/OnTheMapProxyModel.h
        Sources/cpp/Models/PhotoModel.cpp
        Sources/cpp/Models/PhotoModel.h
        Sources/cpp/Models/SuggestionCategoryProxyModel.cpp
        Sources/cpp/Models/SuggestionCategoryProxyModel.h
        Sources/cpp/Models/SuggestionModel.cpp
        Sources/cpp/Models/SuggestionModel.h Sources/cpp/Models/SuggestionProxyModel.cpp Sources/cpp/Models/SuggestionProxyModel.h Sources/cpp/Models/UndatedPhotoProxyModel.cpp
        Sources/cpp/Models/UndatedPhotoProxyModel.h Sources/cpp/Models/UnlocalizedProxyModel.cpp Sources/cpp/Models/UnlocalizedProxyModel.h Sources/cpp/ExifReadTask.cpp
        Sources/cpp/ExifReadTask.h
        Sources/cpp/ExifWriteTask.cpp
        Sources/cpp/ExifWriteTask.h
        Sources/cpp/GeocodeWrapper.cpp
        Sources/cpp/GeocodeWrapper.h
        Sources/cpp/PhotoModelWrapper.cpp
        Sources/cpp/PhotoModelWrapper.h
        Sources/cpp/Utilities.cpp
        Sources/cpp/Utilities.h
    RESOURCES
        Resources/tiPhotoLocator.qrc
#       Sources/Qml/Components/qmldir
#       Sources/Qml/Controllers/qmldir
#       Sources/Qml/Dialogs/qmldir
#       Sources/Qml/Models/qmldir
#       Sources/Qml/Vues/qmldir
    QML_FILES
        Sources/Qml/Main.qml
        Sources/Qml/Components/Chips.qml
        Sources/Qml/Components/ExifTitle.qml
        Sources/Qml/Components/FatChip.qml
        Sources/Qml/Components/FolderLoadTimer.qml
        Sources/Qml/Components/ImagettesListView.qml
        Sources/Qml/Components/IptcTitle.qml Sources/Qml/Components/SuggestionRepeater.qml Sources/Qml/Components/TiButton.qml Sources/Qml/Components/TiImagettes.qml
        Sources/Qml/Components/TiMapView.qml Sources/Qml/Components/TiMenuBar.qml Sources/Qml/Components/TinyChip.qml Sources/Qml/Components/TiPhotoListview.qml
        Sources/Qml/Components/TiPhotoPreview.qml Sources/Qml/Components/TiPhotoTags.qml Sources/Qml/Components/TiStyle.qml Sources/Qml/Components/Zone.qml
        Sources/Qml/Components/ZoneTitle.qml Sources/Qml/Controllers/ExifGrid.qml Sources/Qml/Controllers/IptcGrid.qml Sources/Qml/Controllers/MetadataPopup.qml
        Sources/Qml/Controllers/SettingsPopup.qml Sources/Qml/Controllers/TiTabButton.qml Sources/Qml/Controllers/ToolBarBottom.qml Sources/Qml/Controllers/ToolBarMap.qml
        Sources/Qml/Controllers/ToolBarPrincipale.qml Sources/Qml/Controllers/ZoneCamera.qml Sources/Qml/Controllers/ZoneGeoloc.qml Sources/Qml/Controllers/ZonePhoto.qml
        Sources/Qml/Controllers/ZonePreview.qml Sources/Qml/Controllers/ZoneSuggestedTags.qml Sources/Qml/Controllers/ZoneSuggestion.qml Sources/Qml/Controllers/ZoneUserdata.qml
        Sources/Qml/Dialogs/AboutDialog.qml Sources/Qml/Dialogs/ApikeyDialog.qml Sources/Qml/Dialogs/CreditsDialog.qml Sources/Qml/Dialogs/RescanWarning.qml
        Sources/Qml/Dialogs/TiFolderDialog.qml Sources/Qml/Models/ModelFolderList.qml Sources/Qml/Vues/ExifGridForm.ui.qml Sources/Qml/Vues/IptcGridForm.ui.qml
        Sources/Qml/Vues/MetadataPopupForm.ui.qml Sources/Qml/Vues/SettingsPopupForm.ui.qml Sources/Qml/Vues/TiTabButtonForm.ui.qml Sources/Qml/Vues/ToolBarBottomForm.ui.qml
        Sources/Qml/Vues/ToolBarMapForm.ui.qml Sources/Qml/Vues/ToolBarPrincipaleForm.ui.qml Sources/Qml/Vues/ZoneCameraForm.ui.qml Sources/Qml/Vues/ZoneGeolocForm.ui.qml
        Sources/Qml/Vues/ZonePhotoForm.ui.qml
        Sources/Qml/Vues/ZonePreviewForm.ui.qml
        Sources/Qml/Vues/ZoneSuggestedTagsForm.ui.qml
        Sources/Qml/Vues/ZoneSuggestionForm.ui.qml
        Sources/Qml/Vues/ZoneUserdataForm.ui.qml
        RESOURCES Resources/tiPhotoLocator.qrc
        QML_FILES Sources/Qml/Javascript/Chips.js Sources/Qml/Javascript/Networking.js Sources/Qml/Javascript/TiUtilities.js
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
