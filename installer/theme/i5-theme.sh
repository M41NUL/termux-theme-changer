#!/usr/bin/env bash
#=======================================
# CODEX-M41NUL - INSTALLER - I5-THEME.SH
# Version: 2.0 | © 2026 CODEX-M41NUL. All Rights Reserved.
# Developer : Md. Mainul Islam
#=======================================

BASE="$HOME/termux-theme-changer"
PLUGINS_DIR="$BASE/plugins"
TERMUX_DIR="$HOME/.termux"
SHARED="$BASE/shared/prog.sh"

if [ -f "$SHARED" ]; then
    source "$SHARED"
fi

command -v info >/dev/null 2>&1 || info() { printf "\e[1;36m[*]\e[0m %s\n" "$1"; }
command -v warn >/dev/null 2>&1 || warn() { printf "\e[1;33m[!]\e[0m %s\n" "$1"; }
command -v success >/dev/null 2>&1 || success() { printf "\e[1;32m[✓]\e[0m %s\n" "$1"; }
command -v progress_bar >/dev/null 2>&1 || progress_bar() { printf "[*] %s\n" "$1"; }

info "Writing colors.properties"
progress_bar "Applying color scheme" 1
mkdir -p "$TERMUX_DIR"
cat > "$TERMUX_DIR/colors.properties" <<'EOF'
color0=#2f343f
color1=#fd6b85
color2=#63e0be
color3=#fed270
color4=#67d4f2
color5=#ff8167
color6=#63e0be
color7=#eeeeee
color8=#4f4f5b
color9=#fd6b85
color10=#63e0be
color11=#fed270
color12=#67d4f2
color13=#ff8167
color14=#63e0be
color15=#eeeeee
background=#2a2c3a
foreground=#eeeeee
cursor=#fd6b85
EOF

info "Writing termux.properties"
progress_bar "Applying terminal configuration" 1
cat > "$TERMUX_DIR/termux.properties" <<'EOF'
allow-external-apps = true
terminal-cursor-blink-rate=600
terminal-cursor-style = underline
EOF

info "Downloading Font..."
progress_bar "Installing custom font" 3
# Updated Font URL
FONT_URL="https://raw.githubusercontent.com/M41NUL/termux-theme-changer/main/Font/font.ttf"

if curl -L --silent --show-error --fail -o "$TERMUX_DIR/font.ttf" "$FONT_URL"; then
    info "Font installed successfully!"
else
    warn "Failed to download font. Please check your internet connection."
fi

# --- Name Input Section ---
echo -e "\n\e[1;36m┌──────────────────────────────────────────┐\e[0m"
echo -e "\e[1;36m│\e[0m \e[1;33mName Setup for Terminal Banner\e[0m           \e[1;36m│\e[0m"
echo -e "\e[1;36m└──────────────────────────────────────────┘\e[0m"
echo -ne "\e[1;32m❯ Enter Your Name (Default: CODEX-M41NUL): \e[0m"
read -r INPUT_NAME

# Set default name to CODEX-M41NUL if empty
FETCH_NAME=${INPUT_NAME:-CODEX-M41NUL}
# Limit to 14 chars to prevent box breaking
FETCH_NAME=$(echo "$FETCH_NAME" | cut -c1-14)
echo -e "\e[1;36m[*] Banner name set to:\e[0m \e[1;35m$FETCH_NAME\e[0m\n"

progress_bar "Generating theme scripts" 2

THEMES_DIR="$BASE/themes"
mkdir -p "$THEMES_DIR"
RXFETCH_SH="$THEMES_DIR/banner.sh"

info "Creating themes banner.sh"

cat > "$RXFETCH_SH" <<EOF
#!/usr/bin/env bash
MY_NAME="$FETCH_NAME"
EOF

cat >> "$RXFETCH_SH" <<'EOF'
magenta="\033[1;35m"; green="\033[1;32m"; white="\033[1;37m"
blue="\033[1;34m"; red="\033[1;31m"; black="\033[1;40;30m"
yellow="\033[1;33m"; cyan="\033[1;36m"; reset="\033[0m"
bgyellow="\033[1;43;33m"; bgwhite="\033[1;47;37m"

c0=${reset}; c1=${magenta}; c2=${green}; c3=${white}; c4=${blue}
c5=${red}; c6=${yellow}; c7=${cyan}; c8=${black}; c9=${bgyellow}; c10=${bgwhite}

# Rainbow Color for Name
COLORS=($c1 $c2 $c7 $c4 $c5 $c6 $c3)
COLORED_NAME=""
for (( i=0; i<${#MY_NAME}; i++ )); do
    CHAR="${MY_NAME:$i:1}"
    COLOR="${COLORS[$((i % 7))]}"
    COLORED_NAME="${COLORED_NAME}${COLOR}${CHAR}"
done
COLORED_NAME="${COLORED_NAME}${c0}"

# Auto spacing to keep box straight (14 is max width)
NAME_LEN=${#MY_NAME}
SPACE_COUNT=$((14 - NAME_LEN))
if [ $SPACE_COUNT -lt 0 ]; then SPACE_COUNT=0; fi
SPACES=$(printf '%*s' "$SPACE_COUNT" '')

# System info
getCodeName(){ codename="$(getprop ro.product.board)"; }
getClientBase(){ client_base="$(getprop ro.com.google.clientidbase)"; }
getModel(){ model="$(getprop ro.product.brand) $(getprop ro.product.model | cut -c1-15)"; }
getDistro(){ os="Android $(getprop ro.build.version.release)"; }
getKernel(){ kernel="$(uname -r | cut -c1-15)"; }
getShell(){ shell=$(basename "$SHELL"); }
getUptime(){ uptime="$(uptime -p | sed 's/up //')"; }
getMemoryUsage(){
    line=$(free -m | grep Mem:)
    total=$(echo $line | awk '{print $2}')
    used=$(echo $line | awk '{print $3}')
    memory="${used}MB / ${total}MB"
}
getDiskUsage(){
    line=$(df -h /data | tail -1)
    size=$(echo $line | awk '{print $2}')
    used=$(echo $line | awk '{print $3}')
    storage="${used} / ${size}"
}

getCodeName; getClientBase; getModel; getDistro; getKernel
getShell; getUptime; getMemoryUsage; getDiskUsage

# Display banner
echo -e "\n"
echo -e "  ┏━━━━━━━━━━━━━━━━━━━━━━┓"
echo -e "  ┃ ${COLORED_NAME}${SPACES}${c5}${c0}  ${c6}${c0}  ${c7}${c0} ┃  ${codename}${c5}@${c0}${client_base}"
echo -e "  ┣━━━━━━━━━━━━━━━━━━━━━━┫"
echo -e "  ┃                      ┃  ${c1}phone${c0}  ${model}"
echo -e "  ┃          ${c3}•${c8}${c3}•${c0}          ┃  ${c2}os${c0}     ${os}"
echo -e "  ┃          ${c8}${c0}${c6}oo${c0}${c8}|${c0}         ┃  ${c7}ker${c0}    ${kernel}"
echo -e "  ┃         ${c8}/${c0}${c3} ${c0}${c8}'\\'${c0}        ┃  ${c5}sh${c0}     ${shell}"
echo -e "  ┃        ${c6}(${c0}${c8}\\_;/${c0}${c6})${c0}        ┃  ${c6}up${c0}     ${uptime}"
echo -e "  ┃                      ┃  ${c1}ram${c0}    ${memory}"
echo -e "  ┃   Powered ${c1}by${c0} Linux   ┃  ${c2}disk${c0}   ${storage}"
echo -e "  ┗━━━━━━━━━━━━━━━━━━━━━━┛  ${c1}━━━${c2}━━━${c3}━━━${c4}━━━${c5}━━━${c6}━━━${c7}━━━"
echo -e "\n"
EOF

chmod +x "$RXFETCH_SH"
info "Theme setup completed by CODEX-M41NUL!"
