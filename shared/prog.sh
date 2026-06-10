#!/usr/bin/env bash
#=======================================
# CODEX-M41NUL - SHARED / PROG.SH
# Version: 2.0 | © 2026 CODEX-M41NUL. All Rights Reserved.
# Developer : Md. Mainul Islam
# GitHub    : https://github.com/M41NUL
# Telegram  : t.me/mdmainulislaminfo
# Channel   : t.me/codexm41nul
#=======================================

R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
B='\033[1;34m'
M='\033[1;35m'
C='\033[1;36m'
W='\033[1;37m'
DIM='\033[2m'
RESET='\033[0m'

info()    { printf "${C}[*]${RESET} %s\n" "$1"; }
warn()    { printf "${Y}[!]${RESET} %s\n" "$1"; }
success() { printf "${G}[✓]${RESET} %s\n" "$1"; }
error()   { printf "${R}[✗]${RESET} %s\n" "$1"; }
step()    { printf "\n${M}[→]${RESET} ${W}%s${RESET}\n" "$1"; }

progress_bar() {
    local task="$1"
    local duration="${2:-2}"
    local width=20
    local char="█"
    local empty="░"
    local task_padded
    task_padded=$(printf "%-28s" "${task:0:28}")

    for i in $(seq 0 100); do
        local filled=$((i * width / 100))
        local bar=""
        local spa=""
        for _ in $(seq 1 $filled 2>/dev/null); do bar="${bar}${char}"; done 2>/dev/null
        for _ in $(seq 1 $((width - filled)) 2>/dev/null); do spa="${spa}${empty}"; done 2>/dev/null
        # simpler fallback
        bar=$(printf "%${filled}s" | tr ' ' "$char")
        spa=$(printf "%$((width - filled))s" | tr ' ' "$empty")
        local color="$Y"
        (( i == 100 )) && color="$G"
        printf "\r  ${DIM}%s${RESET} ${color}[%s%s]${RESET} ${W}%3d%%${RESET}" \
            "$task_padded" "$bar" "$spa" "$i"
        sleep "$(awk "BEGIN{print $duration/100}")"
    done
    echo
}
