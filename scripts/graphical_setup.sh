#!/bin/bash
# ArchLegion2 Graphical Setup Script
# Modificato per VM - Rimossi riferimenti a Optimus Manager

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

# 2.3 Installazione driver video (solo pacchetti base, senza NVIDIA per VM)
echo "Configuro i driver video di base..."
sudo pacman -Syu --noconfirm --needed xf86-video-vesa xf86-video-vmware virtualbox-guest-utils

# 2.4 Abilita servizi VirtualBox Guest Utils (se in esecuzione su VirtualBox)
if systemd-detect-virt | grep -q "oracle"; then
    echo "Rilevata macchina virtuale VirtualBox, attivo i guest utils..."
    sudo systemctl enable vboxservice.service
fi

# 2.5 Installazione tema e personalizzazioni
echo "Installo temi e personalizzazioni..."
yay -S --noconfirm xfce4-docklike-plugin

echo "--- Configurazione grafica completata! ---"
echo "Nota: La configurazione NVIDIA è stata omessa in quanto non necessaria in ambiente virtuale."
