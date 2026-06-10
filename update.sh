#!/usr/bin/env bash
#=======================================
# CODEX-M41NUL — TTC UPDATE CHECKER
# Version: 3.0 | © 2026 CODEX-M41NUL
# Developer : Md. Mainul Islam
# GitHub    : https://github.com/M41NUL
# Telegram  : t.me/mdmainulislaminfo
#=======================================

BASE="$HOME/termux-theme-changer"
CACHE_DIR="$HOME/.cache/mainul-x"
SKIP_FILE="$CACHE_DIR/ttc_skip_version"
VERSION_URL="https://raw.githubusercontent.com/M41NUL/termux-theme-changer/main/version.json"

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

info()    { printf "  ${CY}[*]${RS} %s\n" "$1"; }
success() { printf "  ${GR}[+]${RS} %s\n" "$1"; }
warn()    { printf "  ${YL}[!]${RS} %s\n" "$1"; }
error()   { printf "  ${RD}[-]${RS} %s\n" "$1"; }

progress_bar() {
    local task="$1" duration="${2:-2}" width=20
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

# ── Parse version from version.json (no jq needed) ──
_parse_field() {
    local json="$1" key="$2"
    echo "$json" | grep "\"$key\"" | sed 's/.*"'"$key"'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/'
}

# ──────────────────────────────────────
# MAIN UPDATE CHECK
# ──────────────────────────────────────
run_update_check() {
    # Read current local version
    local LOCAL_VERSION="unknown"
    if [ -f "$BASE/version.json" ]; then
        LOCAL_VERSION=$(_parse_field "$(cat "$BASE/version.json")" "version")
    fi

    info "Checking for updates..."

    # Fetch remote version.json
    local REMOTE_JSON
    REMOTE_JSON=$(curl -sf --max-time 5 "$VERSION_URL" 2>/dev/null)

    if [ -z "$REMOTE_JSON" ]; then
        warn "No internet connection — skipping update check."
        sleep 0.5
        return
    fi

    local REMOTE_VERSION REMOTE_MESSAGE
    REMOTE_VERSION=$(_parse_field "$REMOTE_JSON" "version")
    REMOTE_MESSAGE=$(_parse_field "$REMOTE_JSON" "message")

    if [ -z "$REMOTE_VERSION" ]; then
        warn "Could not parse remote version — skipping."
        sleep 0.5
        return
    fi

    # Already up to date
    if [ "$LOCAL_VERSION" = "$REMOTE_VERSION" ]; then
        success "Already up to date. ${DIM}(v${LOCAL_VERSION})${RS}"
        sleep 0.4
        return
    fi

    # Check if user already skipped this version
    mkdir -p "$CACHE_DIR"
    if [ -f "$SKIP_FILE" ] && grep -qx "$REMOTE_VERSION" "$SKIP_FILE" 2>/dev/null; then
        warn "Update available ${DIM}(v${LOCAL_VERSION} → v${REMOTE_VERSION})${RS} — skipped by user."
        sleep 0.4
        return
    fi

    # ── Show update notice ──
    printf "\n"
    printf "  ${BG_OR} UPDATE AVAILABLE ${RS}\n"
    printf "  ${DIM}Current${RS}  :  ${W}v%s${RS}\n" "$LOCAL_VERSION"
    printf "  ${DIM}Latest${RS}   :  ${GR}v%s${RS}\n" "$REMOTE_VERSION"
    printf "  ${DIM}What's new${RS}: %s\n" "$REMOTE_MESSAGE"
    printf "\n"
    printf "  ${OR}Update now?${RS} ${DIM}[y = yes / n = skip once / s = skip this version]${RS}\n"
    printf "  ${GR}>>${RS} "
    read -r answer

    case "$answer" in
        y|Y)
            progress_bar "Downloading update" 3
            if git -C "$BASE" pull --quiet origin main 2>/dev/null || \
               git -C "$BASE" pull --quiet origin master 2>/dev/null; then
                success "Updated to v${REMOTE_VERSION}!"
                # Remove skip entry for this version if it existed
                [ -f "$SKIP_FILE" ] && sed -i "/^${REMOTE_VERSION}$/d" "$SKIP_FILE"
            else
                warn "Update failed — check your internet connection."
            fi
            ;;
        s|S)
            # Skip permanently for this version
            echo "$REMOTE_VERSION" >> "$SKIP_FILE"
            warn "Version v${REMOTE_VERSION} skipped. You will not be reminded again for this version."
            ;;
        *)
            warn "Update skipped. You will be reminded next time."
            ;;
    esac
    sleep 0.4
}

# Allow running standalone: bash update.sh
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_update_check
fi
