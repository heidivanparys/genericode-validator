@echo off
rem Start with clearing the ERRORLEVEL back to 0, in case an error occurred during a previous execution of this batch file
rem See also https://ss64.com/nt/errorlevel.html
(call )

rem The only logical logical operator directly supported by IF is NOT, 
rem so do not combine all conditions in one expression by writing OR, see also https://ss64.com/nt/if.html
rem Do NOT use parentheses around the goto command, see also https://ss64.com/nt/goto.html
if "%~1" == "" goto displayUsageMessage
if "%~2" == "" goto displayUsageMessage
)


rem Check availability of external commands, see also https://www.robvanderwoude.com/autodownload.php
rem Use newer syntax for checking errorlevel, see also https://ss64.com/nt/if.html
(call Morgana 2>&1) | FIND /I "MorganaXProc-III" >NUL
if %ERRORLEVEL% EQU 1 goto displayMessageMorgana

setlocal
echo:
echo Arguments set:
echo   ^<input-path^>           %~1
echo   ^<output-directory^>     %~2
if "%~3" == "" (
	set debug_pipeline=false
) else (
	set debug_pipeline=%~3
)
echo   ^<debug^>                %debug_pipeline%
echo:

Morgana -config=local-scripts\morgana-config.xml ^
src\main\xml\xproc\validate-genericode-main.xpl ^
-option:input-path='%~1' ^
-option:output-directory='%~2' ^
-static:debug=%debug_pipeline%

echo Exit code: %ERRORLEVEL%

exit /B %ERRORLEVEL%
goto:eof

:displayUsageMessage
	echo:
	echo Usage: scripts\%~nx0 ^<input-path^> ^<output-directory^> [^<debug^>]
	echo:
	echo     input-path           one of the following: path to existing local directory containing genericode files; path to local genericode file; path to online genericode file
	echo     output-directory     path to local directory to store the validation reports in
	echo     debug                false ^(default^) or true
	echo:
goto:eof

:displayMessageMorgana
	echo Morgana was not found, please install it and try again.
	echo Directories where your operating system searches for executable files: %PATH%
goto:eof