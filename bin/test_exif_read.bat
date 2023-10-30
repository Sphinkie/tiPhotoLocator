
REM Test EXIF read
REM exiftool [*OPTIONS*] [-*TAG*...] [--*TAG*...] *FILE*...
	
exiftool -@ exiftool.config --printConv -veryShort -json "2023-Collioure.jpg" > 2023-Collioure.json
exiftool -@ exiftool.config --printConv -veryShort -X    "2023-Collioure.jpg" > 2023-Collioure.xml

pause
exiftool -@ exiftool.config --printConv -veryShort "2023-Collioure.jpg"

pause
exiftool -All --printConv -veryShort "2023-Collioure.jpg"

pause
exit

REM ">" will put all of the output from a command into a single file, 
REM "-w" and "-W" will create different output files for each file that exiftool scans by default. 
REM Files created with -w and -W can also be overwritten and appended to by using the +! and + operators respectively.

REM "exiftool(-a -u -g1 -w txt).exe" gives a drag-and-drop utility which generates sidecar ".txt"
	
REM Interresting options:

-veryShort ^
-dateFormat %%Y-%%m-%%d ^
-extension "jpg"
--struct ^
--printConv ^                    No print conversion
--duplicates ^
-fast[NUM]                       Increase speed when extracting metadata
-@ ARGFILE                       Read command-line arguments from file
-All                             List all metadata
-sort                            Alphabetical order