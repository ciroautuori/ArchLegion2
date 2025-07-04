#!/bin/bash
# ArchLegion2 Graphical Setup Script

set -e

# === FASE 2: AMBIENTE GRAFICO ===
echo "--- FASE 2: Configurazione ambiente grafico ---"

# 2.1 Configurazione tastiera italiana
sudo localectl set-x11-keymap it

# 2.2 Installazione desktop environment e display manager
sudo pacman -Syu --noconfirm --needed xfce4 xfce4-goodies lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm

# 2.3 Installazione driver NVIDIA
sudo pacman -Syu --noconfirm --needed nvidia nvidia-utils nvidia-settings opencl-nvidia
sudo pacman -Syu --noconfirm --needed optimus-manager optimus-manager-qt
sudo systemctl enable optimus-manager

# 2.4 Installazione tema e personalizzazioni
yay -S --noconfirm xfce4-docklike-plugin

echo "--- Configurazione grafica completata! ---"
