#!/bin/bash
# ArchLegion2 Optimizations Script

set -e

# === FASE 4: OTTIMIZZAZIONI ===
echo "--- FASE 4: Ottimizzazioni di sistema ---"

# 4.1 Ottimizzazione pacman
sudo sed -i '/^#VerbosePkgLists/s/^#//' /etc/pacman.conf
sudo sed -i '/^#Color/s/^#//' /etc/pacman.conf
sudo sed -i '/^#ParallelDownloads = 5/s/^#//' /etc/pacman.conf
sudo sed -i '/^#ILoveCandy/s/^#//' /etc/pacman.conf

# 4.2 Aggiornamento mirrorlist
sudo pacman -Syu reflector --noconfirm
reflector --verbose --country Italy,Germany,Spain --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# 4.3 Abilitazione multilib
sudo sed -i '/^#\[multilib\]/s/^#//' /etc/pacman.conf
sudo sed -i '/^#Include = \/etc\/pacman.d\/mirrorlist/s/^#//' /etc/pacman.conf

# 4.4 Configurazione shell
echo 'eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)' >> ~/.xprofile
echo 'export SSH_AUTH_SOCK' >> ~/.xprofile
chsh -s /usr/bin/zsh "$USER"

echo "--- Ottimizzazioni completate! ---"
