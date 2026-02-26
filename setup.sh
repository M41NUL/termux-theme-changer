#!/usr/bin/env bash
#=======================================
# MAINUL-X THEME INSTALLER - INSTALL FILE
# Version: 1.0 | (c) 2026 MAINUL - X
# Developer: MAINUL ISLAM 
# GitHub: M41NUL
# Contact: +8801308850528 
#Gmail: githubmainul@gmail.com
#=======================================

set -euo pipefail

export BASE="$HOME/termux-theme-changer"
INSTALLER_DIR="$BASE/installer"
SHARED_DIR="$BASE/shared"

mkdir -p "$INSTALLER_DIR" "$SHARED_DIR"

bash "$INSTALLER_DIR/env/i1-env.sh"
bash "$INSTALLER_DIR/core/i2-core.sh"
bash "$INSTALLER_DIR/extra/i3-extra.sh"
bash "$INSTALLER_DIR/plugins/i4-plugins.sh"
bash "$INSTALLER_DIR/theme/i5-theme.sh"
bash "$INSTALLER_DIR/shell/i6-shell.sh"
bash "$INSTALLER_DIR/restore/i7-restore.sh"
bash "$INSTALLER_DIR/final/i8-final.sh"
