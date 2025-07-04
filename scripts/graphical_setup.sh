#!/bin/bash
# ArchLegion2 Graphical Setup Script
# Configurazione per hardware fisico con supporto NVIDIA Optimus

set -e

# === FASE 2: AMBIENTE GRAFICO ===
echo "--- FASE 2: Configurazione ambiente grafico ---"

# 2.1 Configurazione tastiera italiana
echo "Configuro la tastiera italiana..."
sudo localectl set-x11-keymap it

# 2.2 Installazione desktop environment e display manager
echo "Installo l'ambiente desktop XFCE..."
sudo pacman -Syu --noconfirm --needed xfce4 xfce4-goodies lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm

# 2.3 Installazione driver video e configurazione NVIDIA
echo "Configuro i driver video e NVIDIA Optimus..."
sudo pacman -Syu --noconfirm --needed \
    nvidia nvidia-utils nvidia-settings \
    nvidia-prime \
    bbswitch \
    xorg-xrandr

# 2.4 Installazione e configurazione Optimus Manager
echo "Configuro Optimus Manager..."
yay -S --noconfirm optimus-manager optimus-manager-qt
sudo systemctl enable optimus-manager

# 2.5 Configurazione automatica per ottimizzazione GPU
echo "Configuro l'ottimizzazione della GPU..."
sudo mkdir -p /etc/optimus-manager
cat << 'EOF' | sudo tee /etc/optimus-manager/optimus-manager.conf > /dev/null
[optimus]
# Configurazione NVIDIA come GPU primaria
switching=none
startup_mode=nvidia
pci_power_control=yes
pci_remove=yes
pci_reset=no
EOF

# 2.6 Installazione tema e personalizzazioni
echo "Installo temi e personalizzazioni..."
yay -S --noconfirm xfce4-docklike-plugin

# 2.7 Configurazione Xorg per NVIDIA
cat << 'EOF' | sudo tee /etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf > /dev/null
Section "OutputClass"
    Identifier "intel"
    MatchDriver "i915"
    Driver "modesetting"
EndSection

Section "OutputClass"
    Identifier "nvidia"
    MatchDriver "nvidia-drm"
    Driver "nvidia"
    Option "AllowEmptyInitialConfiguration"
    Option "PrimaryGPU" "yes"
    ModulePath "/usr/lib/nvidia/xorg"
    ModulePath "/usr/lib/xorg/modules"
EndClass
EOF

echo "--- Configurazione grafica completata! ---"
echo "Sistema pronto per l'uso con ottimizzazione NVIDIA Optimus"
