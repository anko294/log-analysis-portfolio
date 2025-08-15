@echo off
REM ===== Windows用 実行スクリプト（修正版：pipを確実にvenvで実行） =====
SETLOCAL ENABLEDELAYEDEXPANSION

REM プロジェクトルートへ移動
cd /d %~dp0..
echo [INFO] Current directory: %CD%

REM GUI無しで描画
set MPLBACKEND=Agg
set MPLCONFIGDIR=.mplconfig
if not exist ".mplconfig" mkdir .mplconfig
set PYTHONUNBUFFERED=1

REM 1) venvがなければ作成
IF NOT EXIST ".venv" (
    echo [INFO] Creating virtual environment...
    python -m venv .venv
    if errorlevel 1 goto :err
)

REM 2) venvのpythonパスを決定して有効化
set VENV_PY="%CD%\.venv\Scripts\python.exe"
call .venv\Scripts\activate
if errorlevel 1 goto :err
echo [INFO] Using Python: %VENV_PY%

REM 3) requirements.txtが無ければ作成（最小セット）
IF NOT EXIST "requirements.txt" (
    echo pandas>requirements.txt
    echo matplotlib>>requirements.txt
)

REM 4) 依存インストール（必ず venv の python -m pip を使う）
echo [INFO] Installing requirements via venv pip...
%VENV_PY% -m pip install --upgrade pip setuptools wheel
if errorlevel 1 goto :err
%VENV_PY% -m pip install -r requirements.txt
if errorlevel 1 goto :err
echo [INFO] Installed packages:
%VENV_PY% -m pip list

REM 5) 実行（各ステップでログを出す）
set SRC=data\log_sample.csv

echo [INFO] Step 1/4: read_csv.py
%VENV_PY% -u src\read_csv.py %SRC%
if errorlevel 1 goto :err

echo [INFO] Step 2/4: filter_error.py
%VENV_PY% -u src\filter_error.py %SRC%
if errorlevel 1 goto :err

echo [INFO] Step 3/4: daily_plot.py
%VENV_PY% -u src\daily_plot.py %SRC%
if errorlevel 1 goto :err

echo [INFO] Step 4/4: level_timeseries.py
%VENV_PY% -u src\level_timeseries.py %SRC%
if errorlevel 1 goto :err

echo [DONE] Success. See output\ for results.
pause
exit /b 0

:err
echo [ERROR] Something failed. ExitCode=%ERRORLEVEL%
echo Tips:
echo  - Ensure internet access for pip.
echo  - Corporate proxy? set HTTPS_PROXY / HTTP_PROXY env first.
echo  - If plotting hangs, first run may build a font cache (10-60s).
pause
exit /b 1
