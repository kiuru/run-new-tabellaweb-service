@echo off
REM # Define service name
set ServiceName=TabellaWEB

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
	echo Permission denied! Administrators privileges required. %ServiceName%
	PAUSE
	exit /B
)
:--------------------------------------
REM ## Administrator permission request source: http://stackoverflow.com/a/10052222

REM ## Create new service to register
sc delete %ServiceName%
sc create %ServiceName% binPath= %CD%\srvany.exe start= auto
sc description %ServiceName% "%ServiceName% -palvelinohjelma"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\%ServiceName%\Parameters" /v "Application" /d "%CD%\TABELLA.exe" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\%ServiceName%\Parameters" /v "AppDirectory" /d "%CD%" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\%ServiceName%\Parameters" /v "AppParameters" /d "/autostart" /f

echo.
echo New Tabella WEB service added succesfully!
PAUSE
