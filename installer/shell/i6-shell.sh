#!/usr/bin/env bash
#=======================================
# MAINUL-X THEME INSTALLER - I6-SHELL.SH FILE
# Version: 1.0 | (c) 2026 MAINUL - X
# Developer: MAINUL ISLAM 
# GitHub: M41NUL
# Contact: +8801308850528 
#Gmail: githubmainul@gmail.com
#=======================================


BASE="$HOME/termux-theme-changer"
PLUGINS_DIR="$BASE/plugins"
TERMUX_DIR="$HOME/.termux"

SHARED="$BASE/shared/prog.sh"
if [ -f "$SHARED" ]; then
    source "$SHARED"
fi

command -v info >/dev/null 2>&1 || info() { printf "\e[1;36m[*]\e[0m %s\n" "$1"; }
command -v warn >/dev/null 2>&1 || warn() { printf "\e[1;33m[!]\e[0m %s\n" "$1"; }
command -v progress_bar >/dev/null 2>&1 || progress_bar() { printf "[*] %s\n" "$1"; }

ZSHRC="$HOME/.zshrc"
info "Writing Zsh configuration..."
cat > "$ZSHRC" <<'EOF'
clear
export PATH="$PREFIX/bin:$HOME/.local/bin:$PATH"
export TERM=xterm-256color

if [ ! -z "${ZSH_VERSION-}" ]; then
    autoload -Uz compinit
    compinit
    zstyle ':completion:*' menu select
    bindkey '^I' expand-or-complete

    if command -v fzf >/dev/null 2>&1; then
        FZF_KEYBINDINGS="$PREFIX/share/doc/fzf/examples/key-bindings.zsh"
        [ -f "$FZF_KEYBINDINGS" ] && source "$FZF_KEYBINDINGS"
    fi
    
    PLUGINS_DIR="$HOME/termux-theme-changer/plugins"
    [ -d "$PLUGINS_DIR/zsh-autocomplete" ] && source "$PLUGINS_DIR/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
    for plugin in zsh-autosuggestions bgnotify zsh-fzf-history-search zsh-syntax-highlighting; do
        [ -d "$PLUGINS_DIR/$plugin" ] && source "$PLUGINS_DIR/$plugin/$plugin.zsh" 2>/dev/null || true
    done

    alias c='clear'
    alias q='exit'
    alias sd='cd /sdcard'
    alias dl='cd /sdcard/Download'
    alias pacupg='pkg upgrade'
    alias pacupd='pkg update'
    alias neo='neofetch'

    if command -v els >/dev/null 2>&1; then
        alias ls='els'
        alias ll='els -l'
    else
        alias ls='ls -lh --color=auto'
        alias ll='ls -la --color=auto'
    fi

    PROMPT='%F{white}   ❯_%f '
fi

RXFETCH_SH="$HOME/termux-theme-changer/themes/banner.sh"
[ -x "$RXFETCH_SH" ] && source "$RXFETCH_SH"
EOF

info "Setting Zsh as default shell..."
ZSH_PATH=$(command -v zsh || true)

if [ -n "$ZSH_PATH" ]; then
    [ -f "$HOME/.zshrc" ] || touch "$HOME/.zshrc"

    grep -q "alias ls='logo-ls'" "$HOME/.zshrc" 2>/dev/null || {
        echo "alias ls='logo-ls'" >> "$HOME/.zshrc"
        echo "alias els='logo-ls'" >> "$HOME/.zshrc"
    }

    PROFILE="$HOME/.profile"
    grep -q "exec zsh" "$PROFILE" 2>/dev/null || echo "exec zsh" >> "$PROFILE"

    info "Your shell will switch to Zsh after restarting Termux."
fi
