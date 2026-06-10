#!/usr/bin/env bash
#=======================================
# CODEX-M41NUL - INSTALLER - I2-CORE.SH
# Version: 2.0 | © 2026 CODEX-M41NUL. All Rights Reserved.
# Developer : Md. Mainul Islam
# GitHub    : https://github.com/M41NUL
# Telegram  : t.me/mdmainulislaminfo
# Channel   : t.me/codexm41nul
#=======================================


BASE="$HOME/termux-theme-changer"
source "$BASE/shared/prog.sh"

info() { printf "\e[1;36m[*]\e[0m %s\n" "$1"; }
warn() { printf "\e[1;33m[!]\e[0m %s\n" "$1"; }

info "Preparing environment..."
progress_bar "Refreshing repositories" 2

if apt update -o Acquire::http::Timeout=10 -o Acquire::Retries=1 -qq >/dev/null 2>&1; then
    echo -e "\e[1;32m[✓]\e[0m Repositories refreshed successfully!"
    echo -e "\e[1;32m[✓]\e[0m All packages are up to date!"
else
    warn "Repository refresh failed — check your connection."
fi

info "Installing core packages..."
progress_bar "Installing core utilities" 3

if pkg install -y --no-upgrade bash coreutils curl git zsh termux-tools >/dev/null 2>&1; then
    echo -e "\e[1;32m[✓]\e[0m Core packages installed successfully!"
else
    warn "Failed to install core packages."
fi
