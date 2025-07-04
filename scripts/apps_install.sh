#!/bin/bash
# ArchLegion2 Applications Install Script

set -e

# === FASE 3: APPLICAZIONI ESSENZIALI ===
echo "--- FASE 3: Installazione applicazioni ---"

# 3.1 Installazione AUR helper (yay)
if ! command -v yay &> /dev/null; then
    sudo -u "$USER" bash -c "rm -rf /tmp/yay && git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si --noconfirm"
fi

# 3.2 Installazione applicazioni principali
yay -S --noconfirm \
    anydesk-bin whatsdesk-bin telegram-desktop-bin \
    spotify visual-studio-code-bin obsidian windsurf

# 3.3 Installazione strumenti di sistema
sudo pacman -Syu --noconfirm --needed \
    timeshift gnome-keyring libsecret seahorse

# 3.4 Installazione ottimizzazioni NVIDIA (solo su hardware fisico)
if ! systemd-detect-virt &> /dev/null; then  # Se non siamo in una VM
    echo "Rilevato hardware fisico, installo optimus-manager-qt..."
    yay -S --noconfirm optimus-manager-qt
fi

# 3.5 Configurazione GNOME Keyring
sudo sed -i '/^auth.*pam_gnome_keyring.so/!s/^auth.*/auth optional pam_gnome_keyring.so\n&/' /etc/pam.d/login
sudo sed -i '/^session.*pam_gnome_keyring.so/!s/^session.*/session optional pam_gnome_keyring.so auto_start\n&/' /etc/pam.d/login

echo "--- Installazione applicazioni completata! ---"
