#!/bin/bash
# ArchLegion2 Optimizations Script

set -e

# Verifica permessi root
if [ "$(id -u)" -ne 0 ]; then
    echo "❌ Errore: Questo script richiede i permessi di root. Per favore esegui con:"
    echo "sudo $0"
    exit 1
fi

echo "--- FASE 4: Ottimizzazioni di sistema ---"

# 4.1 Ottimizzazione pacman
echo "Configurazione pacman..."
[ -f /etc/pacman.conf ] && {
    sed -i '/^#VerbosePkgLists/s/^#//' /etc/pacman.conf
    sed -i '/^#Color/s/^#//' /etc/pacman.conf
    sed -i '/^#ParallelDownloads = 5/s/^#//' /etc/pacman.conf
    sed -i '/^#ILoveCandy/s/^#//' /etc/pacman.conf
}

# 4.2 Aggiornamento mirrorlist
echo "Aggiornamento mirrorlist..."
command -v reflector >/dev/null 2>&1 || {
    echo "Installazione reflector..."
    pacman -Sy --noconfirm reflector
}
[ -d /etc/pacman.d ] && {
    reflector --verbose --country Italy,Germany,Spain --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
}

# 4.3 Abilitazione multilib
echo "Abilitazione multilib..."
[ -f /etc/pacman.conf ] && {
    sed -i '/^#\[multilib\]/s/^#//' /etc/pacman.conf
    sed -i '/^#Include = \/etc\/pacman.d\/mirrorlist/s/^#//' /etc/pacman.conf
}

# 4.4 Configurazione shell
echo "Configurazione shell..."
USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
if [ -d "$USER_HOME" ]; then
    echo 'eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)' >> "$USER_HOME/.xprofile"
    echo 'export SSH_AUTH_SOCK' >> "$USER_HOME/.xprofile"
    chsh -s /usr/bin/zsh "$SUDO_USER"
fi

echo "✅ Ottimizzazioni completate con successo!"

# Sincronizza i dischi per assicurare che tutto sia scritto
sync
