echo off
break off
title VPN Console
PUSHD "%CD%"
CD /D "%~dp0"
set back=%cd%
cls

:checkadmin
echo.
echo Checking admin privelages...
net session >nul 2>&1
if %errorlevel%==0 (
color 0a
echo.
echo Success.
timeout 1 > nul
cls
goto status
) ELSE (
color c
echo.
echo Error: Current Admin privelages inadequate.
echo.
echo Run this batch file as administrator.
echo.
pause
exit
)

:status
color 7
echo.
echo.
echo ----------------
echo.
echo VPN Status
echo.
rasdial
echo.
pause

:main
cd %back%
cls
echo.
echo.
echo O=-=-=VBN-Console=-=-=O
echo.
echo.
echo Main menu
echo.
echo --------------
echo.
echo 1. Start VPN
echo.
echo 2. Configure VPN
echo.
echo 3. Check Configurations
echo.
echo 4. VPN Status
echo.
echo 5. IP Address
echo.
echo 6. Disconnect
echo.
echo 7. Exit
echo.
echo.
set /p mchoice=Select Number: 
if %mchoice%==1 goto load
if %mchoice%==2 goto configure
if %mchoice%==3 goto check
if %mchoice%==4 goto status
if %mchoice%==5 goto ip2
if %mchoice%==6 goto disconnect
if %mchoice%==7 cls & exit /b
goto selecterror

:selecterror
echo.
echo.
echo Error: Invalid selection.
echo.
timeout 5 > nul
goto main

:check
echo.
echo.
echo - %mchoice% was selected -
echo.
echo -------------------------
echo.
echo Configuration file check:
echo.
type loadvpn.cfg >nul 2>&1
if %errorlevel%==0 (
for /f "tokens=1-9 delims= " %%g in ( loadvpn.cfg ) do ( echo %%h %%i %%j %%k )
echo.
echo.
pause
goto main
) ELSE (
echo.
echo ERROR:
echo.
echo No configuration file detected.
echo.
pause
goto main
)

:load
echo.
echo.
echo - %mchoice% was selected -
echo.
echo ---------------------------
echo.
echo Loading configuration...
echo.
type loadvpn.cfg > nul
if %errorlevel%==0 (
timeout 1 > nul
) ELSE (
echo.
echo Error: No configuration file was found.
echo.
pause
goto main
)
for /f "delims=" %%a in ('type loadvpn.cfg^|findstr /bic:"set "') do %%a
echo Loaded.
goto vpn

:configure
echo.
echo.
echo - %mchoice% was selected -
echo.
echo ---------------------------
echo.
echo.
echo Configuration:
echo.
echo Record the VPN information below.
echo.
echo.
set /p website=Website or Server: 
echo - %website% -
echo.
set /p connection=Connection Name: 
echo - %connection% -
echo.
set /p user=Username: 
echo - %user% -
echo.
set /p pass=Password: 
echo - %pass% -
echo.

:save
echo.
set /p mchoice=Do you wish to save these configuration settings? (Y/N): 
if %mchoice%==y goto saveconfig
if %mchoice%==n goto main
if %mchoice%==Y goto saveconfig
if %mchoice%==N goto main
goto saveerror

:saveerror
echo.
echo.
echo Error: Invalid selection.
echo.
timeout 5 > nul
cls
goto save

:saveconfig
echo.
echo.
echo --------------------------------------------------
echo.
echo Saving configuration settings into "loadvpn.cfg"...
echo.
timeout 3 > nul
::------------------------------------0
( echo set website=%website%
  echo set connection=%connection%
  echo set user=%user%
  echo set pass=%pass% ) > loadvpn.txt
::------------------------------------0
del loadvpn.cfg /q >nul 2>&1
ren loadvpn.txt loadvpn.cfg
if %errorlevel%==0 (
echo.
echo Configuration settings saved.
echo.
timeout 4 > nul
) ELSE (
echo.
echo An error has occured when saving settings...
echo.
echo Proceeding with the batch job...
echo.
timeout 4 > nul
)
goto main

:vpn
echo.
echo.
echo Writing phonebook...
echo.
echo Implementing configurations...
echo.
cd \
echo %SYSTEMROOT%\System32\ras
cd %systemroot%\system32\ras
echo.
echo VPN Information:
echo.
::--------------------------------------0
( echo [%connection%]
  echo MEDIA=rastapi
  echo Port=VPN2-0
  echo Device=WAN Miniport (IKEv2^)
  echo DEVICE=vpn
  echo PhoneNumber=%website%) > temp.txt
::--------------------------------------0
type temp.txt
type temp.txt >> rasphone.pbk
del temp.txt /q
echo.
echo Connecting to VPN...
echo.
echo rasdial "%connection%" %user% %pass%
rasdial "%connection%" %user% %pass%
if %errorlevel% NEQ 0 (
echo.
echo Attempts to connect to VPN were unsuccessful.
echo.
pause
goto main 
) ELSE (
echo.
goto ip1
)

:ip1
echo.
echo.
echo Displaying IP address...
echo.
timeout 3 > nul
call TelnetMyIP.bat
title VPN Console
timeout 10
cls
echo.
echo Initiating live VPN status...
echo.
timeout 2 > nul
cls
call LiveVpnStatus.bat
exit /b

:ip2
echo.
echo.
echo - %mchoice% was selected -
echo.
echo ---------------------------
echo.
echo Displaying IP address...
echo.
timeout 3 > nul
call TelnetMyIP.bat
title VPN Console
pause
goto main

:disconnect
echo.
echo.
echo - %mchoice% was selected -
echo.
echo ---------------------------
echo.
echo Disconnecting VPN...
echo.
echo rasdial /DISCONNECT
echo.
rasdial /DISCONNECT
echo.
cd \
cd %SYSTEMROOT%\system32\ras
del rasphone.pbk /q
echo.
timeout 3 > nul
goto main
