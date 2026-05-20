@echo off

REM --------------------------------------------------------------------
REM Suppression des entrées obsolètes
REM --------------------------------------------------------------------

lupdate -no-obsolete Sources/ -ts Languages/fre.ts Languages/eng.ts

REM --------------------------------------------------------------------
REM Extraire les nouvelles chaînes depuis les sources (QML + C++).
REM --------------------------------------------------------------------

rem lupdate Sources/ -ts Languages/fre.ts Languages/eng.ts

REM --------------------------------------------------------------------
REM Compiler les .ts en .qm (fait automatiquement par CMake au build).
REM --------------------------------------------------------------------

rem  lrelease Languages/fre.ts Languages/eng.ts

                                                                                                                                                                                                                                              
