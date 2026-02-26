#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#=======================================
# MAINUL-X THEME INSTALLER - MAIN.PY FILE
# Version: 1.0 | (c) 2026 MAINUL - X
# Developer: MAINUL ISLAM 
# GitHub: M41NUL
# Contact: +8801308850528 
#Gmail: githubmainul@gmail.com
#=======================================

import os
import sys
import time
import subprocess

try:
    import pyfiglet
    from rich.console import Console
    from rich.panel import Panel
    from rich.text import Text
    from rich.table import Table
    from rich.prompt import Prompt
    from rich.columns import Columns
    from rich.align import Align
    from rich import box
except ImportError:
    print("[*] Installing required python libraries (rich, pyfiglet)...")
    os.system("pip install rich pyfiglet")
    import pyfiglet
    from rich.console import Console
    from rich.panel import Panel
    from rich.text import Text
    from rich.table import Table
    from rich.prompt import Prompt
    from rich.columns import Columns
    from rich.align import Align
    from rich import box

console = Console()

AUTHOR = "Md. Mainul Islam"
OWNER = "MAINUL - X"
GITHUB = "M41NUL"
GITHUB_URL = "https://github.com/M41NUL"
WHATSAPP = "+8801308850528"
TELEGRAM = "@mdmainulislaminfo"
EMAIL = "githubmainul@gmail.com"
LICENSE = "MIT License"
COPYRIGHT = "Copyright (c) 2026 MAINUL - X"

def clear_screen():
    os.system('clear' if os.name == 'posix' else 'cls')

def show_banner():
    clear_screen()
    
    ascii_banner = pyfiglet.figlet_format("T T C", font="banner3")
    banner_text = Text(ascii_banner, style="bold cyan")
    console.print(Align.center(banner_text))
    
    console.print(Align.center("[bold white]══════════════════════════════════════════════[/bold white]"))
    console.print(Align.center("[bold yellow]TERMUX THEME CHANGER SYSTEM[/bold yellow]"))
    console.print(Align.center("[bold white]══════════════════════════════════════════════[/bold white]\n"))
    
    info_content = (
        f"[bold cyan]OWNER[/bold cyan]    : [white]{OWNER}[/white]\n"
        f"[bold cyan]GITHUB[/bold cyan]   : [white]{GITHUB}[/white]\n"
        f"[bold cyan]VERSION[/bold cyan]  : [bold yellow]1.0.0[/bold yellow]"
    )
    
    info_panel = Panel(
        Align.center(info_content),
        box=box.DOUBLE,
        border_style="bright_blue",
        padding=(1, 4)
    )
    console.print(Align.center(info_panel))

def show_menu():
    table = Table(
        show_header=True, 
        header_style="bold magenta", 
        border_style="bright_black",
        box=box.ROUNDED
    )
    
    table.add_column("ID", style="bold yellow", justify="center", width=5)
    table.add_column("AVAILABLE OPTIONS", style="bold white", width=40)
    
    table.add_row("01", "Start Theme Customization")
    table.add_row("02", "Developer Profile")
    table.add_row("03", "System Information / About")
    table.add_row("00", "[bold red]Exit Application[/bold red]")
    
    console.print(Align.center(table))

def run_theme_changer():
    clear_screen()
    console.print(Align.center(Panel("[bold green]LOADING SYSTEM MODULES...[/bold green]", border_style="green", box=box.SQUARE)))
    time.sleep(1.5)
    
    base_dir = os.path.expanduser("~/termux-theme-changer")
    installer_dir = os.path.join(base_dir, "installer")
    
    scripts = [
        "env/i1-env.sh", "core/i2-core.sh", "extra/i3-extra.sh",
        "plugins/i4-plugins.sh", "theme/i5-theme.sh", "shell/i6-shell.sh",
        "restore/i7-restore.sh", "final/i8-final.sh"
    ]
    
    for script in scripts:
        script_path = os.path.join(installer_dir, script)
        if os.path.exists(script_path):
            subprocess.run(["bash", script_path])
        else:
            console.print(f"[bold red][!] CRITICAL: {script_path} not found.[/bold red]")
    
    console.print("\n" + "-"*50)
    console.input("[bold yellow]Press Enter to return to Control Panel...[/bold yellow]")

def dev_info():
    clear_screen()
    show_banner()
    
    dev_details = (
        f"[bold cyan]NAME      :[/bold cyan] {AUTHOR}\n"
        f"[bold cyan]ALIAS     :[/bold cyan] {OWNER}\n"
        f"[bold cyan]GITHUB    :[/bold cyan] {GITHUB_URL}\n"
        f"[bold cyan]WHATSAPP  :[/bold cyan] {WHATSAPP}\n"
        f"[bold cyan]TELEGRAM  :[/bold cyan] {TELEGRAM}\n"
        f"[bold cyan]EMAIL     :[/bold cyan] {EMAIL}\n"
        f"[bold cyan]LICENSE   :[/bold cyan] {LICENSE}\n\n"
        f"[bold white]{COPYRIGHT}[/bold white]"
    )
    
    console.print(Align.center(Panel(dev_details, title="[bold green] AUTHOR PROFILE [/bold green]", border_style="green", box=box.DOUBLE, padding=(1, 2))))
    console.input("\n[bold yellow]Press Enter to return...[/bold yellow]")

def about_tool():
    clear_screen()
    show_banner()
    
    about_content = (
        "Advanced Termux environment customization suite.\n\n"
        "[bold yellow]CORE FEATURES:[/bold yellow]\n"
        "1. Automated RXFETCH banner deployment.\n"
        "2. ZSH shell optimization with core plugins.\n"
        "3. High-definition Nerd Font integration.\n"
        "4. One-click system restoration module."
    )
    
    console.print(Align.center(Panel(about_content, title="[bold blue] SYSTEM SPECIFICATIONS [/bold blue]", border_style="yellow", box=box.DOUBLE, padding=(1, 2))))
    console.input("\n[bold yellow]Press Enter to return...[/bold yellow]")

def main():
    while True:
        show_banner()
        console.print("\n")
        show_menu()
        console.print("\n")
        
        choice = Prompt.ask("[bold green]SELECT OPTION[/bold green]", choices=["0", "1", "2", "3", "00", "01", "02", "03"])
        
        if choice in ["1", "01"]:
            run_theme_changer()
        elif choice in ["2", "02"]:
            dev_info()
        elif choice in ["3", "03"]:
            about_tool()
        elif choice in ["0", "00"]:
            console.print("\n[bold red]Shutting down system. Connection closed.[/bold red]\n")
            sys.exit(0)

if __name__ == "__main__":
    main()
