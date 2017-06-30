:: run as administator

@echo off
cacls.exe "%SystemDrive%\System Volume Information" >nul 2>nul
if %errorlevel%==0 goto Admin
if exist "%temp%\getadmin.vbs" del /f /q "%temp%\getadmin.vbs"
echo Set RequestUAC = CreateObject^("Shell.Application"^)>"%temp%\getadmin.vbs"
echo RequestUAC.ShellExecute "%~s0","","","runas",1 >>"%temp%\getadmin.vbs"
echo WScript.Quit >>"%temp%\getadmin.vbs"
"%temp%\getadmin.vbs" /f
if exist "%temp%\getadmin.vbs" del /f /q "%temp%\getadmin.vbs"
exit

:Admin


if not exist %~dp0%docker_machine_shell.sh (
  echo can not find docker_machine_shell.sh
  pause
  exit
)

set EXISTS_FLAG=0 
echo %PATH%|find "Git">nul&&set EXISTS_FLAG=1

if "%EXISTS_FLAG%"=="1" (  
   start "" "%~dp0%docker_machine_shell.sh"
) else (  
  echo can not find git
  pause
  exit
) 








