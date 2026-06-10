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
success() { printf "${GR}[+]${RS} %s\n" "$1"; }
error()   { printf "${RD}[-]${RS} %s\n" "$1"; }
step()    { printf "\n${GR}[>]${RS} ${W}%s${RS}\n" "$1"; }

# ── Auto-size box helpers ──
_box_width() {
    local cols
    cols=$(tput cols 2>/dev/null || echo 50)
    [ "$cols" -gt 70 ] && cols=70
    [ "$cols" -lt 30 ] && cols=30
    echo "$cols"
}

box_top() {
    local color="${1:-$GR}" w
    w=$(_box_width)
    local inner=$(( w - 2 ))
    local line
    line=$(printf '%*s' "$inner" '' | tr ' ' '-')
    printf "${color}+%s+${RS}\n" "$line"
}

box_div() {
    local color="${1:-$GR}" w
    w=$(_box_width)
    local inner=$(( w - 2 ))
    local line
    line=$(printf '%*s' "$inner" '' | tr ' ' '=')
    printf "${color}+%s+${RS}\n" "$line"
}

box_bot() {
    local color="${1:-$GR}" w
    w=$(_box_width)
    local inner=$(( w - 2 ))
    local line
    line=$(printf '%*s' "$inner" '' | tr ' ' '-')
    printf "${color}+%s+${RS}\n" "$line"
}

# box_row "text" [color] [align: l|c|r]
box_row() {
    local text="$1"
    local color="${2:-$GR}"
    local align="${3:-l}"
    local w
    w=$(_box_width)
    local inner=$(( w - 4 ))   # 2 border + 2 space padding

    # strip ANSI for length calc
    local plain
    plain=$(printf '%s' "$text" | sed 's/\x1b\[[0-9;]*m//g')
    local plen=${#plain}
    local pad=$(( inner - plen ))
    [ "$pad" -lt 0 ] && pad=0

    local lpad=0 rpad=0
    case "$align" in
        c) lpad=$(( pad / 2 )); rpad=$(( pad - lpad )) ;;
        r) lpad=$pad; rpad=0 ;;
        *) lpad=0; rpad=$pad ;;
    esac

    printf "${color}|${RS} "
    printf '%*s' "$lpad" ''
    printf '%s' "$text"
    printf '%*s' "$rpad" ''
    printf " ${color}|${RS}\n"
}

box_empty() {
    local color="${1:-$GR}" w
    w=$(_box_width)
    local inner=$(( w - 2 ))
    printf "${color}|${RS}%*s${color}|${RS}\n" "$inner" ''
}

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
