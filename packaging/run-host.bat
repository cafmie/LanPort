@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0"

rem Host / main PC launcher for installed or portable LanPort.exe (no Python).

set "EXE="
if exist "%~dp0LanPort.exe" set "EXE=%~dp0LanPort.exe"
if not defined EXE if exist "%~dp0dist\LanPort.exe" set "EXE=%~dp0dist\LanPort.exe"

if not defined EXE (
  echo [エラー] LanPort.exe が見つかりません。
  echo.
  echo ホスト用インストーラー / portable ZIP を展開し、
  echo この bat と同じフォルダに LanPort.exe を置いてください。
  echo.
  pause
  exit /b 1
)

set "NAME=%~1"
if "%NAME%"=="" set "NAME=Main PC"

echo LanPort をホスト（メインPC）として起動します...
echo EXE: %EXE%
"%EXE%" --role main --name "%NAME%"
set "EC=%ERRORLEVEL%"
if not "%EC%"=="0" (
  echo.
  echo [エラー] 起動に失敗しました ^(exit %EC%^)。
  pause
)
exit /b %EC%
