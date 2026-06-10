#!/usr/bin/env bash
#=======================================
# CODEX-M41NUL - TTC SETUP INSTALLER
# Version: 2.0 | © 2026 CODEX-M41NUL. All Rights Reserved.
# Developer : Md. Mainul Islam
# GitHub    : https://github.com/M41NUL
#=======================================

set -euo pipefail

REPO_URL="https://github.com/M41NUL/termux-theme-changer.git"
BASE="$HOME/termux-theme-changer"
BIN_LINK="${PREFIX:-/data/data/com.termux/files/usr}/bin/ttc"

RD=$'\033[1;31m'
GR=$'\033[1;32m'
YL=$'\033[1;33m'
CY=$'\033[1;36m'
W=$'\033[1;37m'
OR=$'\033[38;5;208m'
DIM=$'\033[2m'
BLD=$'\033[1m'
RS=$'\033[0m'
BG_GR=$'\033[42;30m'
BG_RD=$'\033[41;97m'
BG_CY=$'\033[46;30m'

info()    { printf "  ${CY}[*]${RS} %s\n" "$1"; }
success() { printf "  ${GR}[+]${RS} %s\n" "$1"; }
warn()    { printf "  ${YL}[!]${RS} %s\n" "$1"; }
error()   { printf "  ${RD}[-]${RS} %s\n" "$1"; exit 1; }

clear
printf "\n"
printf "  ${BG_CY} MAINUL-X TTC SETUP INSTALLER ${RS}\n\n"

# ── 1. Install git ──
if ! command -v git >/dev/null 2>&1; then
    info "git not found, installing..."
    pkg install -y git >/dev/null 2>&1 && success "git installed." || error "Failed to install git."
fi

# ── 2. Clone or update ──
if [ -d "$BASE/.git" ]; then
    info "Existing repo found. Updating..."
    git -C "$BASE" pull --quiet origin main 2>/dev/null || \
    git -C "$BASE" pull --quiet origin master 2>/dev/null || \
    warn "Could not pull latest — using existing files."
    success "Repo up to date."
else
    info "Cloning from GitHub..."
    rm -rf "$BASE"
    git clone --quiet "$REPO_URL" "$BASE" 2>/dev/null || error "Clone failed. Check internet."
    success "Repo cloned successfully."
fi

# ── 3. Permissions ──
info "Setting permissions..."
chmod +x "$BASE/ttc.sh" "$BASE/setup.sh"
find "$BASE/installer" -name "*.sh" -exec chmod +x {} \;
find "$BASE/shared"    -name "*.sh" -exec chmod +x {} \;
success "Permissions set."

# ── 4. Create ttc command ──
info "Creating 'ttc' global command..."
printf '#!/usr/bin/env bash\nexec bash "$HOME/termux-theme-changer/ttc.sh" "$@"\n' > "$BIN_LINK"
chmod +x "$BIN_LINK"
success "'ttc' command created — type: ttc"

# ── 5. zshrc hook ──
ZSHRC="$HOME/.zshrc"
HOOK='# TTC auto-update hook
if [ -d "$HOME/termux-theme-changer/.git" ]; then
    _ttc_local=$(git -C "$HOME/termux-theme-changer" rev-parse HEAD 2>/dev/null)
    _ttc_remote=$(git -C "$HOME/termux-theme-changer" ls-remote origin HEAD 2>/dev/null | awk '"'"'{print $1}'"'"')
    if [ -n "$_ttc_remote" ] && [ "$_ttc_local" != "$_ttc_remote" ]; then
        printf "\n  \033[1;33m[TTC]\033[0m New update available!\n"
        printf "  \033[2mRun \033[0m\033[1;32mttc\033[0m\033[2m to update\033[0m\n\n"
    fi
    unset _ttc_local _ttc_remote
fi'
if [ -f "$ZSHRC" ]; then
    grep -q "TTC auto-update hook" "$ZSHRC" || {
        printf "\n%s\n" "$HOOK" >> "$ZSHRC"
        success "Auto-update hook added to .zshrc"
    }
else
    printf "\n%s\n" "$HOOK" >> "$ZSHRC"
    success "Auto-update hook added to .zshrc"
fi

# ── 6. Done ──
printf "\n"
printf "  ${BG_GR} SETUP COMPLETE! LAUNCHING TTC... ${RS}\n\n"
printf "  ${GR}+${RS} Auto-update runs on every launch\n"
printf "  ${GR}+${RS} GitHub: ${CY}github.com/M41NUL${RS}\n\n"
sleep 1.5

exec bash "$BASE/ttc.sh"
