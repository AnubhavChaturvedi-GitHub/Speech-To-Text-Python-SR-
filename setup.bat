@echo off
setlocal ENABLEDELAYEDEXPANSION

REM setup_speech_to_text.bat
REM Repo: https://github.com/AnubhavChaturvedi-GitHub/Speech-to-Text-with-Python-Google-Web-Speech-API.git

set "REPO_URL=https://github.com/AnubhavChaturvedi-GitHub/Speech-to-Text-with-Python-Google-Web-Speech-API.git"
set "TARGET_DIR=Speech-to-Text-with-Python-Google-Web-Speech-API"

echo [INFO] Checking for Git...
where git >nul 2>nul
if %ERRORLEVEL% neq 0 (
  echo [WARN] Git is not installed.
  REM Try winget if available; otherwise open Git website
  where winget >nul 2>nul
  if %ERRORLEVEL% equ 0 (
    echo [INFO] Attempting to install Git via winget (you may be prompted)...
    winget install --id Git.Git -e --source winget
    if %ERRORLEVEL% neq 0 (
      echo [WARN] winget install failed or was canceled.
      goto :GIT_WEBSITE
    )
  ) else (
    :GIT_WEBSITE
    echo [INFO] Opening Git downloads page. Please install Git, then re-run this script.
    start "" "https://git-scm.com/downloads"
    goto :END
  )
) else (
  echo [ OK ] git is already initialized and installed.
)

REM Clone or update
if exist "%TARGET_DIR%\.git" (
  echo [INFO] Repo directory exists. Pulling latest changes...
  pushd "%TARGET_DIR%"
  git pull --ff-only
  if %ERRORLEVEL% neq 0 (
    echo [ERR ] git pull failed.
    popd
    goto :END
  )
  popd
) else (
  echo [INFO] Cloning repository...
  git clone "%REPO_URL%" "%TARGET_DIR%"
  if %ERRORLEVEL% neq 0 (
    echo [ERR ] git clone failed.
    goto :END
  )
)

REM Check Python
echo [INFO] Checking for Python...
where python >nul 2>nul
if %ERRORLEVEL% neq 0 (
  where py >nul 2>nul
  if %ERRORLEVEL% neq 0 (
    echo [WARN] Python is not installed.
    echo        Opening the official Python downloads page. Please install Python 3 (check "Add Python to PATH") and re-run this script.
    start "" "https://www.python.org/downloads/"
    goto :END
  ) else (
    set "PY=py -3"
  )
) else (
  set "PY=python"
)

REM Install requirements if present
pushd "%TARGET_DIR%"
set "REQ_FILE="
for %%F in (requirements.txt requirement.txt) do (
  if exist "%%F" (
    set "REQ_FILE=%%F"
    goto :HAVE_REQ
  )
)
REM Also search one level down if not found at root
for /r "." %%F in (requirements.txt requirement.txt) do (
  if not defined REQ_FILE (
    set "REQ_FILE=%%F"
  )
)

:HAVE_REQ
if defined REQ_FILE (
  echo [INFO] Found requirements file: %REQ_FILE%
  REM Ensure pip is available and upgrade base tooling
  %PY% -m pip --version >nul 2>nul
  if %ERRORLEVEL% neq 0 (
    echo [WARN] pip not found. Trying to bootstrap with ensurepip...
    %PY% -m ensurepip --upgrade
  )
  echo [INFO] Upgrading pip/setuptools/wheel...
  %PY% -m pip install --upgrade pip setuptools wheel
  echo [INFO] Installing Python requirements...
  %PY% -m pip install -r "%REQ_FILE%"
  if %ERRORLEVEL% neq 0 (
    echo [ERR ] Failed installing requirements.
    popd
    goto :END
  )
) else (
  echo [WARN] No requirements.txt/requirement.txt found. Skipping Python dependency install.
)

popd

echo [ OK ] Setup complete.
:END
endlocal
