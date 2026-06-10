#!/usr/bin/env bash
#=======================================
# CODEX-M41NUL - INSTALLER - I8-FINAL.SH
# Version: 2.0 | © 2026 CODEX-M41NUL. All Rights Reserved.
# Developer : Md. Mainul Islam
# GitHub    : https://github.com/M41NUL
# Telegram  : t.me/mdmainulislaminfo
# Channel   : t.me/codexm41nul
#=======================================

CYAN="\033[1;36m"
WHITE="\033[1;37m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

_box_width() {
    local cols
    cols=$(tput cols 2>/dev/null || echo 50)
    [ "$cols" -gt 70 ] && cols=70
    [ "$cols" -lt 30 ] && cols=30
    echo "$cols"
}
box_line() {
    local char="$1" color="${2:-$CYAN}" w inner line
    w=$(_box_width); inner=$(( w - 2 ))
    line=$(printf '%*s' "$inner" '' | tr ' ' "$char")
    printf "${color}+%s+${RESET}\n" "$line"
}
box_row() {
    local text="$1" color="${2:-$CYAN}"
    local w inner plain plen pad
    w=$(_box_width); inner=$(( w - 4 ))
    plain=$(printf '%s' "$text" | sed 's/\x1b\[[0-9;]*m//g')
    plen=${#plain}; pad=$(( inner - plen ))
    [ "$pad" -lt 0 ] && pad=0
    printf "${color}|${RESET} %s%*s ${color}|${RESET}\n" "$text" "$pad" ''
}

printf "\n\n"
box_line "-" "$CYAN"
box_row "       ${GREEN}WELCOME TO YOUR NEW TTC THEME${RESET}" "$CYAN"
box_line "=" "$CYAN"
box_row "  ${YELLOW}> Theme Path  :${RESET} ~/termux-theme-changer" "$CYAN"
box_row "  ${YELLOW}> Restore Cmd :${RESET} bash ~/restore.sh" "$CYAN"
box_row "  ${YELLOW}> Apply Now   :${RESET} Close and reopen Termux" "$CYAN"
box_line "-" "$CYAN"
printf "\n"
echo -e " ${GREEN}Your Termux is ready with the new TTC theme!${RESET}"
echo -e " ${WHITE}Have fun customizing and exploring!${RESET}"
printf "\n\n"
