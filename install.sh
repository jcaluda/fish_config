#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -r /etc/os-release ]] || ! grep -qE '^(ID|ID_LIKE)=.*(ubuntu|debian)' /etc/os-release; then
    echo "This script requires a Debian-based Linux distribution (Ubuntu or Kubuntu)." >&2
    exit 1
fi

if ! command -v apt-get &> /dev/null; then
    echo "apt-get is required to install Fish and Tmux." >&2
    exit 1
fi

SUDO_CMD=()
if (( EUID != 0 )); then
    if ! command -v sudo &> /dev/null; then
        echo "sudo is required when this script is not run as root." >&2
        exit 1
    fi
    SUDO_CMD=(sudo)
fi

IS_WSL=false
if [[ -n "${WSL_INTEROP:-}" ]] || grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then
    IS_WSL=true
fi

echo "=== Fish Config Installation Script ==="
if [[ "$IS_WSL" == true ]]; then
    echo "Platform: WSL"
else
    echo "Platform: Debian-based Linux"
fi
echo "Repository: $REPO_ROOT"
echo ""

# Step 1: Install Fish
echo "Step 1: Installing Fish shell..."
if command -v fish &> /dev/null; then
    echo "Fish is already installed ($(fish --version))"
else
    echo "Adding Fish PPA..."
    "${SUDO_CMD[@]}" apt-add-repository -y ppa:fish-shell/release-4
    echo "Updating package list..."
    "${SUDO_CMD[@]}" apt-get update
    echo "Installing Fish..."
    "${SUDO_CMD[@]}" apt-get install -y fish
    echo "Fish installed: $(fish --version)"
fi
echo ""

# Step 2: Install Tmux (optional)
echo "Step 2: Installing Tmux (optional)..."
if command -v tmux &> /dev/null; then
    echo "Tmux is already installed ($(tmux -V))"
else
    read -p "Install Tmux? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        "${SUDO_CMD[@]}" apt-get install -y tmux
        echo "Tmux installed: $(tmux -V)"
    else
        echo "Skipping Tmux installation."
    fi
fi
echo ""

# Step 3: Install Fish configuration
echo "Step 3: Installing Fish configuration..."
FISH_CONFIG_DIR="$HOME/.config/fish"
if [[ -d "$FISH_CONFIG_DIR" ]]; then
    read -p "Existing Fish config found at $FISH_CONFIG_DIR. Backup and replace? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        BACKUP_DIR="$HOME/.config/fish.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backing up existing config to $BACKUP_DIR"
        mv "$FISH_CONFIG_DIR" "$BACKUP_DIR"
    else
        echo "Skipping Fish config installation."
        exit 0
    fi
fi

echo "Copying Fish config from $REPO_ROOT/fish to $FISH_CONFIG_DIR"
mkdir -p "$FISH_CONFIG_DIR"
cp -r "$REPO_ROOT/fish/"* "$FISH_CONFIG_DIR/"
echo "Fish configuration installed."
echo ""

# Step 4: Install Tmux configuration
echo "Step 4: Installing Tmux configuration..."
if [[ -f "$REPO_ROOT/tmux/.tmux.conf" ]]; then
    if [[ -f "$HOME/.tmux.conf" ]]; then
        read -p "Existing .tmux.conf found. Backup and replace? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            BACKUP_TMUX="$HOME/.tmux.conf.backup.$(date +%Y%m%d_%H%M%S)"
            echo "Backing up existing .tmux.conf to $BACKUP_TMUX"
            mv "$HOME/.tmux.conf" "$BACKUP_TMUX"
        else
            echo "Skipping Tmux config installation."
        fi
    fi

    if [[ ! -f "$HOME/.tmux.conf" ]] || [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$REPO_ROOT/tmux/.tmux.conf" "$HOME/.tmux.conf"
        echo "Tmux configuration installed."
    fi
else
    echo "No tmux config found in repository."
fi
echo ""

if [[ "$IS_WSL" == true ]]; then
    echo "Step 5: Font installation (MANUAL - Windows side)"
    echo "==============================================="
    echo "Install this font in Windows:"
    echo "  $REPO_ROOT/fonts/DejaVu Sans Mono for Powerline.ttf"
    echo ""
    echo "Step 6: Windows Terminal Configuration (MANUAL)"
    echo "================================================="
    echo "Update the Ubuntu profile with these settings:"
    echo "  - Font face: DejaVu Sans Mono for Powerline"
    echo "  - Font size: 11"
    echo "  - Color scheme: Ottosson"
    echo "  - Background color: #002B36"
    echo ""
    echo "Step 7: Final Steps"
    echo "==================="
    echo "Open a new WSL terminal session to load the configuration."
else
    echo "Step 5: Font installation (MANUAL)"
    echo "==================================="
    echo "Install this font using your desktop environment:"
    echo "  $REPO_ROOT/fonts/DejaVu Sans Mono for Powerline.ttf"
    echo ""
    echo "Step 6: Final Steps"
    echo "==================="
    echo "Open a new terminal session to load the configuration."
fi
echo ""
echo "=== Installation Complete ==="