@echo off
rem Use same environment variable as XSpec for convenience
rem See https://github.com/xspec/xspec/wiki/Environment-Variables
set TEST_DIR=target
echo This script runs the tests written in XProc in directory src\test\xml\xproc
echo If no errors are displayed, the test passed.
echo If errors are displayed, inspect the error and check the log files in directory %TEST_DIR%.
echo If debugging is needed, change -static:debug=false to -static:debug=true.
echo:
for %%G in (src\test\xml\xproc\*.xpl) do (
	echo Run test in %%G
    call Morgana -config=local-scripts\morgana-config.xml "%%G" -indent-errors -silent -messages="%TEST_DIR%\%%~nG-messages.log" -static:debug=false
    echo:
)