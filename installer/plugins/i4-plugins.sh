#!/usr/bin/env bash
#=======================================
# MAINUL-X THEME INSTALLER - I4-PLUGINS.SH FILE
# Version: 1.0 | (c) 2026 MAINUL - X
# Developer: MAINUL ISLAM 
# GitHub: M41NUL
# Contact: +8801308850528 
#Gmail: githubmainul@gmail.com
#=======================================

BASE="$HOME/termux-theme-changer"
PLUGINS_DIR="$BASE/plugins"
source "$BASE/shared/prog.sh"

info() { printf "\e[1;36m[*]\e[0m %s\n" "$1"; }
warn() { printf "\e[1;33m[!]\e[0m %s\n" "$1"; }
success() { printf "\e[1;32m[✓]\e[0m %s\n" "$1"; }

if ! command -v git >/dev/null 2>&1; then
    warn "Git not found, installing..."
    pkg install -y git >/dev/null 2>&1 && success "Git installed." || { warn "Failed to install git"; exit 1; }
fi

info "Installing Zsh plugins..."

declare -A PLUGINS=(
    [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions.git"
    [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    [zsh-autocomplete]="https://github.com/marlonrichert/zsh-autocomplete.git"
    [bgnotify]="https://github.com/t413/zsh-background-notify.git"
    [zsh-fzf-history-search]="https://github.com/joshskidmore/zsh-fzf-history-search.git"
)

mkdir -p "$PLUGINS_DIR"

for plugin in "${!PLUGINS[@]}"; do
    dest="$PLUGINS_DIR/$plugin"
    if [ -d "$dest" ]; then
        info "Plugin $plugin already exists, skipping..."
    else
        progress_bar "Cloning $plugin" 2
        if git clone --depth=1 "${PLUGINS[$plugin]}" "$dest" >/dev/null 2>&1; then
            success "Plugin $plugin installed."
        else
            warn "Failed to clone $plugin"
        fi
    fi
done

info "Zsh plugins installation completed!"
