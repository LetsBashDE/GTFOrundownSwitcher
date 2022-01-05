@echo off
rem ///////////////////////////////////////////////////////
rem //  GTFO Launcher 1.0
rem //  Autor: LetsBash.de
rem //  05.01.2022
rem ///////////////////////////////////////////////////////

rem ///////////////////////////////////////////////////////
rem // Things you have to audjust based on your PC
rem // Dinge die du für deinen PC ändern solltest
rem ///////////////////////////////////////////////////////

rem // Wo sind deine Steam Spiele zu finden - einfach "D:\SteamLibrary\steamapps\common" ersetzten
set "steamappsdir=D:\SteamLibrary\steamapps\common"

rem // Welche rundowns stehen zur verfügung - außer dem Aktuellen
set "rundowns=12345"

rem ///////////////////////////////////////////////////////
rem // Do not change below
rem // Ab hier nichts mehr ändern
rem ///////////////////////////////////////////////////////

rem // Define your settings folder for GTFO (defined by the game)
set "gtfoappdata=%userprofile%\appdata\LocalLow\10 Chambers Collective"

rem // Get the rundown from user
CHOICE /C %rundowns% /M "Welchen Rundown moechtest du Spielen?"
set "rundown=%ERRORLEVEL%"

rem // Check if rundown is present
if not exist "%steamappsdir%\GTFO%rundown%" goto rundownerror

rem // Rename Settingsfolder
ren "%gtfoappdata%\GTFO" "GTFOx"
if exist "%gtfoappdata%\GTFO%rundown%" ren "%gtfoappdata%\GTFO%rundown%" "GTFO"

rem // Rename Gamefolder
ren "%steamappsdir%\GTFO" "GTFOx"
ren "%steamappsdir%\GTFO%rundown%" "GTFO"

rem // Inform the user to run GTFO by steam as usual
echo Done! You can start GTFO as usual by stream.

rem // Wait for game
:wait
timeout /t 5 1> nul 2>nul
tasklist /FI "IMAGENAME eq GTFO.exe" | find /i "GTFO.exe" 1>nul 2>nul
if %ERRORLEVEL% GEQ 1 goto wait
echo DE Aktion: Spiel gefunden
echo EN Action: Game found
echo.
goto scan

:scan
timeout /t 10 1> nul 2>nul
tasklist /FI "IMAGENAME eq GTFO.exe" | find /i "GTFO.exe" 1>nul 2>nul
if %ERRORLEVEL% LSS 1 goto scan

rem // Rename Settingsfolder back to origin
ren "%gtfoappdata%\GTFO" "GTFO%rundown%"
ren "%gtfoappdata%\GTFOx" "GTFO"

rem // Rename Gamefolder back to origin
ren "%steamappsdir%\GTFO" "GTFO%rundown%"
ren "%steamappsdir%\GTFOx" "GTFO"

rem // End of execution
goto end

:rundownerror
echo ERROR: Rundown does not exist

:end
timeout /t 15



