 <p align="center">
  <img src="https://raw.githubusercontent.com/M41NUL/termux-theme-changer/main/img/Termux-Customization.png" alt="Termux Customization" width="900">
</p>
<p align="center">
  <img src="https://img.shields.io/github/stars/M41NUL/termux-theme-changer?style=flat&logo=github" alt="Stars">
  <img src="https://img.shields.io/github/forks/M41NUL/termux-theme-changer?style=flat&logo=github" alt="Forks">
  <img src="https://img.shields.io/badge/ZSH-Shell-339933?style=flat&logo=gnu&logoColor=white" alt="zsh">
  <img src="https://img.shields.io/badge/Bash-5.2-339933?style=flat&logo=gnu-bash&logoColor=white" alt="bash">
</p>

## Overview

**Termux Theme Changer (TTC)** is a fully automated, pure-shell Termux customization suite. One command installs everything — dependencies, ZSH plugins, custom fonts, a personalized ASCII banner, and a themed color palette. It auto-detects first-time users and runs setup automatically, and checks for version updates on every launch.

<br>

## Features

- **Pure shell** — no Python required, runs entirely in Bash/ZSH.
- **Auto-install** — missing tools (`git`, `zsh`, `figlet`, `fzf`, etc.) are installed automatically on first run.
- **First-time detection** — automatically starts theme installation for new users, no extra steps needed.
- **Version-based update system** — checks `version.json` on GitHub on every launch and notifies you when a new version is available.
- **Flexible update prompt** — choose to update now, skip once, or skip this version entirely.
- **Modular structure** — main controller, installer, and updater are separate files for easier maintenance.
- **Auto-size UI** — all boxes auto-fit to your terminal width.
- Fully customized ZSH prompt with colors and modern aesthetics.
- ZSH plugins: autosuggestions, syntax-highlighting, autocomplete, fzf, bgnotify.
- `logo-ls` integration for a modern `ls` experience with icons.
- Custom Nerd Font + `termux.properties` configuration.
- Personalized RXFETCH-style terminal banner with your name.
- Restore script to safely revert Termux to its default state.

<br>

## Installation

> One-time setup — clones the repo and creates the `ttc` command globally.

**Step 1 — Clone the repo**

```bash
apt update && apt upgrade -y
pkg install git -y
git clone https://github.com/M41NUL/termux-theme-changer.git
cd termux-theme-changer
```

**Step 2 — Run setup**

```bash
bash setup.sh
```

The setup will:

- Install any missing required tools automatically
- Set up ZSH plugins, Nerd Font, and color theme
- Create the `ttc` global command
- Auto-launch TTC after setup completes

**Step 3 — Run anytime after install**

```bash
ttc
```

**Re-install / Update manually**

```bash
cd termux-theme-changer
bash setup.sh
```

> **Recommended:** Run on a fresh Termux installation for best results.

<br>

## Uninstall

**Remove TTC folder:**

```bash
rm -rf ~/termux-theme-changer
```

**Remove the `ttc` global command:**

```bash
rm -f $PREFIX/bin/ttc
```

**Remove ZSH config (optional):**

```bash
rm -f ~/.zshrc ~/.zsh_history ~/.profile
```

**Or use the built-in restore script to reset everything:**

```bash
bash ~/restore.sh
```

<br>

## Commands

| Command | Description |
|---------|-------------|
| `ttc` | Launch TTC main menu |
| `bash setup.sh` | Install or re-install TTC |
| `bash ~/restore.sh` | Restore Termux to default clean state |

<br>

## Menu Options

| Option | Action |
|--------|--------|
| `01` | Install / Reinstall theme |
| `02` | Check for updates |
| `03` | View developer profile & contacts |
| `04` | About this tool & version info |
| `00` | Exit TTC |

<br>

## Update System

Every time `ttc` launches, it fetches `version.json` from GitHub and compares it with the local version.

| Response | What happens |
|----------|-------------|
| `y` | Downloads and applies the latest update |
| `n` | Skips this time — you will be reminded on next run |
| `s` | Skips this version permanently — no more reminders for it |

To release a new update, only `version.json` needs to be changed:

```json
{
  "version": "2.0.0",
  "message": "Added new features and improvements."
}
```
<br>

## Auto-Install

On every `ttc` launch, these packages are checked and installed if missing:

```
git   curl   zsh   figlet   fzf   neofetch
```

No user input needed — all done automatically.

<br>

## ZSH Aliases (added automatically)

| Alias | Command | Description |
|-------|---------|-------------|
| `c` | `clear` | Clear terminal |
| `q` | `exit` | Exit session |
| `sd` | `cd /sdcard` | Go to internal storage |
| `dl` | `cd /sdcard/Download` | Go to Downloads folder |
| `neo` | `neofetch` | Show system info |
| `ls` | `logo-ls` | List with icons |
| `ll` | `logo-ls -l` | Detailed list with icons |
| `pacupg` | `pkg upgrade` | Upgrade all packages |
| `pacupd` | `pkg update` | Update package lists |

<br>

## ZSH Plugins Installed

| Plugin | Description |
|--------|-------------|
| `zsh-autosuggestions` | Fish-like command suggestions |
| `zsh-syntax-highlighting` | Real-time syntax coloring |
| `zsh-autocomplete` | Live completion menu |
| `zsh-fzf-history-search` | Fuzzy history search with fzf |
| `bgnotify` | Background task notifications |

<br>

## File Structure

```
termux-theme-changer/
├── ttc.sh                    # Main controller & menu
├── install.sh                # Theme installer (modular)
├── update.sh                 # Version check & update logic
├── setup.sh                  # One-time repo setup
├── version.json              # Current version info (checked on every launch)
├── shared/
│   └── prog.sh               # Shared colors, progress bar, helpers
├── installer/
│   ├── env/i1-env.sh         # figlet + TTC ASCII display
│   ├── core/i2-core.sh       # Core packages (bash, curl, git, zsh)
│   ├── extra/i3-extra.sh     # logo-ls build & aliases
│   ├── plugins/i4-plugins.sh # ZSH plugins clone
│   ├── theme/i5-theme.sh     # Colors, font, termux.properties, banner
│   ├── shell/i6-shell.sh     # .zshrc write & zsh default shell
│   ├── restore/i7-restore.sh # Create ~/restore.sh
│   └── final/i8-final.sh     # Done message
├── Font/
│   └── font.ttf              # Custom Nerd Font
└── themes/
    └── banner.sh             # RXFETCH-style terminal banner (generated)
```

<br>

## Developer

<p align="center">
  <a href="https://github.com/M41NUL">
    <img src="https://img.shields.io/badge/GitHub-M41NUL-181717?style=flat-square&logo=github" alt="GitHub">
  </a>
  <a href="https://t.me/mdmainulislaminfo">
    <img src="https://img.shields.io/badge/Telegram-Mainul-26A5E4?style=flat-square&logo=telegram&logoColor=white" alt="Telegram">
  </a>
  <a href="https://t.me/codexm41nul">
    <img src="https://img.shields.io/badge/Channel-CODEX--M41NUL-26A5E4?style=flat-square&logo=telegram&logoColor=white" alt="Channel">
  </a>
  <a href="https://t.me/codex_m41nul">
    <img src="https://img.shields.io/badge/Group-codex__m41nul-26A5E4?style=flat-square&logo=telegram&logoColor=white" alt="Group">
  </a>
  <a href="https://youtube.com/@codexm41nul">
    <img src="https://img.shields.io/badge/YouTube-CODEX--M41NUL-FF0000?style=flat-square&logo=youtube&logoColor=white" alt="YouTube">
  </a>
  <a href="mailto:devmainulislam@gmail.com">
    <img src="https://img.shields.io/badge/Email-Contact-D14836?style=flat-square&logo=gmail&logoColor=white" alt="Email">
  </a>
</p>

---

<p align="center">
  <sub>© 2026 CODEX-M41NUL. All Rights Reserved.</sub>
</p>
