@echo off

rem Autor:        LetsBash.de
rem Date:         06.01.2021

rem Warranty:     This script comes without any warranty and in the state as it is.

rem Installation: You basicly need the backups of your gtfo game folders in your steam
rem               "steamapps\common" folder named like "GTFO + Number of the rundown". 
rem
rem               For Example: GTFO1 for Rundown 1, GTFO2 for Rundown 2, ...and so on
rem                            ...up to the latest rundown named GTFO without a number
rem
rem               Again: If you have all Rundowns then you should have this Game folders
rem               in your "steamapps\common" folder: GTFO, GTFO1, GTFO2, GTFO3, GTFO4 and GTFO5in your
rem
rem               After you have placed your rundown folders in your your "steamapps\common" folder
rem               you have to define below the path to your "steamapps\common" folder.

rem How to use:   1. Launch this scriptfile and leave the window open. 
rem                  (Window should say run game by steam)
rem               2. Launch the game by steam
rem               3. Play your rundown
rem               4. Exit GTFO as usual and let the window of this script still open
rem               5. The script detects automaticly that you closed the window and will 
rem                  cleanup any folder renamings

rem ** Edit this line and set the path to your "steamapps\common" directory **
set "steamcommon=D:\SteamLibrary\steamapps\common"

:main
echo.
echo Bashys GTFO Rundown Switcher by LetsBash.de
echo -------------------------------------------
echo.
set "myappdata=%userprofile%\appdata\LocalLow\10 Chambers Collective"

:CheckCleanShutdown
if exist "%steamcommon%\GTFOx" goto RepairNeeded
goto RundownSelection

:RepairNeeded
echo EN Warning: Unclean Shutdown detected... try to recover folderstructure!
echo DE Warnung: Script wurde nicht sauber beendet... versuche Ordner korrekt zu benennen!
echo.
if exist "%steamcommon%\GTFO\rundownbackupid.cmd" call "%steamcommon%\GTFO\rundownbackupid.cmd"
if not exist "%steamcommon%\GTFO\rundownbackupid.cmd" goto RepairFailed
ren "%steamcommon%\GTFO" "GTFO%rundownbackupid%" 1>nul 2>nul
ren "%steamcommon%\GTFOx" "GTFO" 1>nul 2>nul
ren "%myappdata%\GTFO" "GTFO%rundownbackupid%" 1>nul 2>nul
ren "%myappdata%\GTFOx" "GTFO" 1>nul 2>nul
goto RundownSelection

:RepairFailed
echo EN Error:  Repair not possible - not enough informations avalible
echo DE Fehler: Reperatur nicht moeglich - Zu wenig Informationen verfuegbar
echo.
goto end

:RundownSelection
echo EN Select:  Select the rundown you want to play (do not type in the current rundown)
echo DE Auswahl: Waehre den Rundown, den du spielen moechtest (alle ausser dem aktuellen Rundown)
CHOICE /C 123456789 /N /M "Rundown:"
set "rundown=%ERRORLEVEL%"
echo.
if not exist "%steamcommon%\GTFO%rundown%" goto RundownNotPresent
goto RundownPrepare

:RundownNotPresent
echo EN Error:  Folder GTFO%rundown% is not avalible in "steamapps"
echo DE Fehler: Ordner GTFO%rundown% ist nicht in "steamapps" verfuegbar
echo Path: %steamcommon%\GTFO%rundown%
timeout /t 4 1>nul 2>nul
echo.
goto RundownSelection

:RundownPrepare
echo EN Action: Renaming Gamefolders and Createing Backup ID
echo DE Aktion: Ordner werden umbenannt und Sicherungs-ID wird erstellt
echo.
echo set "rundownbackupid=%rundown%">"%steamcommon%\GTFO%rundown%\rundownbackupid.cmd"
ren "%myappdata%\GTFO" "GTFOx" 1>nul 2>nul
if not exist "%myappdata%\GTFOx" goto RenameError
ren "%myappdata%\GTFO%rundown%" "GTFO" 1>nul 2>nul
ren "%steamcommon%\GTFO" "GTFOx" 1>nul 2>nul
if not exist "%steamcommon%\GTFOx" goto RenameError
ren "%steamcommon%\GTFO%rundown%" "GTFO" 1>nul 2>nul

:RundownReady
echo EN Success: Start GTFO by Steam as usual
echo DE Erfolg:  Starte GTFO ueber Steam wie gewoehnlich
echo.

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

:BacktoOrigin
echo EN Action: Renaming Gamefolders back to origin
echo DE Aktion: Ordner werden auf ursprung umbenannt
echo.
ren "%myappdata%\GTFO" "GTFO%rundown%"
ren "%myappdata%\GTFOx" "GTFO"
ren "%steamcommon%\GTFO" "GTFO%rundown%"
ren "%steamcommon%\GTFOx" "GTFO"
goto end

:RenameError
echo EN Error:  Skript can not rename folders - Please logoff and logon
echo DE Fehler: Das Skript kann die Ornder nicht umbennen - Bitte abmelden und wieder anmelden.
echo.

:end
timeout /t 15
