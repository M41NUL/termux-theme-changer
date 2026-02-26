#!/usr/bin/env bash
#=======================================
# MAINUL-X THEME INSTALLER - I1-ENV.SH FILE
# Version: 1.0 | (c) 2026 MAINUL - X
# Developer: MAINUL ISLAM 
# GitHub: M41NUL
# Contact: +8801308850528 
#Gmail: githubmainul@gmail.com
#=======================================


BASE="$HOME/termux-theme-changer"
LOG_DIR="$HOME/.cache/mainul-x"
FIGLET_LOG="$LOG_DIR/figlet.log"

mkdir -p "$LOG_DIR"
rm -f "$FIGLET_LOG"
clear

echo -n "Checking system"
( pkg install -y figlet >"$FIGLET_LOG" 2>&1 ) & pid=$!

while kill -0 "$pid" 2>/dev/null; do
    echo -n "."
    sleep 0.5
done
wait "$pid"
rc=$?

clear
if [ $rc -eq 0 ]; then
    RED="\033[1;31m"
    GREEN="\033[1;32m"
    YELLOW="\033[1;33m"
    BLUE="\033[1;34m"
    MAGENTA="\033[1;35m"
    CYAN="\033[1;36m"
    RESET="\033[0m"
    cols=$(tput cols)

    figlet -f slant "TTC" | \
    awk -v width="$cols" -v r="$RED" -v g="$GREEN" -v y="$YELLOW" \
        -v b="$BLUE" -v m="$MAGENTA" -v c="$CYAN" -v reset="$RESET" \
    '{
        colors[1]=r; colors[2]=g; colors[3]=y;
        colors[4]=b; colors[5]=m; colors[6]=c;
        color=colors[(NR-1)%6+1];
        len=length($0);
        pad=int((width-len)/2);
        printf "%s%*s%s%s\n", color, pad, "", $0, reset;
    }'
else
    echo -e "\033[1;33m[WARN] Installation failed. Check $FIGLET_LOG\033[0m"
fi

printf "\n\n"
