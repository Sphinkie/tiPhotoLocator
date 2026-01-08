@echo ON
@echo --------------------------------------------------
@echo Run me in Qt Creator terminal.. "Run Environment"
@echo --------------------------------------------------

setlocal 
set "AppName=TiPhotoLocator"
set "SourceDir=.\build\Desktop_Qt_6_10_1_MSVC2022_64bit-Release"

set "TargetDir=.\Installeur\packages\sphinkie.%AppName%\data\"
REM set TargetDir = .\dist

@echo.
@echo --------------------------------------------------
@echo Copie des binaries externes (et creation target folder)
@echo --------------------------------------------------
xcopy .\Bin\*.exe %TargetDir%\Bin /I /Y
REM xcopy .\Data %TargetDir%\Data /S /I /Y

@echo.
@echo --------------------------------------------------
@echo Copie de l'executable %AppName%
@echo --------------------------------------------------
copy %SourceDir%\%AppName%.exe %TargetDir%

@echo.
@echo --------------------------------------------------
@echo Deploiment des librairies avec QML
@echo --------------------------------------------------
windeployqt --release --no-translations --qmldir .\Sources\Qml  %TargetDir%

@echo -------------------------------------------------
@echo Done

