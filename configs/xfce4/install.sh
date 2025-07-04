#!/bin/bash
# XFCE4 Installation Script for ArchLegion2

# --- Package Installation ---
echo "Installing XFCE4 desktop environment and 'One Dark Pro' aesthetic packages..."

sudo pacman -S --noconfirm --needed \
    xfce4 \
    xfce4-goodies \
    lightdm \
    lightdm-gtk-greeter \
    kitty \
    papirus-icon-theme \
    picom \
    git

# --- Theme and Dotfile Deployment ---
echo "Deploying One Dark Pro theme and custom dotfiles..."

# Create config directories
CONFIG_DIR="$HOME/.config"
THEMES_DIR="$HOME/.themes"
mkdir -p "$CONFIG_DIR/kitty"
mkdir -p "$CONFIG_DIR/picom"
mkdir -p "$THEMES_DIR"

# Clone and install GTK Theme
echo "Installing One Dark Pro GTK theme..."
cp -r ../configs/xfce4/dotfiles/hacker-aesthetic/onedarkdeepGTK/* "$THEMES_DIR/"

# Deploy Kitty config
echo "Deploying Kitty terminal configuration..."
cp ../configs/xfce4/dotfiles/hacker-aesthetic/kitty/kitty.conf "$CONFIG_DIR/kitty/kitty.conf"

# Deploy Picom config for shadows
cp ../configs/xfce4/dotfiles/picom.conf "$CONFIG_DIR/picom/picom.conf"

# Apply XFCE settings for the new theme
echo "Applying One Dark Pro theme to XFCE..."
xfconf-query -c xsettings -p /Net/ThemeName -s "onedarkdeep-deep"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"
xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Papirus-Dark"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s /usr/share/backgrounds/archlinux/arch-wallpaper.jpg

echo "Theme and dotfiles deployed."

# --- Service Configuration ---
echo "Configuring LightDM and enabling service..."
sudo sed -i 's/^theme-name = .*/theme-name = onedarkdeep-deep/' /etc/lightdm/lightdm-gtk-greeter.conf
sudo sed -i 's/^icon-theme-name = .*/icon-theme-name = Papirus-Dark/' /etc/lightdm/lightdm-gtk-greeter.conf
sudo systemctl enable lightdm.service

# --- Final Touches ---
echo "Adding picom to autostart for visual effects..."
cat <<EOF > "$CONFIG_DIR/autostart/picom.desktop"
[Desktop Entry]
Encoding=UTF-8
Version=0.9.4
Type=Application
Name=picom
Comment=X11 compositor
Exec=picom --daemon
OnlyShowIn=XFCE;
StartupNotify=false
Terminal=false
Hidden=false
EOF

echo "XFCE4 installation and configuration complete."
