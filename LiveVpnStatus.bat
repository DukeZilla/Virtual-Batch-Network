echo off
break off
title Live VPN Status
setlocal EnableExtensions EnableDelayedExpansion
::mode con: cols=53 lines=12
cls
goto main

:main
color 0a
rasdial | findstr /vilc:"Command Completed successfully"  > statuscache.txt
for /f "tokens=* usebackq" %%g in ( statuscache.txt ) do ( 
	set "str1=%%g" 
	if /I "!str1!" == "No connections" color c
)
echo.
echo 		0- - - - - - - - - 0
echo 		I Live VPN Status  I
echo 		0- - - - - - - - - 0
echo.
echo.
rasdial
echo.
echo Run VBN-Console.bat to connect / disconnect VPN.
echo.
del statuscache.txt
timeout 5 > nul
cls
goto main
