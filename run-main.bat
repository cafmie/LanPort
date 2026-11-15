@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0"

if not exist ".venv\Scripts\python.exe" (
  echo 初回セットアップを実行します...
  call "%~dp0setup.bat"
  if errorlevel 1 exit /b 1
)

set "NAME=%~1"
if "%NAME%"=="" set "NAME=Main PC"

echo LanPort をメインPCとして起動します...
".venv\Scripts\python.exe" -m pc_transfer --role main --name "%NAME%"
set "EC=%ERRORLEVEL%"
if not "%EC%"=="0" (
  echo.
  echo [エラー] 起動に失敗しました ^(exit %EC%^)。
  pause
)
exit /b %EC%
