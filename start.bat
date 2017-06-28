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

:: find git-bash and run docker_machine_shell.sh
@echo off
set "FileName=git-bash.exe"
echo finding git-bash...
set "git_bash_path=null"
for %%a in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
  if exist %%a:\ (
    for /f "delims=" %%b in ('where /r %%a: "%FileName%" 2^>nul') do (
      if /i "%%~nxb" equ "%FileName%" (
        set "git_bash_path=%%b"
        break
      )
    )
  )
)

if "%git_bash_path%"=="null" (
  echo can not find git-bash !
  pause
  exit
)

if not exist %~dp0%docker_machine_shell.sh (
  echo can not find docker_machine_shell.sh
  pause
  exit
)

start "%git_bash_path%" "%~dp0%docker_machine_shell.sh"
