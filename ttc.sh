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

BASE="$HOME/termux-theme-changer"
SHARED="$BASE/shared/prog.sh"
INSTALLER_DIR="$BASE/installer"
REPO_URL="https://github.com/M41NUL/termux-theme-changer.git"
CURRENT_VERSION="2.0.0"

# ── Colors: Green / Red / Orange theme ──
GR='\033[1;32m'   # Green
RD='\033[1;31m'   # Red
OR='\033[38;5;208m' # Orange
W='\033[1;37m'    # White
DIM='\033[2m'
RESET='\033[0m'

info()    { printf "${OR}[*]${RESET} %s\n" "$1"; }
success() { printf "${GR}[✓]${RESET} %s\n" "$1"; }
warn()    { printf "${OR}[!]${RESET} %s\n" "$1"; }
error()   { printf "${RD}[✗]${RESET} %s\n" "$1"; }
step()    { printf "\n${GR}[→]${RESET} ${W}%s${RESET}\n" "$1"; }

# ──────────────────────────────────────
# BANNER
# ──────────────────────────────────────
show_banner() {
    clear
    echo -e ""
    echo -e "  ${GR}╔══════════════════════════════════════════╗${RESET}"
    echo -e "  ${GR}║${RESET}                                          ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}   ${RD} _____ _____ _____${RESET}                    ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}   ${OR}|_   _|_   _/ ____|${RESET}                   ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}   ${GR}  | |   | || |     ${RESET}  ${W}Termux Theme${RESET}    ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}   ${OR}  | |   | || |___  ${RESET}  ${W}Changer v${CURRENT_VERSION}${RESET}  ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}   ${RD}  |_|   |_| \_____|${RESET}                   ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}                                          ${GR}║${RESET}"
    echo -e "  ${GR}╠══════════════════════════════════════════╣${RESET}"
    echo -e "  ${GR}║${RESET}  ${DIM}Owner${RESET}  : ${OR}CODEX-M41NUL${RESET}  ${DIM}│${RESET}  ${DIM}Dev${RESET}: ${W}M41NUL${RESET}   ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${DIM}GitHub${RESET} : ${GR}github.com/M41NUL${RESET}              ${GR}║${RESET}"
    echo -e "  ${GR}╚══════════════════════════════════════════╝${RESET}"
    echo -e ""
}

# ──────────────────────────────────────
# PROGRESS BAR
# ──────────────────────────────────────
progress_bar() {
    local task="$1"
    local duration="${2:-2}"
    local width=20
    local task_padded
    task_padded=$(printf "%-28s" "${task:0:28}")
    for i in $(seq 0 100); do
        local filled=$((i * width / 100))
        local bar
        bar=$(printf "%${filled}s" | tr ' ' '█')
        local spa
        spa=$(printf "%$((width - filled))s" | tr ' ' '░')
        local color="$OR"
        (( i == 100 )) && color="$GR"
        printf "\r  ${DIM}%s${RESET} ${color}[%s%s]${RESET} ${W}%3d%%${RESET}" \
            "$task_padded" "$bar" "$spa" "$i"
        sleep "$(awk "BEGIN{print $duration/100}")"
    done
    echo
}

# ──────────────────────────────────────
# STEP 1 — AUTO INSTALL MISSING TOOLS
# ──────────────────────────────────────
auto_install_deps() {
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

    info "Missing: ${missing[*]}"
    info "Installing missing packages..."
    apt update -qq >/dev/null 2>&1 || true

    for tool in "${missing[@]}"; do
        printf "  ${OR}[*]${RESET} Installing ${W}%-18s${RESET}" "$tool ..."
        if pkg install -y "$tool" >/dev/null 2>&1; then
            echo -e " ${GR}[✓] Done${RESET}"
        else
            echo -e " ${RD}[✗] Failed${RESET}"
        fi
    done

    success "All tools ready."
    sleep 0.5
}

# ──────────────────────────────────────
# STEP 2 — AUTO UPDATE CHECK
# ──────────────────────────────────────
auto_update() {
    step "Checking for updates..."

    if [ ! -d "$BASE/.git" ]; then
        warn "Git repo not found. Skipping update check."
        return
    fi

    local LOCAL REMOTE
    LOCAL=$(git -C "$BASE" rev-parse HEAD 2>/dev/null || echo "none")
    REMOTE=$(git -C "$BASE" ls-remote origin HEAD 2>/dev/null | awk '{print $1}' || echo "none")

    if [ "$REMOTE" = "none" ]; then
        warn "No internet — skipping update."
    elif [ "$LOCAL" = "$REMOTE" ]; then
        success "Already up to date.  ${DIM}(${LOCAL:0:7})${RESET}"
    else
        info "New update found! Pulling from GitHub..."
        progress_bar "Downloading update" 2
        if git -C "$BASE" pull --quiet origin main 2>/dev/null || \
           git -C "$BASE" pull --quiet origin master 2>/dev/null; then
            success "Updated!  ${DIM}(${REMOTE:0:7})${RESET}"
        else
            warn "Pull failed — check connection."
        fi
    fi

    sleep 0.5
}

# ──────────────────────────────────────
# MENU — 01: THEME INSTALLATION
# ──────────────────────────────────────
run_installer() {
    clear
    echo -e ""
    echo -e "  ${GR}╔══════════════════════════════════════════╗${RESET}"
    echo -e "  ${GR}║${RESET}       ${GR}STARTING THEME INSTALLATION${RESET}        ${GR}║${RESET}"
    echo -e "  ${GR}╚══════════════════════════════════════════╝${RESET}"
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
        local spath="$INSTALLER_DIR/$script"
        if [ -f "$spath" ]; then
            bash "$spath"
        else
            warn "Script not found: $spath"
        fi
    done

    echo ""
    printf "${OR}  Press Enter to return to menu...${RESET}"
    read -r
}

# ──────────────────────────────────────
# MENU — 02: DEVELOPER PROFILE
# ──────────────────────────────────────
dev_info() {
    clear
    show_banner
    echo -e "  ${GR}╔══════════════════════════════════════════╗${RESET}"
    echo -e "  ${GR}║${RESET}           ${W}DEVELOPER PROFILE${RESET}               ${GR}║${RESET}"
    echo -e "  ${GR}╠══════════════════════════════════════════╣${RESET}"
    echo -e "  ${GR}║${RESET}  ${DIM}Name     ${RESET}: ${W}Md. Mainul Islam${RESET}            ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${DIM}Alias    ${RESET}: ${OR}CODEX-M41NUL${RESET}                ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${DIM}GitHub   ${RESET}: ${GR}github.com/M41NUL${RESET}           ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${DIM}Telegram ${RESET}: ${GR}t.me/mdmainulislaminfo${RESET}      ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${DIM}Channel  ${RESET}: ${GR}t.me/codexm41nul${RESET}            ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${DIM}Group    ${RESET}: ${GR}t.me/codex_m41nul${RESET}           ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${DIM}YouTube  ${RESET}: ${RD}youtube.com/@codexm41nul${RESET}    ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${DIM}WhatsApp ${RESET}: ${GR}+8801308850528${RESET}              ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${DIM}Email    ${RESET}: ${OR}devmainulislam@gmail.com${RESET}    ${GR}║${RESET}"
    echo -e "  ${GR}╠══════════════════════════════════════════╣${RESET}"
    echo -e "  ${GR}║${RESET}  ${DIM}© 2026 CODEX-M41NUL. All Rights Reserved.${RESET} ${GR}║${RESET}"
    echo -e "  ${GR}╚══════════════════════════════════════════╝${RESET}"
    echo ""
    printf "${OR}  Press Enter to return...${RESET}"
    read -r
}

# ──────────────────────────────────────
# MENU — 03: ABOUT
# ──────────────────────────────────────
about_tool() {
    clear
    show_banner
    echo -e "  ${GR}╔══════════════════════════════════════════╗${RESET}"
    echo -e "  ${GR}║${RESET}           ${W}ABOUT THIS TOOL${RESET}                 ${GR}║${RESET}"
    echo -e "  ${GR}╠══════════════════════════════════════════╣${RESET}"
    echo -e "  ${GR}║${RESET}  ${OR}▶${RESET} Advanced Termux customization suite    ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${OR}▶${RESET} Auto-install all required packages     ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${OR}▶${RESET} Auto-update from GitHub on every run   ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${OR}▶${RESET} ZSH + Plugins (auto, highlight, fzf)  ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${OR}▶${RESET} Custom Nerd Font integration           ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${OR}▶${RESET} logo-ls with icons                     ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${OR}▶${RESET} RXFETCH-style terminal banner          ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${OR}▶${RESET} One-click full system restore          ${GR}║${RESET}"
    echo -e "  ${GR}╠══════════════════════════════════════════╣${RESET}"
    echo -e "  ${GR}║${RESET}  ${DIM}Version ${RESET}: ${GR}${CURRENT_VERSION}${RESET}                        ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET}  ${DIM}Repo    ${RESET}: ${GR}github.com/M41NUL/termux-theme-changer${RESET} ${GR}║${RESET}"
    echo -e "  ${GR}╚══════════════════════════════════════════╝${RESET}"
    echo ""
    printf "${OR}  Press Enter to return...${RESET}"
    read -r
}

# ──────────────────────────────────────
# MENU — 04: FORCE UPDATE
# ──────────────────────────────────────
force_update() {
    clear
    show_banner
    step "Force pulling latest from GitHub..."
    progress_bar "Downloading latest version" 3
    if git -C "$BASE" fetch --all --quiet 2>/dev/null && \
     { git -C "$BASE" reset --hard origin/main --quiet 2>/dev/null || \
       git -C "$BASE" reset --hard origin/master --quiet 2>/dev/null; }; then
        success "Force update complete!"
    else
        warn "Force update failed — check connection."
    fi
    echo ""
    printf "${OR}  Press Enter to return...${RESET}"
    read -r
}

# ──────────────────────────────────────
# MAIN MENU
# ──────────────────────────────────────
show_menu() {
    echo -e "  ${GR}╔══════════════════════════════════════════╗${RESET}"
    echo -e "  ${GR}║${RESET}             ${W}CONTROL PANEL${RESET}                 ${GR}║${RESET}"
    echo -e "  ${GR}╠════╦═════════════════════════════════════╣${RESET}"
    echo -e "  ${GR}║${RESET} ${GR}01${RESET} ${GR}║${RESET}  ${W}Start Theme Installation${RESET}            ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET} ${GR}02${RESET} ${GR}║${RESET}  ${W}Developer Profile${RESET}                   ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET} ${GR}03${RESET} ${GR}║${RESET}  ${W}About This Tool${RESET}                     ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET} ${OR}04${RESET} ${GR}║${RESET}  ${W}Force Update from GitHub${RESET}            ${GR}║${RESET}"
    echo -e "  ${GR}║${RESET} ${RD}00${RESET} ${GR}║${RESET}  ${RD}Exit Application${RESET}                    ${GR}║${RESET}"
    echo -e "  ${GR}╚════╩═════════════════════════════════════╝${RESET}"
    echo ""
}

# ──────────────────────────────────────
# ENTRYPOINT
# ──────────────────────────────────────
main() {
    # Load shared functions if available
    [ -f "$SHARED" ] && source "$SHARED" 2>/dev/null || true

    # STEP 1: Auto-install missing tools
    auto_install_deps

    # STEP 2: Auto-update check
    auto_update

    sleep 0.3

    # STEP 3: Main menu loop
    while true; do
        show_banner
        show_menu
        printf "  ${GR}SELECT${RESET} ${DIM}[01/02/03/04/00]${RESET} ${GR}→${RESET} "
        read -r choice

        case "$choice" in
            1|01) run_installer ;;
            2|02) dev_info ;;
            3|03) about_tool ;;
            4|04) force_update ;;
            0|00)
                echo ""
                echo -e "  ${RD}Shutting down. Goodbye.${RESET}"
                echo ""
                exit 0
                ;;
            *)
                echo -e "\n  ${RD}[!] Invalid option. Try again.${RESET}\n"
                sleep 0.8
                ;;
        esac
    done
}

main
