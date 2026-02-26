<div align="center">

<h1 style="font-size:72px;">
  Termux Theme Changer (TTC)
</h1>
<br>

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
    <img src="https://img.shields.io/badge/Telegram-29A9EB?style=for-the-badge&logo=telegram&logoColor=white" alt="Telegram Contact" />
  </a>
  <a href="https://wa.me/8801308850528" target="_blank">
    <img src="https://img.shields.io/badge/WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white" alt="WhatsApp Contact" />
  </a>
  <a href="mailto:githubmainul@gmail.com" target="_blank">
    <img src="https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white" alt="Email Contact" />
  </a>
</p>

<br>

<img src="https://raw.githubusercontent.com/M41NUL/termux-theme-changer/main/Startup%20Display.png" width="600px" alt="TTC Startup Screen">

</div>

## Overview

**Termux Theme Changer (TTC)** is a one-shot installer for Termux, providing a modern, colorful, and fully customized terminal UI experience. It includes a sleek double-line ASCII banner, colored prompt, Zsh plugins, custom fonts, and a beautifully themed color palette.

<br>

## Features

* One-shot installation via `python main.py`.
* Fully customized Zsh prompt with colors and modern aesthetics.
* Auto-installation of core utilities (git, python, zsh).
* Sleek, double-line box UI with a unique `•_•` ASCII art.
* Logo-ls integration for a modern `ls` experience.
* Custom font and `termux.properties` configuration.
* Restore script (`restore.sh`) to safely revert Termux to its default state.

<br>

## Installation

Clone the repository and run the installer:

~~~bash
apt update && apt upgrade -y
pkg install git python -y
git clone https://github.com/M41NUL/termux-theme-changer.git
cd termux-theme-changer
python main.py
~~~

> Note: It is recommended to run this on a fresh Termux installation. During setup, you can enter your custom name to be displayed in the terminal banner.

<br>

## Restore

> Note: If you want to revert to the original Termux setup, run:

~~~bash
bash ~/restore.sh
~~~

<br>

## Zsh Plugins Installed

* zsh-syntax-highlighting
* zsh-fzf-history-search
* zsh-autosuggestions
* zsh-autocomplete
* bgnotify

> Note: These plugins are automatically installed by the script for an enhanced workflow.

<br>

## Developer

* **Name:** Md. Mainul Islam (MAINUL - X)
* **GitHub:** [@M41NUL](https://github.com/M41NUL)

<br>

## Special Thanks

* [mayTermux](https://github.com/mayTermux) – as inspiration for the look and UI.
* [Termux](https://termux.dev/) – Android terminal platform.
* [Bash](https://www.gnu.org/software/bash/) – shell scripting.
* [Zsh](https://www.zsh.org/) – modern shell for prompt customization.
* All open-source communities are supportive.

<br>

## License

[MIT](LICENSE)
