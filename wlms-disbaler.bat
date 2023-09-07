@echo off

SET mypath=%~dp0
echo %mypath:~0,-1%
pushd %~dp0
echo\
REM popd

cls
echo *****************************
echo *** WINDOWS WLMS DISABLER ***
echo ***    (c) 2023 suuhm     ***
echo *****************************
echo\

REM Check for system user:
whoami | find "system" >nul

if %errorlevel% == 1 (
   REM -i -d for interactive new window
   echo * Become System user by Psexec.
   .\PsExec.exe  -accepteula -nobanner -s cmd /k "call %~dpnx0"
) else (
   whoami
   echo\ 
   echo * ^(Deleting^) Deactivating WLMS service.
   REM sc delete wlms 
   sc config "WLMS" start=disabled

   echo\
   echo * Adding Registry Values.
   reg add HKLM\SYSTEM\CurrentControlSet\Services\WLMS /v Start /t REG_DWORD /d 4 /f
   exit /B
)

echo\
echo * Done, Press some key to exit now.
pause>nul
