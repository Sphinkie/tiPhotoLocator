
REM Test EXIF write
REM exiftool [*OPTIONS*] -*TAG*[+-<]=[*VALUE*]... *FILE*...

exiftool -preserve -extension "jpg" -City="Collioure" -Country=France -Artist='David' 2023-Collioure.jpg

pause
exit


REM Interresting options:

-preserve          Preserve file modification date/time
-extension "jpg"
-overwrite_original