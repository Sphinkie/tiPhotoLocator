@ECHO -------------------------
@ECHO SETUP generation
@ECHO -------------------------
set "AppName=TiPhotoLocator"

REM del .\packages\sphinkie.%AppName%\data\vc_redist.x64.exe
C:\Qt\Tools\QtInstallerFramework\4.10\bin\binarycreator --offline-only -c config/config.xml -p packages %AppName%Setup


pause
