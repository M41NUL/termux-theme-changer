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

# ── Colors ──
GR=$'\033[1;32m'
RD=$'\033[1;31m'
OR=$'\033[38;5;208m'
W=$'\033[1;37m'
DIM=$'\033[2m'
RS=$'\033[0m'

info()    { printf "${OR}[*]${RS} %s\n" "$1"; }
success() { printf "${GR}[✓]${RS} %s\n" "$1"; }
warn()    { printf "${OR}[!]${RS} %s\n" "$1"; }
error()   { printf "${RD}[✗]${RS} %s\n" "$1"; }
step()    { printf "\n${GR}[→]${RS} ${W}%s${RS}\n" "$1"; }

# ──────────────────────────────────────
# PROGRESS BAR (Termux safe - no \r issue)
# ──────────────────────────────────────
progress_bar() {
    local task="$1"
    local duration="${2:-2}"
    local width=20
    local task_padded
    task_padded=$(printf "%-26s" "${task:0:26}")

    for i in $(seq 0 4 100); do
        local filled=$(( i * width / 100 ))
        local bar
        bar=$(printf "%${filled}s" "" | tr ' ' '#')
        local spa
        spa=$(printf "%$(( width - filled ))s" "" | tr ' ' '-')
        local color="$OR"
        [ "$i" -ge 100 ] && color="$GR"
        printf "\r  %s %s[%s%s]%s %3d%%" \
            "$task_padded" "$color" "$bar" "$spa" "$RS" "$i"
        sleep "$(awk "BEGIN{printf \"%.3f\", $duration/25}")"
    done
    printf "\r  %s ${GR}[%s]${RS} 100%%\n" \
        "$task_padded" "$(printf '%0.s#' $(seq 1 $width))"
}

# ──────────────────────────────────────
# BANNER  (fixed width = 44 inner chars)
# ──────────────────────────────────────
show_banner() {
    clear
    echo ""
    echo -e "${GR}  ╔════════════════════════════════════════╗${RS}"
    echo -e "${GR}  ║${RS}                                        ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${RD} _____ _____ _____${RS}                   ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${OR}|_   _|_   _/ ____|${RS}                  ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${GR}  | |   | || |     ${RS}  ${W}Termux Theme${RS}   ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${OR}  | |   | || |___  ${RS}  ${W}Changer v${CURRENT_VERSION}${RS} ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${RD}  |_|   |_| \_____|${RS}                  ${GR}║${RS}"
    echo -e "${GR}  ║${RS}                                        ${GR}║${RS}"
    echo -e "${GR}  ╠════════════════════════════════════════╣${RS}"
    echo -e "${GR}  ║${RS}  ${DIM}Owner${RS} : ${OR}CODEX-M41NUL${RS}  ${DIM}Dev${RS}: ${W}M41NUL${RS}        ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${DIM}GitHub${RS}: ${GR}github.com/M41NUL${RS}               ${GR}║${RS}"
    echo -e "${GR}  ╚════════════════════════════════════════╝${RS}"
    echo ""
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
        printf "  ${OR}[*]${RS} Installing ${W}%-16s${RS} " "$tool..."
        if pkg install -y "$tool" >/dev/null 2>&1; then
            printf "${GR}[✓] Done${RS}\n"
        else
            printf "${RD}[✗] Failed${RS}\n"
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
        success "Already up to date. (${LOCAL:0:7})"
    else
        info "New update found! Pulling from GitHub..."
        progress_bar "Downloading update" 2
        if git -C "$BASE" pull --quiet origin main 2>/dev/null || \
           git -C "$BASE" pull --quiet origin master 2>/dev/null; then
            success "Updated! (${REMOTE:0:7})"
        else
            warn "Pull failed — check connection."
        fi
    fi

    sleep 0.3
}

# ──────────────────────────────────────
# MENU — 01: THEME INSTALLATION
# ──────────────────────────────────────
run_installer() {
    clear
    echo ""
    echo -e "${GR}  ╔════════════════════════════════════════╗${RS}"
    echo -e "${GR}  ║${RS}     ${GR}STARTING THEME INSTALLATION${RS}         ${GR}║${RS}"
    echo -e "${GR}  ╚════════════════════════════════════════╝${RS}"
    echo ""
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
    printf "${OR}  Press Enter to return to menu...${RS}"
    read -r
}

# ──────────────────────────────────────
# MENU — 02: DEVELOPER PROFILE
# ──────────────────────────────────────
dev_info() {
    clear
    show_banner
    echo -e "${GR}  ╔════════════════════════════════════════╗${RS}"
    echo -e "${GR}  ║${RS}          ${W}DEVELOPER PROFILE${RS}               ${GR}║${RS}"
    echo -e "${GR}  ╠════════════════════════════════════════╣${RS}"
    echo -e "${GR}  ║${RS}  ${DIM}Name    ${RS}: ${W}Md. Mainul Islam${RS}             ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${DIM}Alias   ${RS}: ${OR}CODEX-M41NUL${RS}                 ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${DIM}GitHub  ${RS}: ${GR}github.com/M41NUL${RS}            ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${DIM}TG      ${RS}: ${GR}t.me/mdmainulislaminfo${RS}       ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${DIM}Channel ${RS}: ${GR}t.me/codexm41nul${RS}             ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${DIM}Group   ${RS}: ${GR}t.me/codex_m41nul${RS}            ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${DIM}YouTube ${RS}: ${RD}youtube.com/@codexm41nul${RS}     ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${DIM}WA      ${RS}: ${GR}+8801308850528${RS}               ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${DIM}Email   ${RS}: ${OR}devmainulislam@gmail.com${RS}     ${GR}║${RS}"
    echo -e "${GR}  ╠════════════════════════════════════════╣${RS}"
    echo -e "${GR}  ║${RS}  ${DIM}© 2026 CODEX-M41NUL. All Rights Reserved.${RS}${GR}║${RS}"
    echo -e "${GR}  ╚════════════════════════════════════════╝${RS}"
    echo ""
    printf "${OR}  Press Enter to return...${RS}"
    read -r
}

# ──────────────────────────────────────
# MENU — 03: ABOUT
# ──────────────────────────────────────
about_tool() {
    clear
    show_banner
    echo -e "${GR}  ╔════════════════════════════════════════╗${RS}"
    echo -e "${GR}  ║${RS}          ${W}ABOUT THIS TOOL${RS}                 ${GR}║${RS}"
    echo -e "${GR}  ╠════════════════════════════════════════╣${RS}"
    echo -e "${GR}  ║${RS}  ${OR}▶${RS} Advanced Termux customization suite   ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${OR}▶${RS} Auto-install all required packages    ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${OR}▶${RS} Auto-update from GitHub on every run  ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${OR}▶${RS} ZSH + Plugins (auto, highlight, fzf) ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${OR}▶${RS} Custom Nerd Font integration          ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${OR}▶${RS} logo-ls with icons                    ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${OR}▶${RS} RXFETCH-style terminal banner         ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${OR}▶${RS} One-click full system restore         ${GR}║${RS}"
    echo -e "${GR}  ╠════════════════════════════════════════╣${RS}"
    echo -e "${GR}  ║${RS}  ${DIM}Version${RS} : ${GR}${CURRENT_VERSION}${RS}                          ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${DIM}Repo   ${RS} : ${GR}github.com/M41NUL/ttc${RS}           ${GR}║${RS}"
    echo -e "${GR}  ╚════════════════════════════════════════╝${RS}"
    echo ""
    printf "${OR}  Press Enter to return...${RS}"
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
    printf "${OR}  Press Enter to return...${RS}"
    read -r
}

# ──────────────────────────────────────
# MAIN MENU
# ──────────────────────────────────────
show_menu() {
    echo -e "${GR}  ╔════════════════════════════════════════╗${RS}"
    echo -e "${GR}  ║${RS}           ${W}CONTROL PANEL${RS}                  ${GR}║${RS}"
    echo -e "${GR}  ╠══════╦═════════════════════════════════╣${RS}"
    echo -e "${GR}  ║${RS}  ${GR}01${RS}  ${GR}║${RS}  ${W}Start Theme Installation${RS}           ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${GR}02${RS}  ${GR}║${RS}  ${W}Developer Profile${RS}                  ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${GR}03${RS}  ${GR}║${RS}  ${W}About This Tool${RS}                    ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${OR}04${RS}  ${GR}║${RS}  ${W}Force Update from GitHub${RS}           ${GR}║${RS}"
    echo -e "${GR}  ║${RS}  ${RD}00${RS}  ${GR}║${RS}  ${RD}Exit Application${RS}                   ${GR}║${RS}"
    echo -e "${GR}  ╚══════╩═════════════════════════════════╝${RS}"
    echo ""
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
        printf "  ${GR}SELECT${RS} ${DIM}[01/02/03/04/00]${RS} ${GR}→${RS} "
        read -r choice

        case "$choice" in
            1|01) run_installer ;;
            2|02) dev_info ;;
            3|03) about_tool ;;
            4|04) force_update ;;
            0|00)
                echo ""
                echo -e "  ${RD}Shutting down. Goodbye.${RS}"
                echo ""
                exit 0
                ;;
            *)
                echo -e "\n  ${RD}[!] Invalid option. Try again.${RS}\n"
                sleep 0.8
                ;;
        esac
    done
}

main
