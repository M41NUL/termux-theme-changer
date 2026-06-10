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
- Fully customized ZSH prompt with colors and modern aesthetics.
- ZSH plugins: autosuggestions, syntax-highlighting, autocomplete, fzf, bgnotify.
- `logo-ls` integration for a modern `ls` experience with icons.
- Custom Nerd Font + `termux.properties` configuration.
- Personalized RXFETCH-style terminal banner with your name.
- Restore script (`restore.sh`) to safely revert Termux to its default state.

<br>

## Installation

> One-time setup — clones the repo and creates the `ttc` command globally.

```bash
pkg install git -y
git clone https://github.com/M41NUL/termux-theme-changer.git
cd termux-theme-changer
bash setup.sh
```

After setup, just type `ttc` from anywhere to launch:

```bash
ttc
```

> **Recommended:** Run on a fresh Termux installation for best results.

<br>

## Usage Flow

```
ttc
 ├── [1] Auto-install missing dependencies
 ├── [2] Auto-update from GitHub (checks commit hash)
 └── [3] Menu
      ├── 01 → Start Theme Installation
      ├── 02 → Developer Profile
      ├── 03 → About This Tool
      ├── 04 → Force Update from GitHub
      └── 00 → Exit
```

<br>

## Restore

To revert Termux to its original clean state:

```bash
bash ~/restore.sh
```

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

## Special Thanks

- [mayTermux](https://github.com/mayTermux) – inspiration for look and UI.
- [Termux](https://termux.dev/) – Android terminal platform.
- [Bash](https://www.gnu.org/software/bash/) – shell scripting.
- [Zsh](https://www.zsh.org/) – modern shell for prompt customization.
- All open-source communities for their support.

<br>

## License

[MIT](LICENSE)

---

<div align="center">
  <sub>© 2026 CODEX-M41NUL. All Rights Reserved.</sub>
</div>
