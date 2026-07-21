#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Fish Config Installation Script for WSL 2.0 Ubuntu ==="
echo "Repository: $REPO_ROOT"
echo ""

# Step 1: Install Fish
echo "Step 1: Installing Fish shell..."
if command -v fish &> /dev/null; then
    echo "Fish is already installed ($(fish --version))"
else
    echo "Adding Fish PPA..."
    sudo apt-add-repository -y ppa:fish-shell/release-4
    echo "Updating package list..."
    sudo apt update
    echo "Installing Fish..."
    sudo apt install -y fish
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
        sudo apt install -y tmux
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

# Step 5: Font installation instructions
echo "Step 5: Font installation (MANUAL - must be done on Windows side)"
echo "================================================================="
echo "The Powerline font must be installed on Windows (not in WSL)."
echo "Font file: $REPO_ROOT/fonts/DejaVu Sans Mono for Powerline.ttf"
echo ""
echo "To install:"
echo "1. Open File Explorer and navigate to: \\\\wsl$\\Ubuntu\\home\\$USER\\repos\\fish_config\\fonts\\"
echo "   (or copy the font file to Windows first)"
echo "2. Double-click 'DejaVu Sans Mono for Powerline.ttf'"
echo "3. Click 'Install' in the font preview window"
echo ""

# Step 6: Windows Terminal configuration instructions
echo "Step 6: Windows Terminal Configuration (MANUAL)"
echo "================================================="
echo "Update the Ubuntu profile in Windows Terminal with these settings:"
echo "  - Font face: DejaVu Sans Mono for Powerline"
echo "  - Font size: 11"
echo "  - Color scheme: Ottosson"
echo "  - Background color: #002B36"
echo ""
echo "To configure:"
echo "1. Open Windows Terminal settings (Ctrl+,)"
echo "2. Select 'Ubuntu' profile"
echo "3. Go to Appearance tab"
echo "4. Apply the settings above"
echo ""

# Step 7: Final instructions
echo "Step 7: Final Steps"
echo "==================="
echo "1. Restart WSL: wsl --shutdown (run in PowerShell/CMD)"
echo "2. Open a new Ubuntu terminal in Windows Terminal"
echo "3. Fish should start automatically with the new configuration"
echo ""
echo "=== Installation Complete ==="