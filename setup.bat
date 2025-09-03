@echo off
setlocal

set "REPO_URL=https://github.com/AnubhavChaturvedi-GitHub/Speech-to-Text-with-Python-Google-Web-Speech-API.git"
set "TARGET_DIR=Speech-to-Text-with-Python-Google-Web-Speech-API"

echo ========================================================
echo [INFO] Step 1: Checking Git...
where git >nul 2>nul
if %ERRORLEVEL% neq 0 (
  echo [WARN] Git not found. Trying to install via winget...
  winget install --id Git.Git -e --source winget
) else (
  git --version
  echo [ OK ] Git is installed.
)

echo ========================================================
echo [INFO] Step 2: Checking Python...
set "PYTHON="
where python >nul 2>nul && set "PYTHON=python"
if not defined PYTHON (
  where py >nul 2>nul && set "PYTHON=py -3"
)

if not defined PYTHON (
  echo [ERR ] Python not found. Opening Python downloads page...
  start "" "https://www.python.org/downloads/"
  goto :END
) else (
  %PYTHON% --version
  echo [ OK ] Python is installed.
)

echo ========================================================
echo [INFO] Step 3: Cloning or updating repository...
if exist "%TARGET_DIR%\.git" (
  echo [INFO] Repo already exists. Pulling latest changes...
  pushd "%TARGET_DIR%"
  git pull --ff-only
) else (
  echo [INFO] Cloning repo into "%cd%\%TARGET_DIR%"...
  git clone "%REPO_URL%" "%TARGET_DIR%"
  if errorlevel 1 (
    echo [ERR ] Clone failed.
    goto :END
  )
  pushd "%TARGET_DIR%"
)

echo ========================================================
echo [INFO] Verifying main.py presence...
if exist main.py (
  echo [ OK ] main.py found.
) else (
  echo [ERR ] main.py not found in "%cd%".
  echo [INFO] Contents of current directory:
  dir /b
  popd
  goto :END
)

echo ========================================================
echo [INFO] Step 4: Setting up virtual environment...
if not exist venv (
  echo [INFO] Creating venv...
  %PYTHON% -m venv venv
)
call venv\Scripts\activate.bat
echo [ OK ] Virtual environment activated.

echo ========================================================
echo [INFO] Step 5: Installing Python dependencies...
set "REQ_FILE="
if exist requirements.txt set "REQ_FILE=requirements.txt"
if not defined REQ_FILE if exist requirement.txt set "REQ_FILE=requirement.txt"

if defined REQ_FILE (
  echo [INFO] Found %REQ_FILE%
  %PYTHON% -m pip install --upgrade pip setuptools wheel
  %PYTHON% -m pip install -r %REQ_FILE%
) else (
  echo [WARN] No requirements.txt found, skipping dependency install.
)

echo ========================================================
echo [INFO] Step 6: Running main.py...
%PYTHON% main.py

popd

echo ========================================================
echo [DONE] Setup and run finished.
pause
:END
endlocal
