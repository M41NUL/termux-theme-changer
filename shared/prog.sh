#!/usr/bin/env bash
#=======================================
# CODEX-M41NUL - SHARED / PROG.SH
# Version: 2.0 | © 2026 CODEX-M41NUL. All Rights Reserved.
# Developer : Md. Mainul Islam
# GitHub    : https://github.com/M41NUL
# Telegram  : t.me/mdmainulislaminfo
# Channel   : t.me/codexm41nul
#=======================================

GR=$'\033[1;32m'
RD=$'\033[1;31m'
OR=$'\033[38;5;208m'
W=$'\033[1;37m'
DIM=$'\033[2m'
RS=$'\033[0m'

info()    { printf "${OR}[*]${RS} %s\n" "$1"; }
warn()    { printf "${OR}[!]${RS} %s\n" "$1"; }
success() { printf "${GR}[✓]${RS} %s\n" "$1"; }
error()   { printf "${RD}[✗]${RS} %s\n" "$1"; }
step()    { printf "\n${GR}[→]${RS} ${W}%s${RS}\n" "$1"; }

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
