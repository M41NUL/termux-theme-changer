#!/usr/bin/env bash
#=======================================
# MAINUL-X THEME INSTALLER - I3-EXTRA.SH FILE
# Version: 1.0 | (c) 2026 MAINUL - X
# Developer: MAINUL ISLAM 
# GitHub: M41NUL
# Contact: +8801308850528 
#Gmail: githubmainul@gmail.com
#=======================================


BASE="$HOME/termux-theme-changer"
PLUGINS_DIR="$BASE/plugins"
TERMUX_DIR="$HOME/.termux"
LOGOLS_DIR="$HOME/tmp-logo-ls"

source "$BASE/shared/prog.sh" 2>/dev/null || true
command -v info >/dev/null 2>&1 || info() { printf "\e[1;36m[*]\e[0m %s\n" "$1"; }
command -v warn >/dev/null 2>&1 || warn() { printf "\e[1;33m[!]\e[0m %s\n" "$1"; }

info "Installing extra utilities..."
progress_bar "Installing extra tools" 3

if ! command -v go >/dev/null 2>&1; then
    info "Go not found — installing..."
    if pkg install -y golang >/dev/null 2>&1; then
        info "Go installed successfully."
    else
        warn "Failed to install Go. Please install manually."
    fi
else
    info "Go already installed."
fi

if [ -d "$LOGOLS_DIR" ]; then
    info "Updating existing logo-ls repo..."
    git -C "$LOGOLS_DIR" pull --quiet >/dev/null 2>&1 && \
        info "logo-ls repository updated!" || \
        warn "Failed to update logo-ls repository."
else
    info "Cloning logo-ls repository..."
    git clone --quiet https://github.com/Yash-Handa/logo-ls.git "$LOGOLS_DIR" >/dev/null 2>&1 && \
        info "logo-ls repository cloned successfully!" || \
        warn "Failed to clone logo-ls repo."
fi

cd "$LOGOLS_DIR" || exit 1
info "Building logo-ls binary..."
if go build -o "$PREFIX/bin/logo-ls" >/dev/null 2>&1; then
    chmod +x "$PREFIX/bin/logo-ls"
    info "logo-ls installed successfully!"
else
    warn "Build failed. Please check Go installation."
    exit 1
fi

ZSHRC="$HOME/.zshrc"
grep -q "alias ls='logo-ls'" "$ZSHRC" 2>/dev/null || {
    info "Adding alias to Zsh..."
    {
        echo "alias ls='logo-ls'"
        echo "alias els='logo-ls'"
    } >> "$ZSHRC"
    info "Aliases added to .zshrc!"
}

info "Setting up directories..."
progress_bar "Creating directory structure" 1.5
mkdir -p "$PLUGINS_DIR" "$TERMUX_DIR"

info "Extra utilities installation completed!"
