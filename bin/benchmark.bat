
REM 384 photos

@echo %time%

REM exiftool -@ exiftools.config "P:\2017\2017-08 Venise" >nul
REM exiftool -@ exiftools.config "P:\2017\2017-08 Venise"> 2017-08-venise.json
REM exiftool -@ exiftools.config "P:\2017\2017-08 Venise"> 2017-08-venise.xml

exiftool -@ exiftools.config ^
-veryShort ^
-dateFormat %%Y-%%m-%%d ^
-json ^
"E:\TiPhotos"

REM Enlever les namespaces

@echo %time%

pause

exit

REM > will put all of the output from a command into a single file, 
REM -w and -W will create different output files for each file that exiftool scans by default. 
REM Files created with -w and -W can also be overwritten and appended to by using the +! and + operators respectively.

--struct ^
-veryShort ^
--printConv ^
--duplicates ^
-xmlformat -escape(XML) ^

REM json flow = 21 seconds
REM json file = 21 seconds
REM xmlformat  flow = 24 seconds
REM xmlformat  file = 19 seconds
REM txt        file = 19 seconds



REM The formatting options -b, -D, -H, -l, -s, -sep, -struct and -t may be used in combination with -X to affect the output, 
REM but note that the tag ID (-D, -H and -t), binary data (-b) and structured output (-struct) options are not effective for the short output (-s). 
REM
REM Another restriction of -s is that only one tag with a given group and name may appear in the output. 
REM Note that the tag ID options (-D, -H and -t) will produce non-standard RDF/XML unless the -l option is also used.
REM
REM -b          (-binary)            binary output : inutile ici
REM -D          (-decimal)           Show tag ID numbers in decimal
REM -H          (-hex)               Show tag ID numbers in hexadecimal 
REM -E,-ex,-ec  (-escape(HTML|XML|C))Escape tag values for HTML, XML or C
REM -s2         very short (no space in tag names)
REM -sep STR    (-separator)         Set separator string for list items
REM -struct                          Enable output of structured information
REM -t          (-tab)               Output in tab-delimited list format
REM -d FMT      (-dateFormat)        Set format for date/time values

REM 
REM https://adamtheautomator.com/exiftool/
