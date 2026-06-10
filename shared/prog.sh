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

    for i in $(seq 0 5 100); do
        local filled=$(( i * width / 100 ))
        local empty=$(( width - filled ))
        local bar
        bar=$(printf '%0.s█' $(seq 1 $filled) 2>/dev/null)
        local spa
        spa=$(printf '%0.s░' $(seq 1 $empty) 2>/dev/null)
        local color="$OR"
        [ "$i" -ge 100 ] && color="$GR"

        # Top line
        local top_fill=$(( filled + 2 ))
        local top_empty=$(( empty + 2 ))
        # Progress line
        printf "\033[2A"   2>/dev/null || true

        local label_pad=24
        local task_trim="${task:0:$label_pad}"
        local tlen=${#task_trim}
        local tpad=$(( label_pad - tlen ))

        printf "  ${DIM}%-${label_pad}s${RS}  ${color}╭%s%s╮${RS}\n" \
            "$task_trim" "$(printf '%0.s─' $(seq 1 $(( width + 2 ))))" ""
        printf "  ${W}Progress:${RS} ${color}%3d%%${RS}  ${color}│${RS} %s%s ${color}│${RS}\n" \
            "$i" "${color}${bar}${RS}" "${DIM}${spa}${RS}"

        sleep "$(awk "BEGIN{printf \"%.3f\", $duration/20}")"
    done

    # Final render
    printf "\033[2A" 2>/dev/null || true
    printf "  ${DIM}%-24s${RS}  ${GR}╭%s╮${RS}\n" \
        "${task:0:24}" "$(printf '%0.s─' $(seq 1 22))"
    printf "  ${W}Progress:${RS} ${GR}100%%${RS}  ${GR}│${RS} $(printf '%0.s█' $(seq 1 20)) ${GR}│${RS}  ${BG_GR} DONE ${RS}\n"
    sleep 0.2
    printf "\n"
}
