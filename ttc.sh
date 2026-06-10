#!/usr/bin/env bash
#=======================================
# CODEX-M41NUL — TTC MAIN CONTROLLER
# Version: 3.0 | © 2026 CODEX-M41NUL
# Developer : Md. Mainul Islam
# GitHub    : https://github.com/M41NUL
# Telegram  : t.me/mdmainulislaminfo
#=======================================

BASE="$HOME/termux-theme-changer"
SHARED="$BASE/shared/prog.sh"
INSTALL_SCRIPT="$BASE/install.sh"
UPDATE_SCRIPT="$BASE/update.sh"
INSTALLED_FLAG="$HOME/.cache/mainul-x/ttc_installed"

# Read version dynamically from version.json — no hardcoding needed
CURRENT_VERSION="unknown"
if [ -f "$BASE/version.json" ]; then
    CURRENT_VERSION=$(grep '"version"' "$BASE/version.json" | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
fi

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
BG_OR=$'\033[48;5;208;30m'
BG_RD=$'\033[41;97m'
BG_CY=$'\033[46;30m'

info()    { printf "  ${CY}[*]${RS} %s\n" "$1"; }
success() { printf "  ${GR}[+]${RS} %s\n" "$1"; }
warn()    { printf "  ${YL}[!]${RS} %s\n" "$1"; }
error()   { printf "  ${RD}[-]${RS} %s\n" "$1"; }
step()    { printf "\n  ${BG_GR} >> ${RS} ${BLD}%s${RS}\n" "$1"; }

# ──────────────────────────────────────
# BANNER
# ──────────────────────────────────────
show_banner() {
    clear
    printf "\n"
    printf "  ${RD} _____ _____ _____${RS}\n"
    printf "  ${OR}|_   _|_   _/ ____|${RS}\n"
    printf "  ${GR}  | |   | || |${RS}     ${W}Termux Theme Changer${RS}\n"
    printf "  ${OR}  | |   | || |___${RS}   ${BG_CY} v${CURRENT_VERSION} ${RS}\n"
    printf "  ${RD}  |_|   |_| \\_____|${RS}\n"
    printf "\n"
    printf "  ${BG_GR} Owner ${RS} ${W}CODEX-M41NUL${RS}   ${BG_CY} Dev ${RS} ${W}M41NUL${RS}\n"
    printf "  ${DIM}github.com/M41NUL${RS}\n"
    printf "\n"
}

# ──────────────────────────────────────
# MAIN MENU
# ──────────────────────────────────────
show_menu() {
    local w inner line sep
    w=$(tput cols 2>/dev/null || echo 44)
    [ "$w" -gt 52 ] && w=52
    [ "$w" -lt 28 ] && w=28
    inner=$(( w - 2 ))
    line=$(printf '%*s' "$inner" '' | tr ' ' '-')
    sep=$(printf '%*s' "$inner" '' | tr ' ' '=')

    _mrow() {
        local txt="$1" color="${2:-$GR}"
        local plain
        plain=$(printf '%s' "$txt" | sed 's/\x1b\[[0-9;]*m//g')
        local plen=${#plain}
        local pad=$(( inner - 2 - plen ))
        [ "$pad" -lt 0 ] && pad=0
        printf "${color}|${RS} %s%*s ${color}|${RS}\n" "$txt" "$pad" ''
    }

    printf "${GR}+%s+${RS}\n" "$line"
    _mrow "  ${W}CONTROL PANEL${RS}"
    printf "${GR}+%s+${RS}\n" "$sep"
    _mrow "  ${BG_GR} 01 ${RS}  Install / Reinstall Theme"
    _mrow "  ${BG_OR} 02 ${RS}  Check for Updates"
    _mrow "  ${BG_GR} 03 ${RS}  Developer Profile"
    _mrow "  ${BG_GR} 04 ${RS}  About This Tool"
    _mrow "  ${BG_RD} 00 ${RS}  Exit"
    printf "${GR}+%s+${RS}\n" "$line"
    printf "\n"
}

# ──────────────────────────────────────
# DEV PROFILE
# ──────────────────────────────────────
dev_info() {
    clear
    show_banner
    printf "  ${BG_CY} DEVELOPER PROFILE ${RS}\n\n"
    printf "  ${DIM}Name    ${RS}: ${W}Md. Mainul Islam${RS}\n"
    printf "  ${DIM}Alias   ${RS}: ${OR}CODEX-M41NUL${RS}\n"
    printf "  ${DIM}GitHub  ${RS}: ${GR}github.com/M41NUL${RS}\n"
    printf "  ${DIM}TG      ${RS}: ${CY}t.me/mdmainulislaminfo${RS}\n"
    printf "  ${DIM}Channel ${RS}: ${CY}t.me/codexm41nul${RS}\n"
    printf "  ${DIM}Group   ${RS}: ${CY}t.me/codex_m41nul${RS}\n"
    printf "  ${DIM}YouTube ${RS}: ${RD}youtube.com/@codexm41nul${RS}\n"
    printf "  ${DIM}WA      ${RS}: ${GR}+8801308850528${RS}\n"
    printf "  ${DIM}Email   ${RS}: ${OR}devmainulislam@gmail.com${RS}\n"
    printf "\n  ${DIM}© 2026 CODEX-M41NUL. All Rights Reserved.${RS}\n\n"
    printf "  ${OR}Press Enter to return...${RS} "
    read -r
}

# ──────────────────────────────────────
# ABOUT
# ──────────────────────────────────────
about_tool() {
    clear
    show_banner
    printf "  ${BG_CY} ABOUT THIS TOOL ${RS}\n\n"
    printf "  ${GR}+${RS} Advanced Termux customization suite\n"
    printf "  ${GR}+${RS} Auto-detects first-time users and runs setup\n"
    printf "  ${GR}+${RS} Version-based update system with skip support\n"
    printf "  ${GR}+${RS} ZSH + Plugins (autocomplete, highlight, fzf)\n"
    printf "  ${GR}+${RS} Custom Nerd Font integration\n"
    printf "  ${GR}+${RS} logo-ls with icons\n"
    printf "  ${GR}+${RS} RXFETCH-style terminal banner\n"
    printf "  ${GR}+${RS} One-click full system restore\n"
    printf "\n"
    printf "  ${DIM}Version${RS} : ${BG_GR} ${CURRENT_VERSION} ${RS}\n"
    printf "  ${DIM}Repo   ${RS} : ${GR}github.com/M41NUL/termux-theme-changer${RS}\n\n"
    printf "  ${OR}Press Enter to return...${RS} "
    read -r
}

# ──────────────────────────────────────
# FIRST-TIME DETECTION
# ──────────────────────────────────────
is_first_time() {
    [ ! -f "$INSTALLED_FLAG" ]
}

handle_first_time() {
    clear
    show_banner
    printf "  ${BG_GR} WELCOME TO TTC! ${RS}\n\n"
    printf "  ${W}Looks like this is your first time running TTC.${RS}\n"
    printf "  ${DIM}Starting theme installation automatically...${RS}\n\n"
    sleep 2
    bash "$INSTALL_SCRIPT"
}

# ──────────────────────────────────────
# ENTRYPOINT
# ──────────────────────────────────────
main() {
    [ -f "$SHARED" ] && source "$SHARED" 2>/dev/null || true

    # First-time user → auto install, skip menu
    if is_first_time; then
        handle_first_time
    fi

    # Run update check on every launch (after first-time install)
    bash "$UPDATE_SCRIPT"

    # Main menu loop
    while true; do
        show_banner
        show_menu
        printf "  ${GR}SELECT${RS} ${DIM}[01-04 / 00]${RS} ${GR}>>${RS} "
        read -r choice

        case "$choice" in
            1|01) bash "$INSTALL_SCRIPT" ;;
            2|02) bash "$UPDATE_SCRIPT" ;;
            3|03) dev_info ;;
            4|04) about_tool ;;
            0|00)
                printf "\n  ${BG_RD} BYE ${RS} Goodbye!\n\n"
                exit 0
                ;;
            *)
                printf "\n  ${BG_RD} ERR ${RS} Invalid option. Try again.\n\n"
                sleep 0.8
                ;;
        esac
    done
}

main
