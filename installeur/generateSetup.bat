@ECHO OFF
@ECHO -------------------------
@ECHO SETUP generation
@ECHO -------------------------
setlocal enabledelayedexpansion

set "AppName=TiPhotoLocator"

REM --- Configuration de la signature Authenticode ---
set "CertFile=%~dp0sphinkie.pfx"
set "CertPass="
set "TimestampUrl=http://timestamp.digicert.com"
REM Surcharge par le fichier local (non versionné) si present
if exist "%~dp0sign.local.bat" call "%~dp0sign.local.bat"

REM Recherche de signtool.exe dans le PATH puis dans le Windows SDK
for /f "delims=" %%i in ('where signtool 2^>nul') do set "SignTool=%%i"
if not defined SignTool (
	set "SignTool=C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\x64\signtool.exe"
	if not exist "!SignTool!" set "SignTool=C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\signtool.exe"
    if not exist "!SignTool!" set "SignTool="
)

REM --- Generation de l'installeur ---
@ECHO.
@ECHO -------------------------
@ECHO QT Binary Creator
@ECHO -------------------------
REM del .\packages\sphinkie.%AppName%\data\vc_redist.x64.exe
C:\Qt\Tools\QtInstallerFramework\4.11\bin\binarycreator --offline-only -c config/config.xml -p packages %AppName%Setup

if %ERRORLEVEL% NEQ 0 (
    @ECHO ERREUR : binarycreator a echoue.
    pause
    exit /b 1
)

timeout /t 3 /nobreak >nul

REM --- Signature de l'installeur ---
@ECHO.
@ECHO -------------------------
@ECHO Signature Authenticode
@ECHO -------------------------
if not defined SignTool (
    @ECHO ATTENTION : signtool.exe non trouve. Installez le Windows SDK.
    @ECHO Signature ignoree.
    goto end
)
if not exist "%CertFile%" (
    @ECHO ATTENTION : Certificat introuvable : %CertFile%
    @ECHO Signature ignoree.
    goto end
)

"%SignTool%" sign /f "%CertFile%" /p "%CertPass%" /fd SHA256 /tr "%TimestampUrl%" /td SHA256 %AppName%Setup.exe
if %ERRORLEVEL%==0 (
    @ECHO Signature OK.
) else (
    @ECHO ATTENTION : La signature a echoue ^(code %ERRORLEVEL%^).
)

:end
pause
