<div align="center">

<h1>Termux Theme Changer (TTC)</h1>

<p align="center">
  <a href="https://www.zsh.org/" target="_blank">
    <img src="https://img.shields.io/badge/Shell-zsh-339933?style=for-the-badge&logo=gnu&logoColor=white" alt="Shell zsh" />
  </a>
  <a href="https://www.gnu.org/software/bash/" target="_blank">
    <img src="https://img.shields.io/badge/Bash-5.2-339933?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Bash 5.2" />
  </a>
  <a href="https://github.com/M41NUL/termux-theme-changer/stargazers" target="_blank">
    <img src="https://img.shields.io/github/stars/M41NUL/termux-theme-changer?style=for-the-badge&logo=github&labelColor=181717&color=EDEDED&logoColor=white" alt="GitHub Stars" />
  </a>
  <a href="https://github.com/M41NUL/termux-theme-changer/network/members" target="_blank">
    <img src="https://img.shields.io/github/forks/M41NUL/termux-theme-changer?style=for-the-badge&logo=github&labelColor=181717&color=EDEDED&logoColor=white" alt="GitHub Forks" />
  </a>
  <a href="https://github.com/M41NUL/termux-theme-changer/blob/main/LICENSE" target="_blank">
    <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License MIT" />
  </a>
</p>

<p align="center">
  <a href="https://t.me/mdmainulislaminfo" target="_blank">
    <img src="https://img.shields.io/badge/Telegram-29A9EB?style=for-the-badge&logo=telegram&logoColor=white" alt="Telegram" />
  </a>
  <a href="https://t.me/codexm41nul" target="_blank">
    <img src="https://img.shields.io/badge/TG%20Channel-codexm41nul-29A9EB?style=for-the-badge&logo=telegram&logoColor=white" alt="Telegram Channel" />
  </a>
  <a href="https://t.me/codex_m41nul" target="_blank">
    <img src="https://img.shields.io/badge/TG%20Group-codex__m41nul-29A9EB?style=for-the-badge&logo=telegram&logoColor=white" alt="Telegram Group" />
  </a>
  <a href="https://wa.me/8801308850528" target="_blank">
    <img src="https://img.shields.io/badge/WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white" alt="WhatsApp" />
  </a>
  <a href="https://youtube.com/@codexm41nul" target="_blank">
    <img src="https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white" alt="YouTube" />
  </a>
  <a href="mailto:devmainulislam@gmail.com" target="_blank">
    <img src="https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white" alt="Email" />
  </a>
</p>

<br>

<img src="https://raw.githubusercontent.com/M41NUL/termux-theme-changer/main/Startup%20Display.png" width="600px" alt="TTC Startup Screen">

</div>

<br>

## Overview

**Termux Theme Changer (TTC)** is a fully automated, pure-shell Termux customization suite. One command installs everything — dependencies, ZSH plugins, custom fonts, a personalized ASCII banner, and a themed color palette. It also auto-updates from GitHub every time you run `ttc`.

<br>

## Features

- **Pure shell** — no Python required, runs entirely in Bash/ZSH.
- **Auto-install** — missing tools (`git`, `zsh`, `figlet`, `fzf`, etc.) are installed automatically on first run.
- **Auto-update** — checks GitHub on every `ttc` launch and pulls the latest version silently.
- **Force Update** option in menu for immediate sync.
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
- Add auto-update hook to `.zshrc`
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
| `01` | Start full theme installation |
| `02` | View developer profile & contacts |
| `03` | About this tool & version info |
| `04` | Force update from GitHub (hard reset) |
| `00` | Exit TTC |

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

## Auto-Update

Every time `ttc` launches it runs two checks:

| Step | What happens |
|------|-------------|
| On launch | Compares local commit hash with GitHub. Pulls if different. |
| Background (`.zshrc` hook) | Silently fetches in background — next launch is faster. |

Use **Option `04` → Force Update** to hard-reset to latest GitHub version anytime.

<br>

## Auto-Install

On every `ttc` launch, these packages are checked and installed if missing:

```
git   curl   zsh   figlet   fzf   neofetch
```

No user input needed — all done automatically.

<br>

## File Structure

```
termux-theme-changer/
├── ttc.sh                    # Main controller & menu
├── setup.sh                  # One-time installer
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

| | |
|---|---|
| **Name** | Md. Mainul Islam |
| **Alias** | CODEX-M41NUL |
| **GitHub** | [@M41NUL](https://github.com/M41NUL) |
| **Telegram** | [t.me/mdmainulislaminfo](https://t.me/mdmainulislaminfo) |
| **TG Channel** | [t.me/codexm41nul](https://t.me/codexm41nul) |
| **TG Group** | [t.me/codex_m41nul](https://t.me/codex_m41nul) |
| **YouTube** | [youtube.com/@codexm41nul](https://youtube.com/@codexm41nul) |
| **WhatsApp** | [+8801308850528](https://wa.me/8801308850528) |
| **Email** | [devmainulislam@gmail.com](mailto:devmainulislam@gmail.com) |

<br>

## License

[MIT](LICENSE)

---

<div align="center">
  <sub>© 2026 CODEX-M41NUL. All Rights Reserved.</sub>
</div>
