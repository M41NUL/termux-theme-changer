#!/usr/bin/env bash
#=======================================
# MAINUL-X THEME INSTALLER - I8-FINAL.SH FILE
# Version: 1.0 | (c) 2026 MAINUL - X
# Developer: MAINUL ISLAM 
# GitHub: M41NUL
# Contact: +8801308850528 
#Gmail: githubmainul@gmail.com
#=======================================


printf "\n\n\n"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
GREEN="\033[1;32m"
RESET="\033[0m"

COL1=28
COL2=60
TABLE_WIDTH=$((COL1 + COL2 + 3))

crop() {
  local str="$1"
  local width="$2"
  printf '%-*.*s' "$width" "$width" "$str"
}

print_center_table() {
  local term_width=$(tput cols 2>/dev/null || echo 80)
  local pad=$(( (term_width - TABLE_WIDTH)/2 ))
  (( pad < 0 )) && pad=0

  lines=(
    "┌$(printf '─%.0s' $(seq 1 $COL1))┬$(printf '─%.0s' $(seq 1 $COL2))┐"
    "│$(printf '%-*s' $COL1 " SECTION")│$(printf '%-*s' $COL2 " DESCRIPTION")│"
    "├$(printf '─%.0s' $(seq 1 $COL1))┼$(printf '─%.0s' $(seq 1 $COL2))┤"
    "│$(printf '%-*s' $COL1 " Theme Path")│$(printf '%-*s' $COL2 " $BASE")│"
    "│$(printf '%-*s' $COL1 " Restore Command")│$(printf '%-*s' $COL2 " bash ~/restore.sh")│"
    "│$(printf '%-*s' $COL1 " Apply Changes")│$(printf '%-*s' $COL2 " Close and reopen Termux")│"
    "└$(printf '─%.0s' $(seq 1 $COL1))┴$(printf '─%.0s' $(seq 1 $COL2))┘"
  )
  for line in "${lines[@]}"; do
    printf "%*s%s\n" "$pad" "" "$line"
  done
}

term_width=$(tput cols 2>/dev/null || echo 80)
title="WELCOME TO YOUR NEW TTC THEME"
pad=$(( (term_width - ${#title})/2 ))
printf "%*s${CYAN}%s${RESET}\n\n" "$pad" "" "$title"

print_center_table

footer1="Your Termux is ready with the new TTC theme!"
footer2="Have fun customizing and exploring!"
pad=$(( (term_width - ${#footer1})/2 ))
printf "%*s${GREEN}%s${RESET}\n" "$pad" "" "$footer1"
pad=$(( (term_width - ${#footer2})/2 ))
printf "%*s${GREEN}%s${RESET}\n\n" "$pad" "" "$footer2"
