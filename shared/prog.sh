#!/usr/bin/env bash
#=======================================
# CODEX-M41NUL - SHARED / PROG.SH
# Version: 2.1 | © 2026 CODEX-M41NUL. All Rights Reserved.
#=======================================

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
BG_YL=$'\033[43;30m'

info()    { printf "  ${CY}[*]${RS} %s\n" "$1"; }
warn()    { printf "  ${YL}[!]${RS} %s\n" "$1"; }
success() { printf "  ${GR}[+]${RS} %s\n" "$1"; }
error()   { printf "  ${RD}[-]${RS} %s\n" "$1"; }
step()    { printf "\n  ${BG_GR} >> ${RS} ${BLD}%s${RS}\n" "$1"; }

progress_bar() {
    local task="$1"
    local duration="${2:-2}"
    local width=25
    local char="█"
    local empty_char="░"
    local term_width=$(tput cols)
    local task_display="${task:0:30}"

    printf "\n"
    for i in $(seq 0 2 100); do
        local filled=$(( i * width / 100 ))
        local empty=$(( width - filled ))
        local bar=$(printf "%0.s$char" $(seq 1 $filled 2>/dev/null))
        local space=$(printf "%0.s$empty_char" $(seq 1 $empty 2>/dev/null))
        local color="$OR"
        [ "$i" -eq 100 ] && color="$GR"
        local prog_text="${color}[$bar$RS$DIM$space$RS${color}] $i%${RS}"
        local pad=$((term_width - ${#task_display} - width - 15))
        ((pad < 1)) && pad=1
        local padding=$(printf "%*s" "$pad" "")
        printf "\r  ${CY}[*]${RS} %s%s%s" "$task_display" "$padding" "$prog_text"
        sleep "$(awk "BEGIN {print $duration/50}")"
    done
    printf "\r  ${CY}[*]${RS} %s%s${BG_GR} 100%% COMPLETE ${RS}\n\n" "$task_display" "$padding"
}
