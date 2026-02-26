#!/usr/bin/env bash
#=======================================
# MAINUL-X THEME INSTALLER - PROG.SH FILE
# Version: 1.0 | (c) 2026 MAINUL - X
# Developer: MAINUL ISLAM 
# GitHub: M41NUL
# Contact: +8801308850528 
#Gmail: githubmainul@gmail.com
#=======================================


info() { printf "\e[1;36m[*]\e[0m %s\n" "$1"; }
warn() { printf "\e[1;33m[!]\e[0m %s\n" "$1"; }
success() { printf "\e[1;32m[✓]\e[0m %s\n" "$1"; }

progress_bar() {
    local task="$1"
    local duration="${2:-2}"
    local width=15
    local char="█"

    local YELLOW=$'\033[1;33m'
    local GREEN=$'\033[1;32m'
    local RESET=$'\033[0m'

    # লাইন যেন ছোট বড় না হয় তাই স্পেস ফিক্স করা হলো
    local task_padded=$(printf "%-25s" "${task:0:25}")

    for i in $(seq 0 100); do
        local step=$((i * width / 100))
        local bar=$(printf "%0.s$char" $(seq 1 $step))
        local space=$(printf "%0.s " $(seq 1 $((width - step))))
        local color="$YELLOW"
        (( i == 100 )) && color="$GREEN"

        printf "\r[*] %s %s[%s] %3d%%%s" "$task_padded" "$color" "$bar$space" "$i" "$RESET"
        sleep "$(awk "BEGIN {print $duration/100}")"
    done
    echo
}
