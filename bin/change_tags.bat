
REM Test EXIF write
REM exiftool [*OPTIONS*] -*TAG*[+-<]=[*VALUE*]... *FILE*...

exiftool -preserve -overwrite_original -City="Bruxelles" -Country=Belgique -Creator="Herge" IMG_20230709_172117.jpg

pause
exit


REM Interresting options:
REM 
REM -preserve          Preserve file modification date and time
REM -extension "jpg"
REM -overwrite_original
REM -sort              Alphabetical order