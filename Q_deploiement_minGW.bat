@echo ON
@echo --------------------------------------------------
@echo Run me in Qt Creator terminal.. "Run Environment"
@echo --------------------------------------------------

setlocal 
set "AppName=TiPhotoLocator"
set "SourceDir=.\build\Desktop_Qt_6_10_1_llvm_mingw_64_bit-Release"

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
@echo Deploiment des librairies avec QML pour MINGV LLVM
@echo --------------------------------------------------
windeployqt --no-translations  %TargetDir%

REM --qmldir .\Sources\Qml


@echo.
@echo -------------------------------------------------
@echo Copie des DLL manquantes pour MinGW (bug winDeployQt)
@echo -------------------------------------------------
REM copy "C:\Qt\6.10.1\llvm-mingw_64\bin\libc++.dll"    .\Dist
REM copy "C:\Qt\6.10.1\llvm-mingw_64\bin\libunwind.dll" .\Dist

@echo -------------------------------------------------
@echo Done

