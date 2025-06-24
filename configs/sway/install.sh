#!/bin/bash
# Sway (Wayland) Installation Script for ArchLegion2

# --- Package Installation ---
echo "Installing Sway and essential Wayland ecosystem packages..."

sudo pacman -S --noconfirm --needed \
    sway \
    swaybg \
    swaylock \
    waybar \
    wofi \
    foot \
    grim \
    slurp \
    xdg-desktop-portal-wlr

# --- Dotfile Deployment ---
echo "Deploying custom Sway dotfiles..."

# Create config directories if they don't exist
CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR/sway"
mkdir -p "$CONFIG_DIR/waybar"
mkdir -p "$CONFIG_DIR/foot"

# Copy our custom configs
# Note: This assumes the script is run from the 'scripts' directory
cp -r ../configs/sway/dotfiles/sway/* "$CONFIG_DIR/sway/"
cp -r ../configs/sway/dotfiles/waybar/* "$CONFIG_DIR/waybar/"
cp ../configs/sway/dotfiles/foot.ini "$CONFIG_DIR/foot/"

echo "Dotfiles deployed."

echo "Sway installation and configuration complete."
echo "To start Sway, type 'sway' in the TTY after logging in."
