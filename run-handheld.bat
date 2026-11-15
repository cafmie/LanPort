@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0"

rem Handheld / sub-PC: Python-free. Launch frozen LanPort.exe only.

set "EXE="
if exist "%~dp0LanPort.exe" set "EXE=%~dp0LanPort.exe"
if not defined EXE if exist "%~dp0dist\LanPort.exe" set "EXE=%~dp0dist\LanPort.exe"
if not defined EXE if exist "%~dp0dist\LanPort\LanPort.exe" set "EXE=%~dp0dist\LanPort\LanPort.exe"

if not defined EXE (
  echo [エラー] LanPort.exe が見つかりません。
  echo.
  echo ハンドヘルドでは Python のインストールは不要です。
  echo GitHub Releases / Actions の portable ZIP を展開し、
  echo この bat と同じフォルダに LanPort.exe を置いてください。
  echo.
  echo 例: https://github.com/cafmie/LanPort/releases
  echo     または Actions の windows-portable 成果物
  echo.
  pause
  exit /b 1
)

set "NAME=%~1"
if "%NAME%"=="" set "NAME=Ally"

echo LanPort をハンドヘルドとして起動します...
echo EXE: %EXE%
"%EXE%" --role handheld --name "%NAME%"
set "EC=%ERRORLEVEL%"
if not "%EC%"=="0" (
  echo.
  echo [エラー] 起動に失敗しました ^(exit %EC%^)。
  pause
)
exit /b %EC%
