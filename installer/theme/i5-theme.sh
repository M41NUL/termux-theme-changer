#!/usr/bin/env bash
#=======================================
# CODEX-M41NUL - INSTALLER - I5-THEME.SH
# Version: 2.0 | © 2026 CODEX-M41NUL. All Rights Reserved.
# Developer : Md. Mainul Islam
# Updated by: AI Helper (Fixed Logo & Removed Battery)
#=======================================

BASE="$HOME/termux-theme-changer"
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
FONT_URL="https://raw.githubusercontent.com/M41NUL/termux-theme-changer/main/Font/font.ttf"

if curl -L --silent --show-error --fail -o "$TERMUX_DIR/font.ttf" "$FONT_URL"; then
    info "Font installed successfully!"
else
    warn "Failed to download font. Please check internet connection."
fi

printf "\n  \033[46;30m Name Setup for Terminal Banner \033[0m\n"
echo -ne "\e[1;32m❯ Enter Your Fetch Name (e.g. mainul-x): \e[0m"
read -r INPUT_NAME

FETCH_NAME=${INPUT_NAME:-mainul-x}
FETCH_NAME=$(echo "$FETCH_NAME" | cut -c1-12)
printf "  \033[1;36m[*]\033[0m Banner name set to: \033[1;35m%s\033[0m\n\n" "$FETCH_NAME"

progress_bar "Generating theme scripts" 2

THEMES_DIR="$BASE/themes"
mkdir -p "$THEMES_DIR"
RXFETCH_SH="$THEMES_DIR/banner.sh"

info "Creating themes/banner.sh"

cat > "$RXFETCH_SH" <<EOF
#!/usr/bin/env bash
FETCH_NAME="$FETCH_NAME"
EOF

cat >> "$RXFETCH_SH" <<'EOF'
c0="\033[0m"
c1="\033[1;35m"
c2="\033[1;32m"
c3="\033[1;37m"
c4="\033[1;34m"
c5="\033[1;31m"
c6="\033[1;33m"
c7="\033[1;36m"
c8="\033[1;30m"

NAME="$FETCH_NAME"
COLORS=("$c1" "$c2" "$c7" "$c4" "$c5" "$c6" "$c7" "$c1" "$c3" "$c5")
COLORED_NAME=""
for (( i=0; i<${#NAME}; i++ )); do
    CHAR="${NAME:$i:1}"
    COLOR="${COLORS[$((i % 10))]}"
    COLORED_NAME="${COLORED_NAME}${COLOR}${CHAR}"
done
COLORED_NAME="${COLORED_NAME}${c0}"

NAME_LEN=${#NAME}
SPACE_LEN=$(( 12 - NAME_LEN ))
[ "$SPACE_LEN" -lt 1 ] && SPACE_LEN=1
SPACES=$(printf '%*s' "$SPACE_LEN" '')

USER=$(whoami 2>/dev/null || echo "user")
HOST=$(getprop ro.product.board 2>/dev/null || echo "android")
BRAND=$(getprop ro.product.brand 2>/dev/null)
MODEL_RAW=$(getprop ro.product.model 2>/dev/null)
MODEL=$(echo "$BRAND $MODEL_RAW" | awk '{$1=$1;print}' | cut -c1-20)
OS="Android $(getprop ro.build.version.release 2>/dev/null)"
KERNEL=$(uname -r 2>/dev/null | cut -c1-20)
SHELL_NAME=$(basename "$SHELL")
UPTIME=$(uptime -p 2>/dev/null | sed 's/up //' | cut -c1-20)
PKGS=$(pkg list-installed 2>/dev/null | wc -l)

# RAM & Disk Info
line_mem=$(free -m 2>/dev/null | grep Mem:)
RAM=$(echo $line_mem | awk '{print $3"MB / "$2"MB"}')
line_disk=$(df -h /data 2>/dev/null | tail -1)
DISK=$(echo $line_disk | awk '{print $3" / "$2" ("$5")"}')

if [ -f "/system/bin/su" ] || [ -f "/system/xbin/su" ]; then
    DEVICE_STATUS="${c2}Rooted${c0}"
else
    DEVICE_STATUS="${c7}Standard${c0}"
fi

echo -e "\n"
echo -e "  ┏━━━━━━━━━━━━━━━━━━━━━━┓"
echo -e "  ┃ ${COLORED_NAME}${SPACES}  ${c5}●${c0} ${c6}●${c0} ${c7}●${c0} ┃  ${c3}${USER}${c5}@${c0}${c3}${HOST}${c0}"
echo -e "  ┣━━━━━━━━━━━━━━━━━━━━━━┫"
echo -e "  ┃                      ┃  ${c1}  phone${c0} : ${MODEL}"
echo -e "  ┃         ${c3}●   ●${c0}        ┃  ${c2}     os${c0} : ${OS}"
echo -e "  ┃           ${c8}━${c0}          ┃  ${c7}    ker${c0} : ${KERNEL}"
echo -e "  ┃          ${c6}█${c8}  ┃${c0}        ┃  ${c4} device${c0} : ${DEVICE_STATUS}"
echo -e "  ┃        ${c3}█${c8}  / \\${c0}        ┃  ${c5}     sh${c0} : ${SHELL_NAME}"
echo -e "  ┃      ${c6}█${c8} \\_ ; / ${c6}█${c0}      ┃  ${c6}     up${c0} : ${UPTIME}"
echo -e "  ┃                      ┃  ${c1}    ram${c0} : ${RAM}"
echo -e "  ┃  android ${c5}♥${c0} termux   ┃  ${c2}   disk${c0} : ${DISK}"
echo -e "  ┃                      ┃  ${c7}   pkgs${c0} : ${PKGS}"
echo -e "  ┗━━━━━━━━━━━━━━━━━━━━━━┛  ${c1}━━${c2}━━${c3}━━${c4}━━${c5}━━${c6}━━${c7}━━${c1}━━${c2}━━"
echo -e "\n"
EOF

chmod +x "$RXFETCH_SH"
success "Theme setup completed successfully!"
