#!/usr/bin/env bash
#=======================================
# CODEX-M41NUL TTC - MAIN CONTROLLER
# Version: 2.0 | © 2026 CODEX-M41NUL. All Rights Reserved.
# Developer  : Md. Mainul Islam
# GitHub     : M41NUL  |  https://github.com/M41NUL
# Telegram   : t.me/mdmainulislaminfo
# TG Channel : https://t.me/codexm41nul
# TG Group   : https://t.me/codex_m41nul
# YouTube    : https://youtube.com/@codexm41nul
# Email      : devmainulislam@gmail.com
#=======================================

set -euo pipefail

BASE="$HOME/termux-theme-changer"
SHARED="$BASE/shared/prog.sh"
INSTALLER_DIR="$BASE/installer"
REPO_URL="https://github.com/M41NUL/termux-theme-changer.git"
VERSION_FILE="$BASE/.version"
CURRENT_VERSION="2.0.0"

# ──────────────────────────────────────
# COLORS (inline, prog.sh loads later)
# ──────────────────────────────────────
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'
B='\033[1;34m'; M='\033[1;35m'; C='\033[1;36m'
W='\033[1;37m'; DIM='\033[2m'; RESET='\033[0m'
BOLD='\033[1m'

# ──────────────────────────────────────
# BANNER
# ──────────────────────────────────────
show_banner() {
    clear
    echo -e ""
    echo -e "  ${C}╔══════════════════════════════════════════╗${RESET}"
    echo -e "  ${C}║${RESET}  ${R}  _____ _____ _____  ${RESET}                    ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${Y} |_   _|_   _/ ____|${RESET}                    ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${G}   | |   | || |     ${RESET}  ${W}Termux Theme${RESET}     ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${B}   | |   | || |___  ${RESET}  ${W}Changer  v2${RESET}     ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${M}   |_|   |_| \_____|${RESET}                    ${C}║${RESET}"
    echo -e "  ${C}╠══════════════════════════════════════════╣${RESET}"
    echo -e "  ${C}║${RESET}  ${DIM}Owner${RESET}    : ${W}CODEX-M41NUL${RESET}  ${DIM}│${RESET}  ${DIM}Dev${RESET}: ${W}M41NUL${RESET}  ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${DIM}GitHub${RESET}   : ${C}github.com/M41NUL${RESET}           ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${DIM}Version${RESET}  : ${G}${CURRENT_VERSION}${RESET}  ${DIM}│${RESET}  ${DIM}License${RESET}: ${Y}MIT${RESET}      ${C}║${RESET}"
    echo -e "  ${C}╚══════════════════════════════════════════╝${RESET}"
    echo -e ""
}

# ──────────────────────────────────────
# STEP 1: AUTO INSTALL REQUIRED TOOLS
# ──────────────────────────────────────
auto_install_deps() {
    source "$SHARED" 2>/dev/null || true
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

    info "Missing tools: ${missing[*]}"
    info "Installing missing packages..."

    # Refresh repos quietly
    apt update -qq >/dev/null 2>&1 || true

    for tool in "${missing[@]}"; do
        printf "  ${Y}[*]${RESET} Installing ${W}%-20s${RESET}" "$tool..."
        if pkg install -y "$tool" >/dev/null 2>&1; then
            echo -e " ${G}[✓]${RESET}"
        else
            echo -e " ${R}[✗] FAILED${RESET}"
        fi
    done

    success "Dependency check complete."
}

# ──────────────────────────────────────
# STEP 2: AUTO UPDATE FROM GITHUB
# ──────────────────────────────────────
auto_update() {
    source "$SHARED" 2>/dev/null || true
    step "Checking for updates..."

    if [ ! -d "$BASE/.git" ]; then
        warn "Not a git repo. Re-cloning from GitHub..."
        local tmp_dir
        tmp_dir=$(mktemp -d)
        if git clone --quiet "$REPO_URL" "$tmp_dir" 2>/dev/null; then
            cp -rf "$tmp_dir/." "$BASE/"
            rm -rf "$tmp_dir"
            success "Repo restored from GitHub."
        else
            warn "Update failed — check internet connection."
        fi
        return
    fi

    local LOCAL REMOTE
    LOCAL=$(git -C "$BASE" rev-parse HEAD 2>/dev/null || echo "unknown")
    REMOTE=$(git -C "$BASE" ls-remote origin HEAD 2>/dev/null | awk '{print $1}' || echo "unknown")

    if [ "$LOCAL" = "$REMOTE" ] || [ "$REMOTE" = "unknown" ]; then
        success "Already up to date. (${LOCAL:0:7})"
    else
        info "Update available! Pulling from GitHub..."
        progress_bar "Downloading update" 2
        if git -C "$BASE" pull --quiet origin main 2>/dev/null || \
           git -C "$BASE" pull --quiet origin master 2>/dev/null; then
            echo "$CURRENT_VERSION" > "$VERSION_FILE"
            success "Updated to latest version!"
            echo -e "  ${DIM}Commit: ${G}${REMOTE:0:7}${RESET}"
        else
            warn "Update failed — check connection."
        fi
    fi
}

# ──────────────────────────────────────
# MENU ACTIONS
# ──────────────────────────────────────
run_installer() {
    clear
    source "$SHARED" 2>/dev/null || true
    echo -e ""
    echo -e "  ${C}╔══════════════════════════════════════════╗${RESET}"
    echo -e "  ${C}║${RESET}       ${G}STARTING THEME INSTALLATION${RESET}        ${C}║${RESET}"
    echo -e "  ${C}╚══════════════════════════════════════════╝${RESET}"
    echo -e ""
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

    for script in "${SCRIPTS[@]}"; do
        local path="$INSTALLER_DIR/$script"
        if [ -f "$path" ]; then
            bash "$path"
        else
            warn "Missing: $path"
        fi
    done

    echo ""
    printf "${Y}  Press Enter to return to menu...${RESET}"
    read -r
}

dev_info() {
    clear
    show_banner
    echo -e "  ${C}╔══════════════════════════════════════════╗${RESET}"
    echo -e "  ${C}║${RESET}           ${W}DEVELOPER PROFILE${RESET}               ${C}║${RESET}"
    echo -e "  ${C}╠══════════════════════════════════════════╣${RESET}"
    echo -e "  ${C}║${RESET}  ${DIM}Name     ${RESET}: ${W}Md. Mainul Islam${RESET}            ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${DIM}Alias    ${RESET}: ${Y}CODEX-M41NUL${RESET}                ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${DIM}GitHub   ${RESET}: ${C}github.com/M41NUL${RESET}           ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${DIM}Telegram ${RESET}: ${B}t.me/mdmainulislaminfo${RESET}      ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${DIM}Channel  ${RESET}: ${B}t.me/codexm41nul${RESET}            ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${DIM}Group    ${RESET}: ${B}t.me/codex_m41nul${RESET}           ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${DIM}YouTube  ${RESET}: ${R}youtube.com/@codexm41nul${RESET}    ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${DIM}WhatsApp ${RESET}: ${G}+8801308850528${RESET}              ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${DIM}Email    ${RESET}: ${M}devmainulislam@gmail.com${RESET}    ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${DIM}License  ${RESET}: ${Y}MIT License${RESET}                 ${C}║${RESET}"
    echo -e "  ${C}╠══════════════════════════════════════════╣${RESET}"
    echo -e "  ${C}║${RESET}  ${DIM}© 2026 CODEX-M41NUL. All Rights Reserved.${RESET} ${C}║${RESET}"
    echo -e "  ${C}╚══════════════════════════════════════════╝${RESET}"
    echo ""
    printf "${Y}  Press Enter to return...${RESET}"
    read -r
}

about_tool() {
    clear
    show_banner
    echo -e "  ${C}╔══════════════════════════════════════════╗${RESET}"
    echo -e "  ${C}║${RESET}         ${W}SYSTEM SPECIFICATIONS${RESET}             ${C}║${RESET}"
    echo -e "  ${C}╠══════════════════════════════════════════╣${RESET}"
    echo -e "  ${C}║${RESET}  ${Y}●${RESET} Advanced Termux customization suite     ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${Y}●${RESET} Auto-install all required packages      ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${Y}●${RESET} Auto-update from GitHub on every run    ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${Y}●${RESET} ZSH + Plugins (autosuggestions, etc.)  ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${Y}●${RESET} Custom Nerd Font integration            ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${Y}●${RESET} logo-ls with icons                      ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${Y}●${RESET} RXFETCH-style terminal banner           ${C}║${RESET}"
    echo -e "  ${C}║${RESET}  ${Y}●${RESET} One-click full system restore           ${C}║${RESET}"
    echo -e "  ${C}╚══════════════════════════════════════════╝${RESET}"
    echo ""
    printf "${Y}  Press Enter to return...${RESET}"
    read -r
}

force_update() {
    clear
    show_banner
    source "$SHARED" 2>/dev/null || true
    step "Force pulling latest from GitHub..."
    progress_bar "Downloading latest version" 3
    if git -C "$BASE" fetch --all --quiet 2>/dev/null && \
       git -C "$BASE" reset --hard origin/main --quiet 2>/dev/null || \
       git -C "$BASE" reset --hard origin/master --quiet 2>/dev/null; then
        success "Force update complete!"
    else
        warn "Force update failed."
    fi
    echo ""
    printf "${Y}  Press Enter to return...${RESET}"
    read -r
}

# ──────────────────────────────────────
# MAIN MENU
# ──────────────────────────────────────
show_menu() {
    echo -e "  ${C}╔══════════════════════════════════════════╗${RESET}"
    echo -e "  ${C}║${RESET}            ${W}CONTROL PANEL${RESET}                  ${C}║${RESET}"
    echo -e "  ${C}╠══╦═══════════════════════════════════════╣${RESET}"
    echo -e "  ${C}║${RESET} ${Y}01${RESET} ${C}║${RESET}  ${W}Start Theme Installation${RESET}            ${C}║${RESET}"
    echo -e "  ${C}║${RESET} ${Y}02${RESET} ${C}║${RESET}  ${W}Developer Profile${RESET}                   ${C}║${RESET}"
    echo -e "  ${C}║${RESET} ${Y}03${RESET} ${C}║${RESET}  ${W}About This Tool${RESET}                     ${C}║${RESET}"
    echo -e "  ${C}║${RESET} ${B}04${RESET} ${C}║${RESET}  ${W}Force Update from GitHub${RESET}            ${C}║${RESET}"
    echo -e "  ${C}║${RESET} ${R}00${RESET} ${C}║${RESET}  ${R}Exit Application${RESET}                    ${C}║${RESET}"
    echo -e "  ${C}╚══╩═══════════════════════════════════════╝${RESET}"
    echo ""
}

# ──────────────────────────────────────
# ENTRYPOINT
# ──────────────────────────────────────
main() {
    # Step 1: Auto install deps
    auto_install_deps

    # Step 2: Auto update
    auto_update

    sleep 0.5

    # Step 3: Main menu loop
    while true; do
        show_banner
        show_menu
        printf "  ${G}SELECT OPTION${RESET} ${DIM}[01/02/03/04/00]${RESET}: "
        read -r choice

        case "$choice" in
            1|01) run_installer ;;
            2|02) dev_info ;;
            3|03) about_tool ;;
            4|04) force_update ;;
            0|00)
                echo ""
                echo -e "  ${R}Shutting down. Goodbye.${RESET}"
                echo ""
                exit 0
                ;;
            *)
                echo -e "\n  ${R}[!] Invalid option. Try again.${RESET}\n"
                sleep 1
                ;;
        esac
    done
}

main
