#!/usr/bin/env bash
#=======================================
# CODEX-M41NUL - TTC SETUP INSTALLER
# Version: 2.0 | © 2026 CODEX-M41NUL. All Rights Reserved.
# Developer : Md. Mainul Islam
# GitHub    : https://github.com/M41NUL
# Telegram  : t.me/mdmainulislaminfo
# Channel   : t.me/codexm41nul
#=======================================

set -euo pipefail

REPO_URL="https://github.com/M41NUL/termux-theme-changer.git"
BASE="$HOME/termux-theme-changer"
BIN_LINK="$PREFIX/bin/ttc"

R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'
C='\033[1;36m'; W='\033[1;37m'; RESET='\033[0m'

_box_width() {
    local cols
    cols=$(tput cols 2>/dev/null || echo 50)
    [ "$cols" -gt 70 ] && cols=70
    [ "$cols" -lt 30 ] && cols=30
    echo "$cols"
}
box_line() {
    local char="$1" color="${2:-$C}" w inner line
    w=$(_box_width); inner=$(( w - 2 ))
    line=$(printf '%*s' "$inner" '' | tr ' ' "$char")
    printf "${color}+%s+${RESET}\n" "$line"
}
box_row() {
    local text="$1" color="${2:-$C}"
    local w inner plain plen pad
    w=$(_box_width); inner=$(( w - 4 ))
    plain=$(printf '%s' "$text" | sed 's/\x1b\[[0-9;]*m//g')
    plen=${#plain}; pad=$(( inner - plen ))
    [ "$pad" -lt 0 ] && pad=0
    printf "${color}|${RESET} %s%*s ${color}|${RESET}\n" "$text" "$pad" ''
}

clear
echo ""
box_line "-" "$C"
box_row "      ${W}MAINUL-X TTC SETUP INSTALLER${RESET}" "$C"
box_line "-" "$C"
echo ""

info()    { printf "  ${C}[*]${RESET} %s\n" "$1"; }
success() { printf "  ${G}[+]${RESET} %s\n" "$1"; }
warn()    { printf "  ${Y}[!]${RESET} %s\n" "$1"; }
error()   { printf "  ${R}[-]${RESET} %s\n" "$1"; exit 1; }

# ── 1. Install git if missing ──
if ! command -v git >/dev/null 2>&1; then
    info "git not found, installing..."
    pkg install -y git >/dev/null 2>&1 && success "git installed." || error "Failed to install git."
fi

# ── 2. Clone or update repo ──
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

# ── 3. Set permissions ──
info "Setting permissions..."
chmod +x "$BASE/ttc.sh"
chmod +x "$BASE/setup.sh"
find "$BASE/installer" -name "*.sh" -exec chmod +x {} \;
find "$BASE/shared"    -name "*.sh" -exec chmod +x {} \;
success "Permissions set."

# ── 4. Create 'ttc' command ──
info "Creating 'ttc' global command..."
cat > "$BIN_LINK" <<EOF
#!/usr/bin/env bash
exec bash "\$HOME/termux-theme-changer/ttc.sh" "\$@"
EOF
chmod +x "$BIN_LINK"
success "'ttc' command created — type: ttc"

# ── 5. Add zshrc background update hook ──
ZSHRC="$HOME/.zshrc"
HOOK='# TTC auto-update hook
[ -d "$HOME/termux-theme-changer/.git" ] && \
    git -C "$HOME/termux-theme-changer" fetch --quiet origin 2>/dev/null &'

if [ -f "$ZSHRC" ]; then
    grep -q "TTC auto-update hook" "$ZSHRC" || {
        echo "" >> "$ZSHRC"
        echo "$HOOK" >> "$ZSHRC"
        success "Auto-update hook added to .zshrc"
    }
fi

# ── 6. Done ──
echo ""
box_line "-" "$C"
box_row "       ${G}SETUP COMPLETE! LAUNCHING TTC...${RESET}" "$C"
box_line "=" "$C"
box_row "  ${Y}> Auto-update runs on every launch${RESET}" "$C"
box_row "  ${Y}> GitHub: ${C}github.com/M41NUL${RESET}" "$C"
box_line "-" "$C"
echo ""
sleep 1.5

# ── 7. Auto-launch main menu ──
exec bash "$BASE/ttc.sh"
