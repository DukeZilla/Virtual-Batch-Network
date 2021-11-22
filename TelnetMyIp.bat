echo off
break off
title WAN IP ADDRESS
PUSHD "%CD%"
CD /D "%~dp0"
set back=%cd%
cd %back%
cls
goto check

:check
telnet /?
if %errorlevel%==0 (
cls
goto main
) ELSE (
cls
goto error
)

:error
echo.
echo Telnet not installed.
echo.
echo Do you wish to install Telnet?
echo.
echo.
set /p mchoice=Type (Y/N): 
echo.
if %mchoice%==Y goto install
if %mchoice%==N exit
if %mchoice%==y goto install
if %mchoice%==n exit
cls
goto invalid

:invalid
echo.
echo.
echo Error: Invalid selection.
echo.
timeout 5
cls
goto error

:install
cls
timeout 1 > nul
pkgmgr /iu:"TelnetClient"
echo.
echo Installed.
taskkill /im telnet.exe -f >nul 2>&1

:main
cls
::-------------------------------------------------------0
( echo set shell = wscript.createobject("wscript.shell"^)
  echo do
  echo wscript.sleep 10000
  echo shell.run "taskkill /im telnet.exe -f", 0
  echo wscript.quit
  echo loop ) > KillTelnet.vbs
::-------------------------------------------------------0
start /min KillTelnet.vbs
timeout 1 > nul
del KillTelnet.vbs
telnet telnetmyip.com 80
exit /b
