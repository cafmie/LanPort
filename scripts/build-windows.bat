@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0.."

echo === Build LanPort Windows portable (PyInstaller) ===
echo This script must run on Windows with Python 3.10+.
echo.

where py >nul 2>&1
if %ERRORLEVEL%==0 (
  set "PY=py -3"
  goto :have_python
)
where python >nul 2>&1
if %ERRORLEVEL%==0 (
  set "PY=python"
  goto :have_python
)

echo [ERROR] Python not found on PATH. Install Python 3.10+ to build.
pause
exit /b 1

:have_python
if not exist ".venv-build\Scripts\python.exe" (
  echo Creating .venv-build ...
  %PY% -m venv .venv-build
  if errorlevel 1 exit /b 1
)

set "VPY=.venv-build\Scripts\python.exe"
"%VPY%" -m pip install --upgrade pip
"%VPY%" -m pip install -e ".[build]"
if errorlevel 1 exit /b 1

echo Running PyInstaller ...
"%VPY%" -m PyInstaller --noconfirm --clean lanport.spec
if errorlevel 1 exit /b 1

if not exist "dist\LanPort.exe" (
  echo [ERROR] dist\LanPort.exe was not produced.
  exit /b 1
)

echo.
echo OK: dist\LanPort.exe
echo Copy LanPort.exe next to run-handheld.bat for the portable ZIP.
echo.
exit /b 0
