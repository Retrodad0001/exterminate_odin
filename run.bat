cls
odin version

set OUT_DIR=build\debug\win64


odin strip-semicolon exterminate 
odin test exterminate

if not exist %OUT_DIR% mkdir %OUT_DIR%

odin build exterminate -out:%OUT_DIR%\debug_version.exe -strict-style -vet -debug
IF %ERRORLEVEL% NEQ 0 exit /b 1

xcopy /y /e /i assets %OUT_DIR%\assets > nul
IF %ERRORLEVEL% NEQ 0 exit /b 1

echo Debug build created in %OUT_DIR%