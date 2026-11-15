@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0"

echo === LanPort setup (main PC) ===
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

echo [エラー] Python が見つかりません。
echo.
echo メインPCでは Python 3.10 以上が必要です。
echo https://www.python.org/downloads/ からインストールし、
echo 「Add python.exe to PATH」にチェックを入れてください。
echo.
echo ※ ハンドヘルド（サブ機）は Python 不要です。
echo    リリースの portable ZIP を展開し、run-handheld.bat を実行してください。
echo.
pause
exit /b 1

:have_python
%PY% -c "import sys; raise SystemExit(0 if sys.version_info >= (3, 10) else 1)" >nul 2>&1
if errorlevel 1 (
  echo [エラー] Python 3.10 以上が必要です。
  %PY% --version
  pause
  exit /b 1
)

if not exist ".venv\Scripts\python.exe" (
  echo [.venv] 作成中...
  %PY% -m venv .venv
  if errorlevel 1 (
    echo [エラー] 仮想環境の作成に失敗しました。
    pause
    exit /b 1
  )
) else (
  echo [.venv] 既存の仮想環境を使います。
)

echo [pip] ランタイム依存関係をインストール中...
".venv\Scripts\python.exe" -m pip install --upgrade pip
if errorlevel 1 (
  echo [エラー] pip の更新に失敗しました。
  pause
  exit /b 1
)

".venv\Scripts\python.exe" -m pip install -e .
if errorlevel 1 (
  echo [エラー] LanPort のインストールに失敗しました。
  echo ネットワークとファイアウォールを確認してください。
  pause
  exit /b 1
)

echo.
echo セットアップ完了。run-main.bat で起動できます。
echo.
exit /b 0
