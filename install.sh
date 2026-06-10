#!/usr/bin/env bash
#=======================================
# CODEX-M41NUL — TTC INSTALLER
# Version: 3.0 | © 2026 CODEX-M41NUL
# Developer : Md. Mainul Islam
# GitHub    : https://github.com/M41NUL
# Telegram  : t.me/mdmainulislaminfo
#=======================================

BASE="$HOME/termux-theme-changer"
SHARED="$BASE/shared/prog.sh"
INSTALLER_DIR="$BASE/installer"

GR=$'\033[1;32m'
RD=$'\033[1;31m'
OR=$'\033[38;5;208m'
CY=$'\033[1;36m'
W=$'\033[1;37m'
YL=$'\033[1;33m'
DIM=$'\033[2m'
BLD=$'\033[1m'
RS=$'\033[0m'
BG_GR=$'\033[42;30m'
BG_CY=$'\033[46;30m'
BG_RD=$'\033[41;97m'

info()    { printf "  ${CY}[*]${RS} %s\n" "$1"; }
success() { printf "  ${GR}[+]${RS} %s\n" "$1"; }
warn()    { printf "  ${YL}[!]${RS} %s\n" "$1"; }
error()   { printf "  ${RD}[-]${RS} %s\n" "$1"; }
step()    { printf "\n  ${BG_GR} >> ${RS} ${BLD}%s${RS}\n" "$1"; }

# ──────────────────────────────────────
# AUTO INSTALL DEPENDENCIES
# ──────────────────────────────────────
install_deps() {
    step "Checking required tools..."
    local TOOLS=("git" "curl" "zsh" "figlet" "fzf" "neofetch")
    local missing=()
    for tool in "${TOOLS[@]}"; do
        command -v "$tool" >/dev/null 2>&1 || missing+=("$tool")
    done

    if [ ${#missing[@]} -eq 0 ]; then
        success "All required tools already installed."
        return 0
    fi

    warn "Missing tools: ${missing[*]}"
    apt update -qq >/dev/null 2>&1 || true

    for tool in "${missing[@]}"; do
        printf "  ${CY}[*]${RS} Installing ${BLD}%-14s${RS} " "$tool..."
        if pkg install -y "$tool" >/dev/null 2>&1; then
            printf "${BG_GR} DONE ${RS}\n"
        else
            printf "${BG_RD} FAIL ${RS}\n"
        fi
    done
    success "Dependency check complete."
    sleep 0.5
}

# ──────────────────────────────────────
# RUN INSTALLER SCRIPTS IN ORDER
# ──────────────────────────────────────
run_install_scripts() {
    clear
    printf "\n  ${BG_CY} STARTING THEME INSTALLATION ${RS}\n\n"
    sleep 0.5

    local SCRIPTS=(
        "env/i1-env.sh"
        "core/i2-core.sh"
        "extra/i3-extra.sh"
        "plugins/i4-plugins.sh"
        "theme/i5-theme.sh"
        "shell/i6-shell.sh"
        "restore/i7-restore.sh"
        "final/i8-final.sh"
    )

    local total=${#SCRIPTS[@]}
    local count=0

    for script in "${SCRIPTS[@]}"; do
        count=$(( count + 1 ))
        local spath="$INSTALLER_DIR/$script"
        local sname
        sname=$(basename "$script")
        if [ -f "$spath" ]; then
            printf "\n  ${DIM}[ %d/%d ]${RS} Running ${BLD}%s${RS}\n" "$count" "$total" "$sname"
            bash "$spath"
        else
            warn "Script not found: $spath — skipping."
        fi
    done
}

# ──────────────────────────────────────
# MARK INSTALLATION AS COMPLETE
# ──────────────────────────────────────
mark_installed() {
    local FLAG="$HOME/.cache/mainul-x/ttc_installed"
    mkdir -p "$HOME/.cache/mainul-x"
    touch "$FLAG"
}

# ──────────────────────────────────────
# ENTRYPOINT
# ──────────────────────────────────────
main() {
    [ -f "$SHARED" ] && source "$SHARED" 2>/dev/null || true
    install_deps
    run_install_scripts
    mark_installed

    printf "\n  ${OR}Press Enter to return to menu...${RS} "
    read -r
}

main
