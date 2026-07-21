#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Fish Config Update Script ==="
echo "Repository: $REPO_ROOT"
echo ""

# Step 1: Update Fish configuration
echo "Step 1: Updating Fish configuration..."
FISH_CONFIG_DIR="$HOME/.config/fish"

if [[ ! -d "$FISH_CONFIG_DIR" ]]; then
    echo "Fish config not found at $FISH_CONFIG_DIR. Run install.sh first."
    exit 1
fi

BACKUP_DIR="$HOME/.config/fish.backup.$(date +%Y%m%d_%H%M%S)"
echo "Backing up current Fish config to $BACKUP_DIR"
cp -r "$FISH_CONFIG_DIR" "$BACKUP_DIR"

echo "Copying updated Fish config from $REPO_ROOT/fish to $FISH_CONFIG_DIR"
cp -r "$REPO_ROOT/fish/"* "$FISH_CONFIG_DIR/"
echo "Fish configuration updated."
echo ""

# Step 2: Update Tmux configuration
echo "Step 2: Updating Tmux configuration..."
if [[ -f "$REPO_ROOT/tmux/.tmux.conf" ]]; then
    if [[ -f "$HOME/.tmux.conf" ]]; then
        BACKUP_TMUX="$HOME/.tmux.conf.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backing up current .tmux.conf to $BACKUP_TMUX"
        cp "$HOME/.tmux.conf" "$BACKUP_TMUX"
    fi

    cp "$REPO_ROOT/tmux/.tmux.conf" "$HOME/.tmux.conf"
    echo "Tmux configuration updated."
else
    echo "No tmux config found in repository."
fi
echo ""

# Step 3: Reload instructions
echo "Step 3: Reload Configuration"
echo "============================="
echo "To apply changes in the current shell:"
echo "  - Fish: Run 'reload' (defined in config.fish)"
echo "  - Tmux: Run 'tmux source-file ~/.tmux.conf' (if inside tmux)"
echo ""
echo "Or start a new terminal session to load all changes automatically."
echo ""
echo "=== Update Complete ==="