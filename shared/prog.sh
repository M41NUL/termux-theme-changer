#!/usr/bin/env bash
#=======================================
# CODEX-M41NUL - SHARED / PROG.SH
# Version: 2.0 | © 2026 CODEX-M41NUL. All Rights Reserved.
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

# ── Reverse (text on colored bg) ──
BG_GR=$'\033[42;30m'   # green bg black text
BG_OR=$'\033[48;5;208;30m'
BG_RD=$'\033[41;97m'
BG_CY=$'\033[46;30m'
BG_YL=$'\033[43;30m'

info()    { printf "  ${CY}[*]${RS} %s\n" "$1"; }
warn()    { printf "  ${YL}[!]${RS} %s\n" "$1"; }
success() { printf "  ${GR}[+]${RS} %s\n" "$1"; }
error()   { printf "  ${RD}[-]${RS} %s\n" "$1"; }
step()    { printf "\n  ${BG_GR} >> ${RS} ${BLD}%s${RS}\n" "$1"; }

# ──────────────────────────────────────
# PROGRESS BAR  ╭─╮ style with █
# ──────────────────────────────────────
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
