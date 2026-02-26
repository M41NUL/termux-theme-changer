#!/usr/bin/env bash
#=======================================
# MAINUL-X THEME INSTALLER - I7-RESTORE.SH FILE
# Version: 1.0 | (c) 2026 MAINUL - X
# Developer: MAINUL ISLAM 
# GitHub: M41NUL
# Contact: +8801308850528 
#Gmail: githubmainul@gmail.com
#=======================================


set -euo pipefail

BASE="$HOME/termux-theme-changer"
RESTORE_SH="$HOME/restore.sh"
PREFIX=${PREFIX:-/data/data/com.termux/files/usr}

info()    { printf "\e[1;36m[*]\e[0m %s\n" "$1"; }
success() { printf "\e[1;32m[✓]\e[0m %s\n" "$1"; }
warn()    { printf "\e[1;33m[!]\e[0m %s\n" "$1"; }

info "Preparing restore module..."
sleep 0.5

cat > "$RESTORE_SH" <<'RESTORE_EOF'
#!/usr/bin/env bash

set -euo pipefail
PREFIX=${PREFIX:-/data/data/com.termux/files/usr}

info()    { printf "\e[1;36m[*]\e[0m %s\n" "$1"; }
success() { printf "\e[1;32m[✓]\e[0m %s\n" "$1"; }

clear
info "Starting Termux restoration process..."
sleep 1

if [ -x "$PREFIX/bin/bash" ]; then
    chsh -s "$PREFIX/bin/bash" >/dev/null 2>&1 || true
fi

if [ -d "$HOME/termux-theme-changer" ]; then
    BACKUP="$HOME/termux-theme-changer.bak"
    info "Backing up theme..."
    rm -rf "$BACKUP" 2>/dev/null || true
    cp -r "$HOME/termux-theme-changer" "$BACKUP"
fi

info "Removing user configurations..."
rm -rf "$HOME/.zshrc" \
       "$HOME/.zsh_history" \
       "$HOME/.oh-my-zsh" \
       "$HOME/.zlogin" \
       "$HOME/.zprofile" \
       "$HOME/.bashrc" \
       "$HOME/.profile" \
       "$HOME/.bash_profile" \
       "$HOME/.autostart" \
       "$HOME/.aliases" \
       "$HOME/termux-theme-changer"

info "Restoring default /etc/bash.bashrc..."
mkdir -p "$PREFIX/etc"

cat > "$PREFIX/etc/bash.bashrc" <<'BASHRC'
if [ "$TERM" != "dumb" ]; then
    PS1='~ $ '
fi

echo
echo "Welcome to Termux!"
echo
echo "Docs:       https://termux.dev/docs"
echo "Donate:     https://termux.dev/donate"
echo "Community:  https://termux.dev/community"
echo
echo "Commands:"
echo "  pkg search <query>"
echo "  pkg install <package>"
echo "  pkg upgrade"
echo
echo "Repos:"
echo "  pkg install root-repo"
echo "  pkg install x11-repo"
echo
echo "If repo broken: termux-change-repo"
echo "Report issues: https://termux.dev/issues"
BASHRC

info "Resetting ~/.termux..."
rm -rf "$HOME/.termux"
mkdir -p "$HOME/.termux"

cat > "$HOME/.termux/termux.properties" <<'PROP'
extra-keys = [ ['ESC','TAB','CTRL','ALT','UP','DOWN','LEFT','RIGHT'] ]
PROP

termux-reload-settings >/dev/null 2>&1 || true

info "Reinstalling essential Termux packages..."
pkg reinstall -y bash coreutils termux-tools >/dev/null 2>&1 || true

info "Clearing cache..."
rm -rf "$PREFIX/var/cache"/* >/dev/null 2>&1 || true

success "Termux restored to default clean state."
echo -e "\e[1;32mDefault prompt:\e[0m ~ \$"
echo -e "\e[1;33mClose and reopen Termux.\e[0m"
RESTORE_EOF

chmod +x "$RESTORE_SH"
success "Restore module created successfully!"
