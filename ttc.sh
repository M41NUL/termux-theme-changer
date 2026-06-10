#!/usr/bin/env bash
#=======================================
# CODEX-M41NUL TTC - MAIN CONTROLLER
# Version: 2.0 | © 2026 CODEX-M41NUL. All Rights Reserved.
# Developer  : Md. Mainul Islam
# GitHub     : https://github.com/M41NUL
# Telegram   : t.me/mdmainulislaminfo
#=======================================

BASE="$HOME/termux-theme-changer"
SHARED="$BASE/shared/prog.sh"
INSTALLER_DIR="$BASE/installer"
REPO_URL="https://github.com/M41NUL/termux-theme-changer.git"
CURRENT_VERSION="2.0.0"

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

progress_bar() {
    local task="$1"
    local duration="${2:-2}"
    local width=20
    local task_padded
    task_padded=$(printf "%-26s" "${task:0:26}")
    printf "\n"
    for i in $(seq 0 5 100); do
        local filled=$(( i * width / 100 ))
        local empty=$(( width - filled ))
        local bar="" spa=""
        [ "$filled" -gt 0 ] && bar=$(printf '%0.s█' $(seq 1 $filled))
        [ "$empty"  -gt 0 ] && spa=$(printf '%0.s░' $(seq 1 $empty))
        local color="$OR"
        [ "$i" -ge 100 ] && color="$GR"
        printf "\r  %s ${color}[%s%s${DIM}%s${RS}${color}]${RS} %3d%%" \
            "$task_padded" "$color" "$bar" "$spa" "$i"
        sleep "$(awk "BEGIN{printf \"%.3f\", $duration/20}")"
    done
    printf "\r  %s ${GR}[$(printf '%0.s█' $(seq 1 20))]${RS} ${BG_GR} 100%% COMPLETE ${RS}\n\n"
}

# ──────────────────────────────────────
# BANNER
# ──────────────────────────────────────
show_banner() {
    clear
    local cols
    cols=$(tput cols 2>/dev/null || echo 40)
    [ "$cols" -gt 60 ] && cols=60

    printf "\n"
    # TTC ASCII art — colored, no box
    printf "  ${RD} _____ _____ _____${RS}\n"
    printf "  ${OR}|_   _|_   _/ ____|${RS}\n"
    printf "  ${GR}  | |   | || |${RS}     ${W}Termux Theme Changer${RS}\n"
    printf "  ${OR}  | |   | || |___${RS}   ${BG_CY} v${CURRENT_VERSION} ${RS}\n"
    printf "  ${RD}  |_|   |_| \_____|${RS}\n"
    printf "\n"
    # Highlighted owner line
    printf "  ${BG_GR} Owner ${RS} ${W}CODEX-M41NUL${RS}   ${BG_CY} Dev ${RS} ${W}M41NUL${RS}\n"
    printf "  ${DIM}github.com/M41NUL${RS}\n"
    printf "\n"
}

# ──────────────────────────────────────
# AUTO INSTALL
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

    warn "Missing: ${missing[*]}"
    apt update -qq >/dev/null 2>&1 || true

    for tool in "${missing[@]}"; do
        printf "  ${CY}[*]${RS} Installing ${BLD}%-14s${RS} " "$tool..."
        if pkg install -y "$tool" >/dev/null 2>&1; then
            printf "${BG_GR} DONE ${RS}\n"
        else
            printf "${BG_RD} FAIL ${RS}\n"
        fi
    done
    success "All tools ready."
    sleep 0.5
}

# ──────────────────────────────────────
# AUTO UPDATE
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
        success "Already up to date. ${DIM}(${LOCAL:0:7})${RS}"
    else
        info "New update found! Pulling from GitHub..."
        progress_bar "Downloading update" 2
        if git -C "$BASE" pull --quiet origin main 2>/dev/null || \
           git -C "$BASE" pull --quiet origin master 2>/dev/null; then
            success "Updated! ${DIM}(${REMOTE:0:7})${RS}"
        else
            warn "Pull failed — check connection."
        fi
    fi
    sleep 0.3
}

# ──────────────────────────────────────
# THEME INSTALL
# ──────────────────────────────────────
run_installer() {
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

    for script in "${SCRIPTS[@]}"; do
        local spath="$INSTALLER_DIR/$script"
        if [ -f "$spath" ]; then
            bash "$spath"
        else
            warn "Script not found: $spath"
        fi
    done

    printf "\n  ${OR}Press Enter to return to menu...${RS} "
    read -r
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
    printf "  ${GR}+${RS} Auto-install all required packages\n"
    printf "  ${GR}+${RS} Auto-update from GitHub on every run\n"
    printf "  ${GR}+${RS} ZSH + Plugins (auto, highlight, fzf)\n"
    printf "  ${GR}+${RS} Custom Nerd Font integration\n"
    printf "  ${GR}+${RS} logo-ls with icons\n"
    printf "  ${GR}+${RS} RXFETCH-style terminal banner\n"
    printf "  ${GR}+${RS} One-click full system restore\n"
    printf "\n"
    printf "  ${DIM}Version${RS} : ${BG_GR} ${CURRENT_VERSION} ${RS}\n"
    printf "  ${DIM}Repo   ${RS} : ${GR}github.com/M41NUL/ttc${RS}\n\n"
    printf "  ${OR}Press Enter to return...${RS} "
    read -r
}

# ──────────────────────────────────────
# FORCE UPDATE
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
    printf "\n  ${OR}Press Enter to return...${RS} "
    read -r
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
    _mrow "  ${BG_GR} 01 ${RS}  Start Theme Installation"
    _mrow "  ${GR}|${RS}  ${BG_GR} 02 ${RS}  Developer Profile"
    _mrow "  ${GR}|${RS}  ${BG_GR} 03 ${RS}  About This Tool"
    _mrow "  ${GR}|${RS}  ${BG_OR} 04 ${RS}  Force Update from GitHub"
    _mrow "  ${GR}|${RS}  ${BG_RD} 00 ${RS}  Exit Application"
    printf "${GR}+%s+${RS}\n" "$line"
    printf "\n"
}

# ──────────────────────────────────────
# ENTRYPOINT
# ──────────────────────────────────────
main() {
    [ -f "$SHARED" ] && source "$SHARED" 2>/dev/null || true

    auto_install_deps
    auto_update

    while true; do
        show_banner
        show_menu
        printf "  ${GR}SELECT${RS} ${DIM}[01-04 / 00]${RS} ${GR}>>${RS} "
        read -r choice

        case "$choice" in
            1|01) run_installer ;;
            2|02) dev_info ;;
            3|03) about_tool ;;
            4|04) force_update ;;
            0|00)
                printf "\n  ${BG_RD} BYE ${RS} Shutting down. Goodbye.\n\n"
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
