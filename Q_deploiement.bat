@echo ON
@echo --------------------------------------------------
@echo Run me in Qt Creator terminal.. "Run Environment"
@echo --------------------------------------------------

setlocal 
set "AppName=TiPhotoLocator"
REM set "SourceDir=.\build\Desktop_Qt_6_10_1_MSVC2022_64bit-Release"
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
REM copy .\build\Desktop_Qt_6_9_0_MSVC2022_64bit-Release\mealiespoon.exe .\Dist
REM copy .\build\Desktop_Qt_6_9_0_llvm_mingw_64_bit-Release\mealiespoon.exe .\Dist

copy %SourceDir%\%AppName%.exe %TargetDir%

@echo.
@echo --------------------------------------------------
@echo Deploiment des librairies avec QML
@echo --------------------------------------------------
windeployqt --release --no-translations --qmldir .\Sources\Qml  %TargetDir%

REM @echo 2: Deploiment des librairies pour MINGV LLVM
REM windeployqt --no-translations .\dist



@echo.
@echo -------------------------------------------------
@echo Copie des DLL manquantes pour MinGW (bug winDeployQt)
@echo -------------------------------------------------
REM copy "C:\Qt\6.9.0\llvm-mingw_64\bin\libc++.dll"    .\Dist
REM copy "C:\Qt\6.9.0\llvm-mingw_64\bin\libunwind.dll" .\Dist

@echo -------------------------------------------------
@echo Done

