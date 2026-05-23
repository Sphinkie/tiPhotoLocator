@echo OFF
@echo --------------------------------------------------
@echo Run me in Qt Creator terminal.. "Run Environment"
@echo --------------------------------------------------

setlocal 
set "AppName=TiPhotoLocator"
set "SourceDir=.\build\Desktop_Qt_6_11_1_llvm_mingw_64_bit-MinSizeRel"
set "TargetDir=.\Installeur\packages\sphinkie.%AppName%\data\"
REM set TargetDir = .\dist

@echo.
@echo --------------------------------------------------
@echo Copie des binaries externes (et creation target folder)
REM /I : suppose répertoire
@echo --------------------------------------------------
xcopy .\Bin\*.exe %TargetDir%\Bin /I /Y
REM xcopy .\Data %TargetDir%\Data /S /I /Y

@echo.
@echo --------------------------------------------------
@echo Copie de l'executable %AppName%
@echo --------------------------------------------------
xcopy %SourceDir%\%AppName%.exe %TargetDir% /Y

@echo ON
@echo.
@echo --------------------------------------------------
@echo Deploiment des librairies avec QML pour MINGV LLVM
@echo --------------------------------------------------
windeployqt --no-translations --qmldir .\Sources\Qml  %TargetDir%

@echo -------------------------------------------------
@echo Done

