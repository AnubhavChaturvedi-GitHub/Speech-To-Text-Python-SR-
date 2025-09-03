#!/usr/bin/env bash
# setup_speech_to_text.sh
# Clones the repo, ensures git, installs Python deps from requirements.txt
# Repo: https://github.com/AnubhavChaturvedi-GitHub/Speech-to-Text-with-Python-Google-Web-Speech-API.git

set -Eeuo pipefail

REPO_URL="https://github.com/AnubhavChaturvedi-GitHub/Speech-to-Text-with-Python-Google-Web-Speech-API.git"
TARGET_DIR="Speech-to-Text-with-Python-Google-Web-Speech-API"

info() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
ok()   { printf "\033[1;32m[ OK ]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m[ERR ]\033[0m %s\n" "$*" >&2; }
die()  { err "$*"; exit 1; }
trap 'err "Command failed: $BASH_COMMAND"' ERR

command_exists() { command -v "$1" >/dev/null 2>&1; }

open_url() {
  local url="$1"
  if command_exists xdg-open; then xdg-open "$url" >/dev/null 2>&1 || true
  elif command_exists open; then open "$url" >/dev/null 2>&1 || true
  elif command_exists wslview; then wslview "$url" >/dev/null 2>&1 || true
  else warn "Please visit: $url"
  fi
}

detect_pkg_mgr() {
  if command_exists apt-get; then echo apt
  elif command_exists dnf; then echo dnf
  elif command_exists yum; then echo yum
  elif command_exists pacman; then echo pacman
  elif command_exists zypper; then echo zypper
  elif command_exists apk; then echo apk
  elif command_exists brew; then echo brew
  elif command_exists pkg; then echo pkg
  else echo unknown
  fi
}

install_packages() {
  local mgr; mgr="$(detect_pkg_mgr)"
  case "$mgr" in
    apt)    sudo apt-get update -y && sudo apt-get install -y "$@" ;;
    dnf)    sudo dnf install -y "$@" ;;
    yum)    sudo yum install -y "$@" ;;
    pacman) sudo pacman -Syu --noconfirm "$@" ;;
    zypper) sudo zypper install -y "$@" ;;
    apk)    sudo apk add --update "$@" ;;
    brew)   brew install "$@" ;;
    pkg)    pkg install -y "$@" ;;
    *)      die "Unsupported system: couldn't detect a package manager. Please install: $*"
  esac
}

ensure_git() {
  if command_exists git; then
    ok "git is already initialized and installed."
  else
    warn "git not found. Installing…"
    install_packages git
    ok "git installed."
  fi
}

PY=""
ensure_python() {
  if command_exists python3; then PY="python3"
  elif command_exists python; then PY="python"
  else PY=""
  fi
  if [[ -z "$PY" ]]; then
    warn "Python is not installed."
    echo "Opening the official Python downloads page. Please install Python 3, then re-run this script."
    open_url "https://www.python.org/downloads/"
    return 1
  fi
  ok "Found $($PY --version 2>&1)"
  return 0
}

ensure_pip() {
  if "$PY" -m pip --version >/dev/null 2>&1; then
    ok "pip is available."
  else
    warn "pip not found. Bootstrapping…"
    if "$PY" -m ensurepip --upgrade >/dev/null 2>&1; then
      ok "pip installed via ensurepip."
    else
      # Try package managers commonly used for pip
      local mgr; mgr="$(detect_pkg_mgr)"
      case "$mgr" in
        apt|dnf|yum|zypper) install_packages python3-pip ;;
        pacman)             install_packages python-pip ;;
        apk)                install_packages py3-pip ;;
        brew)               install_packages python ;; # pip comes with Homebrew Python
        pkg)                install_packages python ;;
        *)                  die "Could not install pip automatically. Please install pip and re-run."
      esac
    fi
  fi
}

maybe_create_venv() {
  # Create a venv automatically (silent success if not possible)
  if "$PY" -m venv ".venv" 2>/dev/null; then
    # shellcheck source=/dev/null
    source ".venv/bin/activate"
    ok "Virtual environment '.venv' activated."
  else
    # Try install venv support where needed (notably Debian/Ubuntu)
    local mgr; mgr="$(detect_pkg_mgr)"
    if [[ "$mgr" == "apt" ]]; then
      install_packages python3-venv || true
      if "$PY" -m venv ".venv" 2>/dev/null; then
        # shellcheck source=/dev/null
        source ".venv/bin/activate"
        ok "Virtual environment '.venv' activated."
      else
        warn "Could not create a virtual environment. Continuing without venv."
      fi
    else
      warn "Could not create a virtual environment. Continuing without venv."
    fi
  fi
}

install_requirements() {
  local req_file="$1"
  ensure_python || return 1
  ensure_pip
  "$PY" -m pip install --upgrade pip setuptools wheel
  info "Installing dependencies from $req_file"
  "$PY" -m pip install -r "$req_file"
  ok "Python requirements installed."
}

main() {
  ensure_git

  if [[ -d "$TARGET_DIR/.git" ]]; then
    info "Repo directory exists. Pulling latest changes…"
    git -C "$TARGET_DIR" pull --ff-only
    ok "Repository updated."
  else
    info "Cloning repository…"
    git clone "$REPO_URL" "$TARGET_DIR"
    ok "Repository cloned to '$TARGET_DIR'."
  fi

  cd "$TARGET_DIR"

  # requirements file (case-insensitive)
  local req_file=""
  req_file="$(find . -maxdepth 2 -type f \( -iname "requirements.txt" -o -iname "requirement.txt" \) -print -quit || true)"

  if [[ -n "$req_file" ]]; then
    maybe_create_venv || true
    install_requirements "$req_file" || die "Failed installing requirements."
  else
    warn "No requirements.txt/requirement.txt found. Skipping Python dependency install."
  fi

  ok "Setup complete."
}

main "$@"
