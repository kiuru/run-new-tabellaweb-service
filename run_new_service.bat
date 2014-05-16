@echo off
echo #################################################################################
echo ##                                                                             ##
echo ##  Create new TabellaWEB service automatically                                ##
echo ##  Location: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TabellaWEB  ##
echo ##  Author: Niko Kiuru                                                         ##
echo ##  http://NikoKiuru.com                                                       ##
echo ##  Date: 2014-05-16                                                           ##
echo ##                                                                             ##
echo #################################################################################
echo.

PAUSE

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
REM ## Administrator permission request source: http://stackoverflow.com/a/10052222

REM ## Create new service to register

sc delete TabellaWEB
sc create TabellaWEB binPath= %CD%\srvany.exe start= auto
sc description TabellaWEB "Tabella WEB-palvelinohjelma"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TabellaWEB\Parameters" /v "Application" /d "%CD%\TABELLA.exe" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TabellaWEB\Parameters" /v "AppDirectory" /d "%CD%" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TabellaWEB\Parameters" /v "AppParameters" /d "/autostart" /f

echo.
echo #################################################
echo ##                                             ##
echo ##  New TabellaWEB service added succesfully!  ##
echo ##                                             ##
echo #################################################

PAUSE
